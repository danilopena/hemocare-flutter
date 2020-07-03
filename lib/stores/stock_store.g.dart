// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StockStore on _StockStore, Store {
  Computed<double> _$percentageUsedComputed;

  @override
  double get percentageUsed => (_$percentageUsedComputed ??=
          Computed<double>(() => super.percentageUsed))
      .value;

  final _$stockModelAtom = Atom(name: '_StockStore.stockModel');

  @override
  StockModel get stockModel {
    _$stockModelAtom.context.enforceReadPolicy(_$stockModelAtom);
    _$stockModelAtom.reportObserved();
    return super.stockModel;
  }

  @override
  set stockModel(StockModel value) {
    _$stockModelAtom.context.conditionallyRunInAction(() {
      super.stockModel = value;
      _$stockModelAtom.reportChanged();
    }, _$stockModelAtom, name: '${_$stockModelAtom.name}_set');
  }

  final _$isOkToRenderAtom = Atom(name: '_StockStore.isOkToRender');

  @override
  bool get isOkToRender {
    _$isOkToRenderAtom.context.enforceReadPolicy(_$isOkToRenderAtom);
    _$isOkToRenderAtom.reportObserved();
    return super.isOkToRender;
  }

  @override
  set isOkToRender(bool value) {
    _$isOkToRenderAtom.context.conditionallyRunInAction(() {
      super.isOkToRender = value;
      _$isOkToRenderAtom.reportChanged();
    }, _$isOkToRenderAtom, name: '${_$isOkToRenderAtom.name}_set');
  }

  final _$percentageAtom = Atom(name: '_StockStore.percentage');

  @override
  double get percentage {
    _$percentageAtom.context.enforceReadPolicy(_$percentageAtom);
    _$percentageAtom.reportObserved();
    return super.percentage;
  }

  @override
  set percentage(double value) {
    _$percentageAtom.context.conditionallyRunInAction(() {
      super.percentage = value;
      _$percentageAtom.reportChanged();
    }, _$percentageAtom, name: '${_$percentageAtom.name}_set');
  }

  final _$loadCurrentUserAsyncAction = AsyncAction('loadCurrentUser');

  @override
  Future<FirebaseUser> loadCurrentUser() {
    return _$loadCurrentUserAsyncAction.run(() => super.loadCurrentUser());
  }

  final _$setStockDataAsyncAction = AsyncAction('setStockData');

  @override
  Future<void> setStockData() {
    return _$setStockDataAsyncAction.run(() => super.setStockData());
  }

  final _$_StockStoreActionController = ActionController(name: '_StockStore');

  @override
  void setPercentage(double value) {
    final _$actionInfo = _$_StockStoreActionController.startAction();
    try {
      return super.setPercentage(value);
    } finally {
      _$_StockStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsOKToRender(FirebaseUser user) {
    final _$actionInfo = _$_StockStoreActionController.startAction();
    try {
      return super.setIsOKToRender(user);
    } finally {
      _$_StockStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'stockModel: ${stockModel.toString()},isOkToRender: ${isOkToRender.toString()},percentage: ${percentage.toString()},percentageUsed: ${percentageUsed.toString()}';
    return '{$string}';
  }
}
