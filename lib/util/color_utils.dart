import 'dart:ui';

class ColorUtils {
  static Color colorFromHexString(String hex) {
    final String hexValue = hex.replaceAll("#", "");
    switch (hexValue.length) {
      case 3:
        final int red = int.parse(hexValue[0] + hexValue[0], radix: 16);
        final int green = int.parse(hexValue[1] + hexValue[1], radix: 16);
        final int blue = int.parse(hexValue[2] + hexValue[2], radix: 16);
        return new Color.fromARGB(255, red, green, blue);
      case 6:
        final int red = int.parse(hexValue.substring(0, 2), radix: 16);
        final int green = int.parse(hexValue.substring(2, 4), radix: 16);
        final int blue = int.parse(hexValue.substring(4, 6), radix: 16);
        return new Color.fromARGB(255, red, green, blue);
      case 8:
        final int alpha = int.parse(hexValue.substring(0, 2), radix: 16);
        final int red = int.parse(hexValue.substring(2, 4), radix: 16);
        final int green = int.parse(hexValue.substring(4, 6), radix: 16);
        final int blue = int.parse(hexValue.substring(6, 8), radix: 16);
        return new Color.fromARGB(alpha, red, green, blue);
      default:
        throw new UnsupportedError("Hex string with unexpected length passed.");
    }
  }
}
