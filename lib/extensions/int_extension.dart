extension Int2 on int {
  String toFileSize({bool unit = true}) {
    String result;

    if (this >= 1000000) {
      result = (this / 1000000).toStringAsFixed(2) + "MB";
    } else if (this >= 1000) {
      result = (this / 1000).toStringAsFixed(2) + "KB";
    } else {
      result = "${this}B";
    }
    return unit ? result : result.replaceAll(RegExp("[a-zA-Z]"), "");
  }
}

extension Int3 on int? {
  String emptable() {
    if (this == null || this == 0) return "";
    return this.toString();
  }
}
