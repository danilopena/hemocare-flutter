// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StockStore on _StockStore, Store {
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

  final _$stockDataAtom = Atom(name: '_StockStore.stockData');

  @override
  DocumentSnapshot get stockData {
    _$stockDataAtom.context.enforceReadPolicy(_$stockDataAtom);
    _$stockDataAtom.reportObserved();
    return super.stockData;
  }

  @override
  set stockData(DocumentSnapshot value) {
    _$stockDataAtom.context.conditionallyRunInAction(() {
      super.stockData = value;
      _$stockDataAtom.reportChanged();
    }, _$stockDataAtom, name: '${_$stockDataAtom.name}_set');
  }

  final _$setUidAsyncAction = AsyncAction('setUid');

  @override
  Future<void> setUid() {
    return _$setUidAsyncAction.run(() => super.setUid());
  }

  final _$_StockStoreActionController = ActionController(name: '_StockStore');

  @override
  void setStockData() {
    final _$actionInfo = _$_StockStoreActionController.startAction();
    try {
      return super.setStockData();
    } finally {
      _$_StockStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = 'uid: ${uid.toString()},stockData: ${stockData.toString()}';
    return '{$string}';
  }
}
