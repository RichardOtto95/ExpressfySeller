// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MainStore on _MainStoreBase, Store {
  final _$pageControllerAtom = Atom(name: '_MainStoreBase.pageController');

  @override
  PageController get pageController {
    _$pageControllerAtom.reportRead();
    return super.pageController;
  }

  @override
  set pageController(PageController value) {
    _$pageControllerAtom.reportWrite(value, super.pageController, () {
      super.pageController = value;
    });
  }

  final _$adsIdAtom = Atom(name: '_MainStoreBase.adsId');

  @override
  String get adsId {
    _$adsIdAtom.reportRead();
    return super.adsId;
  }

  @override
  set adsId(String value) {
    _$adsIdAtom.reportWrite(value, super.adsId, () {
      super.adsId = value;
    });
  }

  final _$pageAtom = Atom(name: '_MainStoreBase.page');

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  final _$visibleNavAtom = Atom(name: '_MainStoreBase.visibleNav');

  @override
  bool get visibleNav {
    _$visibleNavAtom.reportRead();
    return super.visibleNav;
  }

  @override
  set visibleNav(bool value) {
    _$visibleNavAtom.reportWrite(value, super.visibleNav, () {
      super.visibleNav = value;
    });
  }

  final _$paginateEnableAtom = Atom(name: '_MainStoreBase.paginateEnable');

  @override
  bool get paginateEnable {
    _$paginateEnableAtom.reportRead();
    return super.paginateEnable;
  }

  @override
  set paginateEnable(bool value) {
    _$paginateEnableAtom.reportWrite(value, super.paginateEnable, () {
      super.paginateEnable = value;
    });
  }

  final _$menuOverlayAtom = Atom(name: '_MainStoreBase.menuOverlay');

  @override
  OverlayEntry? get menuOverlay {
    _$menuOverlayAtom.reportRead();
    return super.menuOverlay;
  }

  @override
  set menuOverlay(OverlayEntry? value) {
    _$menuOverlayAtom.reportWrite(value, super.menuOverlay, () {
      super.menuOverlay = value;
    });
  }

  final _$globalOverlayAtom = Atom(name: '_MainStoreBase.globalOverlay');

  @override
  OverlayEntry? get globalOverlay {
    _$globalOverlayAtom.reportRead();
    return super.globalOverlay;
  }

  @override
  set globalOverlay(OverlayEntry? value) {
    _$globalOverlayAtom.reportWrite(value, super.globalOverlay, () {
      super.globalOverlay = value;
    });
  }

  final _$sellerOnAtom = Atom(name: '_MainStoreBase.sellerOn');

  @override
  bool get sellerOn {
    _$sellerOnAtom.reportRead();
    return super.sellerOn;
  }

  @override
  set sellerOn(bool value) {
    _$sellerOnAtom.reportWrite(value, super.sellerOn, () {
      super.sellerOn = value;
    });
  }

  final _$changeSellerOnAsyncAction =
      AsyncAction('_MainStoreBase.changeSellerOn');

  @override
  Future changeSellerOn() {
    return _$changeSellerOnAsyncAction.run(() => super.changeSellerOn());
  }

  final _$setPageAsyncAction = AsyncAction('_MainStoreBase.setPage');

  @override
  Future setPage(dynamic _page) {
    return _$setPageAsyncAction.run(() => super.setPage(_page));
  }

  final _$userConnectedAsyncAction =
      AsyncAction('_MainStoreBase.userConnected');

  @override
  Future<void> userConnected(bool connected) {
    return _$userConnectedAsyncAction.run(() => super.userConnected(connected));
  }

  final _$saveTokenToDatabaseAsyncAction =
      AsyncAction('_MainStoreBase.saveTokenToDatabase');

  @override
  Future<void> saveTokenToDatabase(String token) {
    return _$saveTokenToDatabaseAsyncAction
        .run(() => super.saveTokenToDatabase(token));
  }

  final _$_MainStoreBaseActionController =
      ActionController(name: '_MainStoreBase');

  @override
  dynamic setAdsId(dynamic _adsId) {
    final _$actionInfo = _$_MainStoreBaseActionController.startAction(
        name: '_MainStoreBase.setAdsId');
    try {
      return super.setAdsId(_adsId);
    } finally {
      _$_MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setMenuOverlay(OverlayEntry _menuOverlay, dynamic context) {
    final _$actionInfo = _$_MainStoreBaseActionController.startAction(
        name: '_MainStoreBase.setMenuOverlay');
    try {
      return super.setMenuOverlay(_menuOverlay, context);
    } finally {
      _$_MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeMenuOverlay() {
    final _$actionInfo = _$_MainStoreBaseActionController.startAction(
        name: '_MainStoreBase.removeMenuOverlay');
    try {
      return super.removeMenuOverlay();
    } finally {
      _$_MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setVisibleNav(dynamic _visibleNav) {
    final _$actionInfo = _$_MainStoreBaseActionController.startAction(
        name: '_MainStoreBase.setVisibleNav');
    try {
      return super.setVisibleNav(_visibleNav);
    } finally {
      _$_MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageController: ${pageController},
adsId: ${adsId},
page: ${page},
visibleNav: ${visibleNav},
paginateEnable: ${paginateEnable},
menuOverlay: ${menuOverlay},
globalOverlay: ${globalOverlay},
sellerOn: ${sellerOn}
    ''';
  }
}
