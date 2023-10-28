import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller/app/core/services/auth/auth_store.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
// import '../../core/models/seller_model.dart';
part 'main_store.g.dart';

class MainStore = _MainStoreBase with _$MainStore;

abstract class _MainStoreBase with Store implements Disposable {
  final AuthStore authStore = Modular.get();
  _MainStoreBase() {
    print('_MainStoreBase');
    authStore.setUser(FirebaseAuth.instance.currentUser);
    // sellerSubscription = FirebaseFirestore.instance
    //     .collection("sellers")
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .snapshots()
    //     .listen((event) {
    //   print('_MainStoreBase event: ${event.id}');
    //   seller = Seller.fromDoc(event);
    // });
  }
  @observable
  PageController pageController = PageController(initialPage: 0);
  @observable
  String adsId = '';
  @observable
  int page = 0;
  @observable
  bool visibleNav = true;
  @observable
  bool paginateEnable = true;
  @observable
  OverlayEntry? menuOverlay;
  @observable
  OverlayEntry? globalOverlay;
  @observable
  bool sellerOn = false;
  // @observable
  // StreamSubscription? sellerSubscription;
  // @observable
  // Seller? seller;

  @action
  changeSellerOn() async {
    User? _user = FirebaseAuth.instance.currentUser;
    final userDoc = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user!.uid)
        .get();

    print("MainAddress: ${userDoc.get("main_address")}");

    if (userDoc.get("main_address") != null &&
        userDoc.get("status") != 'UNDER-ANALYSIS') {
      sellerOn = !sellerOn;
      userDoc.reference.update({
        'online': sellerOn,
      });

      FirebaseFirestore.instance
          .collection('sellers')
          .doc(_user.uid)
          .collection('ads')
          .get()
          .then((QuerySnapshot adsQuery) {
        adsQuery.docs.forEach((DocumentSnapshot adsDoc) {
          adsDoc.reference.update({
            "online_seller": sellerOn,
          });
          FirebaseFirestore.instance
              .collection('ads')
              .doc(adsDoc.id)
              .update({"online_seller": sellerOn});
        });
      });
    } else if (userDoc.get("status") == 'UNDER-ANALYSIS') {
      showToast("Aguarde a aprovação da sua conta para ficar online");
    } else if (userDoc.get("main_address") == null) {
      showToast("Defina um endereço como principal para ficar online");
    }
  }

  @action
  setAdsId(_adsId) => adsId = _adsId;

  @action
  setMenuOverlay(OverlayEntry _menuOverlay, context) {
    if (menuOverlay == null) {
      // print('menuOverlay == null');
      // print('gerOverlayEntry: $_menuOverlay');
      menuOverlay = _menuOverlay;
      // print('menuOverlay: $menuOverlay');
      // print('menuOverlay ?? _menuOverlay ${menuOverlay ?? _menuOverlay}');
      Overlay.of(context)?.insert(menuOverlay ?? _menuOverlay);
    } else {
      // menuOverlay?.remove();
      // menuOverlay = null;
      menuOverlay?.dispose();
      menuOverlay = _menuOverlay;
      Overlay.of(context)?.insert(menuOverlay ?? _menuOverlay);
    }
  }

  @action
  removeMenuOverlay() {
    if (menuOverlay != null) {
      menuOverlay!.remove();
      menuOverlay = null;
    }
  }

  @action
  setVisibleNav(_visibleNav) => visibleNav = _visibleNav;

  @override
  void dispose() {
    print('dispose main store');
    pageController.dispose();
    // if (sellerSubscription != null) sellerSubscription!.cancel();
  }

  @action
  setPage(_page) async {
    if (paginateEnable) {
      if (menuOverlay != null) {
        menuOverlay?.remove();
        menuOverlay = null;
      }
      await pageController.animateToPage(
        _page,
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
      page = _page;
    }
  }

  @action
  Future<void> userConnected(bool connected) async {
    final User? _userAuth = FirebaseAuth.instance.currentUser;
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_userAuth!.uid)
        .get();

    _user.reference.update({'connected': connected});
  }

  @action
  Future<void> saveTokenToDatabase(String token) async {
    User? _user = FirebaseAuth.instance.currentUser;
    print('saveTokenToDatabase: $_user');

    if (_user != null) {
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(_user.uid)
          .update({
        'token_id': FieldValue.arrayUnion([token]),
      });
    }
  }
}
