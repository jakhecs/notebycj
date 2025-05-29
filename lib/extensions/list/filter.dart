extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> localFilter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
