extension IntCount on int {
  String toCountString() {
    return this > 0 ? toString().padLeft(2, '0') : '0';
  }
}

extension DoubleCount on double {
  String toCountString() {
    return this > 0 ? toString().padLeft(2, '0') : '0';
  }

  String formatDouble() {
    // Check if the value is an integer
    if (this == toInt()) {
      return toInt()
          .toString(); // Convert to integer and display without decimals
    } else {
      return toStringAsFixed(3).replaceFirst(
          RegExp(r'\.?0*$'), ''); // Display with up to 3 decimal places
    }
  }
}

extension NumberCount on num {
  String toCountString() {
    return this > 0 ? toString().padLeft(2, '0') : '0';
  }
}
