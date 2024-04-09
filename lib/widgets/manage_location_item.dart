import 'package:flutter/material.dart';

class ManageLocationItem extends StatefulWidget {
  final bool showIcon;
  final String name;
  final String country;
  final String state;
  final String dateAndTime;
  final double temperature;

  const ManageLocationItem({super.key,
  required this.showIcon,
  required this.name,
  required this.country,
  required this.state,
  required this.dateAndTime,
  required this.temperature,
  });

  @override
  State<ManageLocationItem> createState() => _ManageLocationItemState();
}

class _ManageLocationItemState extends State<ManageLocationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Text(widget.name),
          Text("${widget.temperature}º")
        ],
      ),
    );
  }
}
