import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'view_model/add_location_view_model.dart';

class AddLocationScreen extends ConsumerStatefulWidget {
  const AddLocationScreen({super.key});

  @override
  ConsumerState<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends ConsumerState<AddLocationScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addLocationViewModelProvider);
    final notifier = ref.read(addLocationViewModelProvider.notifier);
    final loading = state.isLoading;
    final value = state.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => loading ? null : Navigator.pop(context),
        ),
        title: TextField(
          controller: _controller,
          readOnly: loading,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
          ),
          style: const TextStyle(
            fontSize: 20.0,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.normal,
          ),
          textAlignVertical: TextAlignVertical.center,
          onChanged: notifier.search,
        ),
      ),
      body: loading
          ? Center(
              child: Lottie.asset(
                'assets/icons/loader_animation.json',
                width: 120.0,
                height: 120.0,
              ),
            )
          : (value == null || value.suggestions.isEmpty)
              ? Center(
                  child: Text(
                    value?.errorMessage ?? 'Enter a location name.',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: value.suggestions.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, i) {
                    final city = value.suggestions[i];
                    return ListTile(
                      title: Text(city.name),
                      subtitle: Text(city.displaySubtitle),
                      onTap: () async {
                        final ok = await notifier.addCity(city);
                        if (ok && context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                ),
    );
  }
}
