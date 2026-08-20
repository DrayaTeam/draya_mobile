import "package:flutter/material.dart";

class DrawerItemViewModel {
  final String title;
  final IconData icon;
  final String? route;

  DrawerItemViewModel({
    required this.title,
    required this.icon,
    this.route,
  });
}
