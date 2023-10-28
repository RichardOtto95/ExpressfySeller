// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FinancialStore on _FinancialStoreBase, Store {
  final _$selectMonthAtom = Atom(name: '_FinancialStoreBase.selectMonth');

  @override
  bool get selectMonth {
    _$selectMonthAtom.reportRead();
    return super.selectMonth;
  }

  @override
  set selectMonth(bool value) {
    _$selectMonthAtom.reportWrite(value, super.selectMonth, () {
      super.selectMonth = value;
    });
  }

  final _$monthSelectedAtom = Atom(name: '_FinancialStoreBase.monthSelected');

  @override
  int get monthSelected {
    _$monthSelectedAtom.reportRead();
    return super.monthSelected;
  }

  @override
  set monthSelected(int value) {
    _$monthSelectedAtom.reportWrite(value, super.monthSelected, () {
      super.monthSelected = value;
    });
  }

  final _$_FinancialStoreBaseActionController =
      ActionController(name: '_FinancialStoreBase');

  @override
  void setSelectMonth(dynamic _selectMonth) {
    final _$actionInfo = _$_FinancialStoreBaseActionController.startAction(
        name: '_FinancialStoreBase.setSelectMonth');
    try {
      return super.setSelectMonth(_selectMonth);
    } finally {
      _$_FinancialStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMonthSelected(dynamic _monthSelected) {
    final _$actionInfo = _$_FinancialStoreBaseActionController.startAction(
        name: '_FinancialStoreBase.setMonthSelected');
    try {
      return super.setMonthSelected(_monthSelected);
    } finally {
      _$_FinancialStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectMonth: ${selectMonth},
monthSelected: ${monthSelected}
    ''';
  }
}
