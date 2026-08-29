import 'package:flutter/material.dart';

const Map<String, IconData> _categoryIcons = {
  "shopping_cart": Icons.shopping_cart,
  "directions_car": Icons.directions_car,
  "restaurant": Icons.restaurant,
  "home": Icons.home,
  "local_gas_station": Icons.local_gas_station,
  "flight": Icons.flight,
  "medical_services": Icons.medical_services,
  "fitness_center": Icons.fitness_center,
  "school": Icons.school,
  "pets": Icons.pets,
  "desk": Icons.desk,
  "monitor": Icons.monitor,
  "keyboard": Icons.keyboard,
  "store": Icons.store,
  "work": Icons.work,
};

Color budgetHexToColor(String hex) {
  final h = hex.replaceFirst('#', '');
  return Color(int.parse(h.length == 6 ? 'FF$h' : h, radix: 16));
}

IconData budgetResolveIcon(String iconName) {
  return _categoryIcons[iconName] ?? Icons.category;
}

/// Maps a budget status string to a visual color.
/// OK -> green, WARNING -> amber, EXCEEDED -> red.
Color budgetStatusColor(String status) {
  switch (status.toUpperCase()) {
    case 'WARNING':
      return const Color(0xFFF59E0B);
    case 'EXCEEDED':
      return const Color(0xFFE53935);
    case 'OK':
    default:
      return const Color(0xFF22C55E);
  }
}
