extension Double2 on double {
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