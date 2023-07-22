class FoundMessageWidgetIndexes {
  List<MapEntry<int, int>> list = [];

  int currentIndex = 0;

  MapEntry<int, int> get current => list[currentIndex];

  bool hasNext() => list.isNotEmpty && list.length > currentIndex + 1;

  bool hasPrevious() => list.isNotEmpty && 0 <= currentIndex - 1;

  void setList(List<MapEntry<int, int>> list, [bool revers = false]) {
    this.list = list;
    currentIndex = !revers ? 0 : list.length - 1;
    print("this.list ${this.list}");
  }

  MapEntry<int, int> next() {
    try {
      currentIndex += 1;
      return list[currentIndex];
    } catch (e) {
      throw e;
    }
  }

  MapEntry<int, int> previous() {
    try {
      currentIndex -= 1;
      return list[currentIndex];
    } catch (e) {
      throw e;
    }
  }
}
