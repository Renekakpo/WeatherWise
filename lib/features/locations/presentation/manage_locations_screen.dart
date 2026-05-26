import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/routes.dart';
import '../../../core/services/geolocator_service.dart';
import '../domain/entities/saved_location.dart';
import 'view_model/manage_locations_view_model.dart';
import 'widgets/location_list_item.dart';

class ManageLocationsScreen extends ConsumerStatefulWidget {
  const ManageLocationsScreen({super.key});

  @override
  ConsumerState<ManageLocationsScreen> createState() =>
      _ManageLocationsScreenState();
}

class _ManageLocationsScreenState extends ConsumerState<ManageLocationsScreen> {
  bool _editing = false;
  bool _deviceLocationOn = false;
  final Set<int> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _checkDeviceLocation();
  }

  Future<void> _checkDeviceLocation() async {
    final on = await ref.read(geolocatorServiceProvider).isLocationServiceEnabled();
    if (mounted) setState(() => _deviceLocationOn = on);
  }

  void _toggleEditing() {
    setState(() {
      _editing = !_editing;
      _selectedIds.clear();
    });
  }

  void _toggleSelect(int id) {
    setState(() {
      _selectedIds.contains(id) ? _selectedIds.remove(id) : _selectedIds.add(id);
    });
  }

  void _selectAll(List<SavedLocation> locations) {
    setState(() {
      final allIds = locations.map((l) => l.id).whereType<int>().toSet();
      if (_selectedIds.length == allIds.length) {
        _selectedIds.clear();
      } else {
        _selectedIds
          ..clear()
          ..addAll(allIds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncLocations = ref.watch(manageLocationsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFD),
        leading: IconButton(
          icon: Icon(
            _editing
                ? Icons.select_all_outlined
                : Icons.arrow_back_ios_new_rounded,
          ),
          onPressed: _editing
              ? () => _selectAll(asyncLocations.valueOrNull ?? const [])
              : () => context.pop(),
        ),
        title: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  _editing ? 'Select locations' : 'Manage locations',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: _editing
            ? [
                IconButton(
                  icon: const Icon(Icons.check_rounded),
                  onPressed: () =>
                      _showActionSheet(asyncLocations.valueOrNull ?? const []),
                ),
                IconButton(
                  icon: const Icon(Icons.close_outlined),
                  onPressed: _toggleEditing,
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await context.pushNamed(AppRoute.addLocation.name);
                    ref
                        .read(manageLocationsViewModelProvider.notifier)
                        .refresh();
                  },
                ),
                IconButton(icon: const Icon(Icons.edit), onPressed: _toggleEditing),
              ],
      ),
      body: asyncLocations.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed: $e')),
        data: (locations) {
          if (locations.isEmpty) {
            return const Center(
              child: Text(
                'Press on + to add a location.',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }

          final favorites = locations.where((l) => l.isFavorite).toList();
          final others = locations.where((l) => !l.isFavorite).toList();
          return ListView(
            children: [
              if (favorites.isNotEmpty)
                _Section(title: 'Favourite location', locations: favorites, child: _itemsBuilder),
              if (others.isNotEmpty)
                _Section(title: 'Other locations', locations: others, child: _itemsBuilder),
            ],
          );
        },
      ),
    );
  }

  Widget _itemsBuilder(BuildContext context, SavedLocation location) {
    if (_editing) {
      return ListTile(
        title: Row(
          children: [
            Radio<int>(
              value: location.id ?? -1,
              groupValue:
                  _selectedIds.contains(location.id) ? location.id : null,
              onChanged: (_) {
                if (location.id != null) _toggleSelect(location.id!);
              },
            ),
            Expanded(child: Text(location.name)),
          ],
        ),
        onTap: () {
          if (location.id != null) _toggleSelect(location.id!);
        },
      );
    }
    return GestureDetector(
      onTap: () {
        if (kDebugMode) debugPrint('Item clicked: ${location.name}');
      },
      child: LocationListItem(
        location: location,
        deviceLocationOn: _deviceLocationOn,
      ),
    );
  }

  Future<void> _showActionSheet(List<SavedLocation> all) async {
    if (_selectedIds.isEmpty) return;
    final selected = all.where((l) => _selectedIds.contains(l.id)).toList();
    final favs = selected.where((l) => l.isFavorite).toList();
    final others = selected.where((l) => !l.isFavorite).toList();

    Widget body;
    if (favs.isNotEmpty) {
      body = _Action(
        icon: Icons.delete_outline_rounded,
        label: others.isNotEmpty ? 'Delete all' : 'Delete',
        onTap: _deleteSelected,
      );
    } else if (others.length == 1) {
      body = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Action(
            icon: Icons.star_border_rounded,
            label: 'Set as favorite',
            onTap: () => _setFavoriteSelected(others.first.id),
          ),
          _Action(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            onTap: _deleteSelected,
          ),
        ],
      );
    } else {
      body = _Action(
        icon: Icons.delete_outline_rounded,
        label: 'Delete all',
        onTap: _deleteSelected,
      );
    }

    await showModalBottomSheet<void>(
      context: context,
      builder: (_) => SizedBox(height: 60, child: Center(child: body)),
    );
  }

  Future<void> _deleteSelected() async {
    final notifier = ref.read(manageLocationsViewModelProvider.notifier);
    for (final id in _selectedIds) {
      await notifier.deleteOne(id);
    }
    setState(() {
      _selectedIds.clear();
      _editing = false;
    });
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _setFavoriteSelected(int? id) async {
    if (id == null) return;
    await ref.read(manageLocationsViewModelProvider.notifier).setFavorite(id);
    setState(() {
      _selectedIds.clear();
      _editing = false;
    });
    if (mounted) Navigator.of(context).pop();
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.locations,
    required this.child,
  });
  final String title;
  final List<SavedLocation> locations;
  final Widget Function(BuildContext, SavedLocation) child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: locations.length,
          itemBuilder: (context, i) => child(context, locations[i]),
        ),
      ],
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          Text(label, style: const TextStyle(fontFamily: 'Roboto')),
        ],
      ),
    );
  }
}
