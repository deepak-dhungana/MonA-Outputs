class TimeTicker {
  const TimeTicker();

  Stream<int> tick() {
    // +1, since the first value is 0
    return Stream.periodic(const Duration(seconds: 1), (x) => x + 1);
  }
}
