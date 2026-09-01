import 'package:flutter/material.dart';

class IconHelper {
  static const Map<String, IconData> _iconMap = {
    "shopping_cart": Icons.shopping_cart,
    "shopping_bag": Icons.shopping_bag,
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
    "movie": Icons.movie,
    "bolt": Icons.bolt,
    "local_hospital": Icons.local_hospital,
    "account_balance": Icons.account_balance,
    "laptop": Icons.laptop,
  };

  static IconData getIcon(String iconName) {
    return _iconMap[iconName] ?? Icons.category;
  }
}
