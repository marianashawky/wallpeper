import 'package:flutter/material.dart';

import '../../../core/constants/app_info.dart';

IconData categoryIcon(String id) {
  switch (id) {
    case CategoryIds.live:
      return Icons.motion_photos_on_outlined;
    case CategoryIds.anime:
      return Icons.face_retouching_natural_outlined;
    case CategoryIds.nature:
      return Icons.park_outlined;
    case CategoryIds.cars:
      return Icons.directions_car_outlined;
    case CategoryIds.gaming:
      return Icons.sports_esports_outlined;
    case CategoryIds.space:
      return Icons.auto_awesome_outlined;
    case CategoryIds.abstract:
      return Icons.gesture_outlined;
    case CategoryIds.minimal:
      return Icons.crop_square_rounded;
    case CategoryIds.technology:
      return Icons.memory_outlined;
    case CategoryIds.dark:
      return Icons.dark_mode_outlined;
    default:
      return Icons.image_outlined;
  }
}
