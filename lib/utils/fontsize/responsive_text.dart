import 'package:flutter/material.dart';

class ResponsiveText {
  static double getSize(BuildContext context, double size) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    // Define base widths
    double baseWidth = screenWidth < 600 ? 375 : screenWidth < 1200 ? 768 : 1440;

    // Scale factor
    double scaleFactor = screenWidth / baseWidth;

    // Minimum and maximum text sizes for different devices
    double minSize = screenWidth < 600 ? 12: screenWidth < 1200 ? 20 : 28;
    double maxSize = screenWidth < 600 ? 22 : screenWidth < 1200 ? 30 : 40;

    return (size * scaleFactor).clamp(minSize, maxSize);
  }}



class ResponsiveBox {
  static double getSize(BuildContext context, double size) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    // Define base widths
    double baseWidth = screenWidth < 600 ? 375 : screenWidth < 1200 ? 768 : 1440;

    // Scale factor
    double scaleFactor = screenWidth / baseWidth;

    // Minimum and maximum box sizes for different devices
    double minSize = screenWidth < 600 ? 10 : screenWidth < 1200 ? 30 : 70;
    double maxSize = screenWidth < 600 ? 600 : screenWidth < 1200 ? 1200 : 1800;

    return (size * scaleFactor).clamp(minSize, maxSize);
  }
}
