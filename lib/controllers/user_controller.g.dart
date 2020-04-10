// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserController on UserBase, Store {
  final _$percentAtom = Atom(name: 'UserBase.percent');

  @override
  double get percent {
    _$percentAtom.context.enforceReadPolicy(_$percentAtom);
    _$percentAtom.reportObserved();
    return super.percent;
  }

  @override
  set percent(double value) {
    _$percentAtom.context.conditionallyRunInAction(() {
      super.percent = value;
      _$percentAtom.reportChanged();
    }, _$percentAtom, name: '${_$percentAtom.name}_set');
  }

  final _$initialStockAtom = Atom(name: 'UserBase.initialStock');

  @override
  double get initialStock {
    _$initialStockAtom.context.enforceReadPolicy(_$initialStockAtom);
    _$initialStockAtom.reportObserved();
    return super.initialStock;
  }

  @override
  set initialStock(double value) {
    _$initialStockAtom.context.conditionallyRunInAction(() {
      super.initialStock = value;
      _$initialStockAtom.reportChanged();
    }, _$initialStockAtom, name: '${_$initialStockAtom.name}_set');
  }

  final _$UserBaseActionController = ActionController(name: 'UserBase');

  @override
  dynamic getDocument() {
    final _$actionInfo = _$UserBaseActionController.startAction();
    try {
      return super.getDocument();
    } finally {
      _$UserBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'percent: ${percent.toString()},initialStock: ${initialStock.toString()}';
    return '{$string}';
  }
}
