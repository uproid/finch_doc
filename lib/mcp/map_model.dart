class MapModel<A, B> implements Map<A, B> {
  final Map<A, B> data;

  MapModel(this.data);

  @override
  B? operator [](Object? key) => data[key];

  @override
  void operator []=(A key, B value) => data[key] = value;

  @override
  void addAll(Map<A, B> other) => data.addAll(other);

  @override
  void addEntries(Iterable<MapEntry<A, B>> newEntries) =>
      data.addEntries(newEntries);

  @override
  Map<RK, RV> cast<RK, RV>() => data.cast<RK, RV>();

  @override
  void clear() {
    data.clear();
  }

  @override
  bool containsKey(Object? key) {
    return data.containsKey(key);
  }

  @override
  bool containsValue(Object? value) {
    return data.containsValue(value);
  }

  @override
  Iterable<MapEntry<A, B>> get entries => data.entries;

  @override
  void forEach(void Function(A key, B value) action) {
    data.forEach(action);
  }

  @override
  bool get isEmpty => data.isEmpty;

  @override
  bool get isNotEmpty => data.isNotEmpty;

  @override
  Iterable<A> get keys => data.keys;

  @override
  int get length => data.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(A key, B value) convert) {
    return data.map(convert);
  }

  @override
  B putIfAbsent(A key, B Function() ifAbsent) {
    return data.putIfAbsent(key, ifAbsent);
  }

  @override
  B? remove(Object? key) {
    return data.remove(key);
  }

  @override
  void removeWhere(bool Function(A key, B value) test) {
    data.removeWhere(test);
  }

  @override
  B update(A key, B Function(B value) update, {B Function()? ifAbsent}) {
    return data.update(key, update, ifAbsent: ifAbsent);
  }

  @override
  void updateAll(B Function(A key, B value) update) {
    data.updateAll(update);
  }

  @override
  Iterable<B> get values => data.values;
}
