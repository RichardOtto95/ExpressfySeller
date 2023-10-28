// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SignStore on _SignStoreBase, Store {
  final _$valueUserAtom = Atom(name: '_SignStoreBase.valueUser');

  @override
  User? get valueUser {
    _$valueUserAtom.reportRead();
    return super.valueUser;
  }

  @override
  set valueUser(User? value) {
    _$valueUserAtom.reportWrite(value, super.valueUser, () {
      super.valueUser = value;
    });
  }

  final _$phoneAtom = Atom(name: '_SignStoreBase.phone');

  @override
  String? get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String? value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  final _$startAtom = Atom(name: '_SignStoreBase.start');

  @override
  int get start {
    _$startAtom.reportRead();
    return super.start;
  }

  @override
  set start(int value) {
    _$startAtom.reportWrite(value, super.start, () {
      super.start = value;
    });
  }

  final _$timerAtom = Atom(name: '_SignStoreBase.timer');

  @override
  Timer? get timer {
    _$timerAtom.reportRead();
    return super.timer;
  }

  @override
  set timer(Timer? value) {
    _$timerAtom.reportWrite(value, super.timer, () {
      super.timer = value;
    });
  }

  final _$verifyNumberAsyncAction = AsyncAction('_SignStoreBase.verifyNumber');

  @override
  Future verifyNumber(BuildContext context) {
    return _$verifyNumberAsyncAction.run(() => super.verifyNumber(context));
  }

  final _$signinPhoneAsyncAction = AsyncAction('_SignStoreBase.signinPhone');

  @override
  Future signinPhone(String _code, String verifyId, dynamic context) {
    return _$signinPhoneAsyncAction
        .run(() => super.signinPhone(_code, verifyId, context));
  }

  final _$_SignStoreBaseActionController =
      ActionController(name: '_SignStoreBase');

  @override
  void setPhone(dynamic _phone) {
    final _$actionInfo = _$_SignStoreBaseActionController.startAction(
        name: '_SignStoreBase.setPhone');
    try {
      return super.setPhone(_phone);
    } finally {
      _$_SignStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  int getStart() {
    final _$actionInfo = _$_SignStoreBaseActionController.startAction(
        name: '_SignStoreBase.getStart');
    try {
      return super.getStart();
    } finally {
      _$_SignStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
valueUser: ${valueUser},
phone: ${phone},
start: ${start},
timer: ${timer}
    ''';
  }
}
