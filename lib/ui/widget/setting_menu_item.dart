import 'package:flutter/material.dart';

class SettingMenuItem extends StatelessWidget {
  const SettingMenuItem(
    this.index, {
    Key? key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  final int index;
  final ValueChanged<int>? onTap;
  final String? subtitle;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      onTap: onTap != null ? () => onTap!(index) : null,
    );
  }
}
