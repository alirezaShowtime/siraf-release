extension String2 on String? {
  bool isFill() {
    return this != null && this!.trim().isNotEmpty;
  }
}
extension String3 on String {
  double toDouble() => double.parse(this);

  bool isFill() {
    return this.trim().isNotEmpty;
  }
}
