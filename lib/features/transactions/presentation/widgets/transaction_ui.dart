import 'package:flutter/material.dart';

const Map<String, IconData> _categoryIcons = {
  "shopping_cart": Icons.shopping_cart,
  "directions_car": Icons.directions_car,
  "restaurant": Icons.restaurant,
  "home": Icons.home,
  "local_gas_station": Icons.local_gas_station,
  "flight": Icons.flight,
  "medical_services": Icons.medical_services,
  "checkroom": Icons.checkroom,
  "video_library": Icons.video_library,
  "more_horiz": Icons.more_horiz,
  "pets": Icons.pets,
  "fitness_center": Icons.fitness_center,
  "school": Icons.school,
  "desk": Icons.desk,
  "monitor": Icons.monitor,
  "keyboard": Icons.keyboard,
  "store": Icons.store,
  "work": Icons.work,
  "category": Icons.category,
};

Color transactionHexToColor(String hex) {
  final h = hex.replaceFirst('#', '');
  return Color(int.parse(h.length == 6 ? 'FF$h' : h, radix: 16));
}

IconData transactionResolveIcon(String iconName) {
  return _categoryIcons[iconName] ?? Icons.category;
}

String formatTransactionDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

String formatTransactionTime(DateTime date) {
  final hour = date.hour;
  final minute = date.minute;
  final amPm = hour >= 12 ? 'PM' : 'AM';
  final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  return '${h.toString().padLeft(2, ' ')}:${minute.toString().padLeft(2, '0')} $amPm';
}
