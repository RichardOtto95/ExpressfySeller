import 'package:delivery_seller/app/core/services/auth/auth_service_interface.dart';
import 'package:delivery_seller/app/shared/widgets/load_circular_overlay.dart';
import 'package:delivery_seller/app/core/services/auth/auth_store.dart';
import 'package:delivery_seller/app/core/models/seller_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'dart:async';

part 'sign_store.g.dart';

class SignStore = _SignStoreBase with _$SignStore;

abstract class _SignStoreBase with Store {
  final AuthStore authStore = Modular.get();
  // final Seller seller;
  AuthServiceInterface authService = Modular.get();
  @observable
  User? valueUser;
  @observable
  String? phone;
  @observable
  int start = 60;
  @observable
  Timer? timer;

  // @observable
  // _SignStoreBase(this.seller);

  @action
  void setPhone(_phone) => phone = _phone;

  @action
  int getStart() => start;

  @action
  verifyNumber(BuildContext context) async {
    // OverlayEntry overlayEntry =
    //     OverlayEntry(builder: (context) => LoadCircularOverlay());
    // Overlay.of(context)!.insert(overlayEntry);
    authStore.canBack = false;
    print('##### phone $phone');
    String userPhone = '+55' + phone!;
    print('##### userPhone $userPhone');
    await authStore.verifyNumber(phone!, context);
    print('##### afteer verify number');
    // overlayEntry.remove();
  }

  @action
  signinPhone(String _code, String verifyId, context) async {
    print('%%%%%%%% signinPhone %%%%%%%%');
    print('$_code, $verifyId');
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(overlayEntry);
    authStore.canBack = false;
    await authStore.handleSmsSignin(_code, verifyId).then((User? value) async {
      print("Dentro do then");
      print('%%%%%%%% signinPhone2 $value %%%%%%%%');
      if (value != null) {
        valueUser = value;
        DocumentSnapshot _user = await FirebaseFirestore.instance
            .collection('sellers')
            .doc(value.uid)
            .get();

        if (_user.exists) {
          // QuerySnapshot addresses =
          //     await _user.reference.collection("addresses").get();
          print('%%%%%%%% signinPhone _user.exists == true  %%%%%%%%');

          String? tokenString = await FirebaseMessaging.instance.getToken();
          print('tokenId: $tokenString');
          await _user.reference.update({
            'token_id': [tokenString]
          });
          // if (addresses.docs.isEmpty) {
          // Modular.to.pushNamedAndRemoveUntil(
          //   '/address',
          //   (p0) {
          //     print('pushNamedAndRemoveUntil: $p0');
          //     return false;
          //   },
          //   arguments: true
          // );
          // Modular.to.pushReplacementNamed('/address', arguments: true);
          // Modular.to.pushNamed('/address', arguments: true);
          // } else {
          //   Modular.to.pushNamed("/main");
          // }
        } else {
          print('%%%%%%%% signinPhone _user.exists == false  %%%%%%%%');
          Seller seller = Seller(id: value.uid);
          seller.phone = value.phoneNumber;
          await authService.preRegisteredUser(seller);
          // Seller? response = await authService.preRegisteredUser(seller);
          // if(response != null){
          //   seller = response;
          // }
          // await authService.handleSignup(seller);
          // Modular.to.pushNamed('/address', arguments: true);
          // Modular.to.pushReplacementNamed('/address', arguments: true);
        }
        Modular.to.pushNamedAndRemoveUntil(
          '/main',
          (p0) {
            print('pushNamedAndRemoveUntil: $p0');
            return false;
          },
        );
      }
    });

    print("Fora do then");
    overlayEntry.remove();

    authStore.canBack = true;
  }
}
