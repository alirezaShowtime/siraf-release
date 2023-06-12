extension String2 on String? {
  bool isFill() {
    return this != null && this!.trim().isNotEmpty;
  }
}
