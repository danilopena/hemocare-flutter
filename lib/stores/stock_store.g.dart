// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StockStore on _StockStore, Store {
  Computed<bool> _$isAlrightComputed;

  @override
  bool get isAlright =>
      (_$isAlrightComputed ??= Computed<bool>(() => super.isAlright)).value;

  final _$uidAtom = Atom(name: '_StockStore.uid');

  @override
  String get uid {
    _$uidAtom.context.enforceReadPolicy(_$uidAtom);
    _$uidAtom.reportObserved();
    return super.uid;
  }

  @override
  set uid(String value) {
    _$uidAtom.context.conditionallyRunInAction(() {
      super.uid = value;
      _$uidAtom.reportChanged();
    }, _$uidAtom, name: '${_$uidAtom.name}_set');
  }

  final _$userAtom = Atom(name: '_StockStore.user');

  @override
  ObservableFuture<FirebaseUser> get user {
    _$userAtom.context.enforceReadPolicy(_$userAtom);
    _$userAtom.reportObserved();
    return super.user;
  }

  @override
  set user(ObservableFuture<FirebaseUser> value) {
    _$userAtom.context.conditionallyRunInAction(() {
      super.user = value;
      _$userAtom.reportChanged();
    }, _$userAtom, name: '${_$userAtom.name}_set');
  }

  final _$stockDataAtom = Atom(name: '_StockStore.stockData');

  @override
  ObservableFuture<DocumentSnapshot> get stockData {
    _$stockDataAtom.context.enforceReadPolicy(_$stockDataAtom);
    _$stockDataAtom.reportObserved();
    return super.stockData;
  }

  @override
  set stockData(ObservableFuture<DocumentSnapshot> value) {
    _$stockDataAtom.context.conditionallyRunInAction(() {
      super.stockData = value;
      _$stockDataAtom.reportChanged();
    }, _$stockDataAtom, name: '${_$stockDataAtom.name}_set');
  }

  final _$retrieveUidAsyncAction = AsyncAction('retrieveUid');

  @override
  Future<void> retrieveUid() {
    return _$retrieveUidAsyncAction.run(() => super.retrieveUid());
  }

  final _$retrieveStockDataAsyncAction = AsyncAction('retrieveStockData');

  @override
  Future<void> retrieveStockData() {
    return _$retrieveStockDataAsyncAction.run(() => super.retrieveStockData());
  }

  @override
  String toString() {
    final string =
        'uid: ${uid.toString()},user: ${user.toString()},stockData: ${stockData.toString()},isAlright: ${isAlright.toString()}';
    return '{$string}';
  }
}
