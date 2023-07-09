extension Double2 on double {
  String toFileSize({bool unit = true}) {
    String result;

    if (this >= 1000000) {
      result = (this / 1000000).toStringAsFixed(2) + (unit ? "MB" : "");
    } else if (this >= 1000) {
      result = (this / 1000).toStringAsFixed(2) + (unit ? "KB" : "");
    } else {
      result = unit ? "${this}B" : this.toString();
    }
    return result;
  }
}
