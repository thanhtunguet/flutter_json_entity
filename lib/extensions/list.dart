extension DistinctList<T> on List<T> {
  List<T> distinctBy<Key>(Key Function(T) getKey) {
    final seenIds = <Key>{};
    return where((item) {
      final id = getKey(item);
      if (seenIds.contains(id)) {
        return false;
      } else {
        seenIds.add(id);
        return true;
      }
    }).toList();
  }
}
