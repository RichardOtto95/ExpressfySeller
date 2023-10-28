// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AuthStore on _AuthStoreBase, Store {
  final _$statusAtom = Atom(name: '_AuthStoreBase.status');

  @override
  AuthStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(AuthStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$userVerifyIdAtom = Atom(name: '_AuthStoreBase.userVerifyId');

  @override
  String? get userVerifyId {
    _$userVerifyIdAtom.reportRead();
    return super.userVerifyId;
  }

  @override
  set userVerifyId(String? value) {
    _$userVerifyIdAtom.reportWrite(value, super.userVerifyId, () {
      super.userVerifyId = value;
    });
  }

  final _$mobileAtom = Atom(name: '_AuthStoreBase.mobile');

  @override
  String get mobile {
    _$mobileAtom.reportRead();
    return super.mobile;
  }

  @override
  set mobile(String value) {
    _$mobileAtom.reportWrite(value, super.mobile, () {
      super.mobile = value;
    });
  }

  final _$phoneMobileAtom = Atom(name: '_AuthStoreBase.phoneMobile');

  @override
  String? get phoneMobile {
    _$phoneMobileAtom.reportRead();
    return super.phoneMobile;
  }

  @override
  set phoneMobile(String? value) {
    _$phoneMobileAtom.reportWrite(value, super.phoneMobile, () {
      super.phoneMobile = value;
    });
  }

  final _$linkedAtom = Atom(name: '_AuthStoreBase.linked');

  @override
  bool get linked {
    _$linkedAtom.reportRead();
    return super.linked;
  }

  @override
  set linked(bool value) {
    _$linkedAtom.reportWrite(value, super.linked, () {
      super.linked = value;
    });
  }

  final _$codeSentAtom = Atom(name: '_AuthStoreBase.codeSent');

  @override
  bool get codeSent {
    _$codeSentAtom.reportRead();
    return super.codeSent;
  }

  @override
  set codeSent(bool value) {
    _$codeSentAtom.reportWrite(value, super.codeSent, () {
      super.codeSent = value;
    });
  }

  final _$sellerBDAtom = Atom(name: '_AuthStoreBase.sellerBD');

  @override
  Seller? get sellerBD {
    _$sellerBDAtom.reportRead();
    return super.sellerBD;
  }

  @override
  set sellerBD(Seller? value) {
    _$sellerBDAtom.reportWrite(value, super.sellerBD, () {
      super.sellerBD = value;
    });
  }

  final _$canBackAtom = Atom(name: '_AuthStoreBase.canBack');

  @override
  bool get canBack {
    _$canBackAtom.reportRead();
    return super.canBack;
  }

  @override
  set canBack(bool value) {
    _$canBackAtom.reportWrite(value, super.canBack, () {
      super.canBack = value;
    });
  }

  final _$signinWithGoogleAsyncAction =
      AsyncAction('_AuthStoreBase.signinWithGoogle');

  @override
  Future<dynamic> signinWithGoogle() {
    return _$signinWithGoogleAsyncAction.run(() => super.signinWithGoogle());
  }

  final _$linkAccountGoogleAsyncAction =
      AsyncAction('_AuthStoreBase.linkAccountGoogle');

  @override
  Future<dynamic> linkAccountGoogle() {
    return _$linkAccountGoogleAsyncAction.run(() => super.linkAccountGoogle());
  }

  final _$getUserAsyncAction = AsyncAction('_AuthStoreBase.getUser');

  @override
  Future<dynamic> getUser() {
    return _$getUserAsyncAction.run(() => super.getUser());
  }

  final _$siginEmailAsyncAction = AsyncAction('_AuthStoreBase.siginEmail');

  @override
  Future<dynamic> siginEmail(String email, String password) {
    return _$siginEmailAsyncAction.run(() => super.siginEmail(email, password));
  }

  final _$signoutAsyncAction = AsyncAction('_AuthStoreBase.signout');

  @override
  Future<dynamic> signout() {
    return _$signoutAsyncAction.run(() => super.signout());
  }

  final _$sentSMSAsyncAction = AsyncAction('_AuthStoreBase.sentSMS');

  @override
  Future<dynamic> sentSMS(String userPhone) {
    return _$sentSMSAsyncAction.run(() => super.sentSMS(userPhone));
  }

  final _$verifyNumberAsyncAction = AsyncAction('_AuthStoreBase.verifyNumber');

  @override
  Future<dynamic> verifyNumber(String userPhone, BuildContext context) {
    return _$verifyNumberAsyncAction
        .run(() => super.verifyNumber(userPhone, context));
  }

  final _$handleSmsSigninAsyncAction =
      AsyncAction('_AuthStoreBase.handleSmsSignin');

  @override
  Future<User?> handleSmsSignin(String smsCode, String verificationId) {
    return _$handleSmsSigninAsyncAction
        .run(() => super.handleSmsSignin(smsCode, verificationId));
  }

  final _$_AuthStoreBaseActionController =
      ActionController(name: '_AuthStoreBase');

  @override
  bool getCanBack() {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.getCanBack');
    try {
      return super.getCanBack();
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCodeSent(bool _valc) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.setCodeSent');
    try {
      return super.setCodeSent(_valc);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLinked(bool _vald) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.setLinked');
    try {
      return super.setLinked(_vald);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getUserVerifyiD() {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.getUserVerifyiD');
    try {
      return super.getUserVerifyiD();
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUser(User? user) {
    final _$actionInfo = _$_AuthStoreBaseActionController.startAction(
        name: '_AuthStoreBase.setUser');
    try {
      return super.setUser(user);
    } finally {
      _$_AuthStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
status: ${status},
userVerifyId: ${userVerifyId},
mobile: ${mobile},
phoneMobile: ${phoneMobile},
linked: ${linked},
codeSent: ${codeSent},
sellerBD: ${sellerBD},
canBack: ${canBack}
    ''';
  }
}
