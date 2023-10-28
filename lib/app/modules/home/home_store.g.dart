// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on _HomeStoreBase, Store {
  final _$valueAtom = Atom(name: '_HomeStoreBase.value');

  @override
  int get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(int value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$nowDateAtom = Atom(name: '_HomeStoreBase.nowDate');

  @override
  DateTime get nowDate {
    _$nowDateAtom.reportRead();
    return super.nowDate;
  }

  @override
  set nowDate(DateTime value) {
    _$nowDateAtom.reportWrite(value, super.nowDate, () {
      super.nowDate = value;
    });
  }

  final _$getTotalAmountAsyncAction =
      AsyncAction('_HomeStoreBase.getTotalAmount');

  @override
  Future<num> getTotalAmount() {
    return _$getTotalAmountAsyncAction.run(() => super.getTotalAmount());
  }

  final _$getStatisticsAsyncAction =
      AsyncAction('_HomeStoreBase.getStatistics');

  @override
  Future<List<Map<String, dynamic>>> getStatistics(int index) {
    return _$getStatisticsAsyncAction.run(() => super.getStatistics(index));
  }

  final _$_HomeStoreBaseActionController =
      ActionController(name: '_HomeStoreBase');

  @override
  void increment() {
    final _$actionInfo = _$_HomeStoreBaseActionController.startAction(
        name: '_HomeStoreBase.increment');
    try {
      return super.increment();
    } finally {
      _$_HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
nowDate: ${nowDate}
    ''';
  }
}
