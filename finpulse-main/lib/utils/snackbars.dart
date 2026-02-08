import 'package:flutter/material.dart';

class SnackBars {
  static SnackBar info(String message) {
    return SnackBar(
      content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: const Color(0xFF29D6C7), // Teal accent
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(12),
    );
  }
  
  static SnackBar success(String message) {
    return SnackBar(
      content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: const Color(0xFF10B981), // Green
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(12),
    );
  }
  
  static SnackBar error(String message) {
    return SnackBar(
      content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: const Color(0xFFEF4444), // Red
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(12),
    );
  }
}
