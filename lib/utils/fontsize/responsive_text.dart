import 'package:flutter/material.dart';

class ResponsiveText {
  static double getSize(BuildContext context, double size) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    // Define base widths
    double baseWidth = screenWidth < 600 ? 375 : screenWidth < 1200 ? 768 : 1440;

    // Scale factor
    double scaleFactor = screenWidth / baseWidth;

    // Minimum and maximum text sizes for different devices
    double minSize = screenWidth < 600 ? 12: screenWidth < 1200 ? 16 : 22;
    double maxSize = screenWidth < 600 ? 20 : screenWidth < 1200 ? 35 : 32;

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
    double minSize = screenWidth < 600 ? 10 : screenWidth < 1200 ? 20 : 40;
    double maxSize = screenWidth < 600 ? 500 : screenWidth < 1200 ? 400 : 600;

    return (size * scaleFactor).clamp(minSize, maxSize);
  }
}
