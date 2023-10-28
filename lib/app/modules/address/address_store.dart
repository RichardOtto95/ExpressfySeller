import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller/app/modules/main/main_store.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:delivery_seller/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:place_picker/place_picker.dart';

part 'address_store.g.dart';

class AddressStore = _AddressStoreBase with _$AddressStore;

abstract class _AddressStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  LocationResult? locationResult;
  @observable
  OverlayEntry? editAddressOverlay;
  @observable
  bool hasAddress = false;
  @observable
  bool addressOverlay = false;
  @observable
  bool canBack = false;
  @observable
  BuildContext? addressPageContext;
  @observable
  User user = FirebaseAuth.instance.currentUser!;

  @action
  getLocationResult(_locationResult) => locationResult = _locationResult;
  @action
  getCanBack() => canBack;

  @action
  newAddress(Map<String, dynamic> addressMap, context, bool editing) async {
    canBack = false;
    print("addressMap: $addressMap");
    print("editing: $editing");
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(overlayEntry);
    String functionName = "newAddress";

    if (editing) {
      functionName = "editAddress";
    }
    print("$functionName");
    await cloudFunction(function: functionName, object: {
      "address": addressMap,
      "collection": "sellers",
      "userId": user.uid,
    });
    overlayEntry.remove();
    canBack = true;
  }

  @action
  setMainAddress(String addressId) async {
    print("setMainAddress");
    final addressQue = await FirebaseFirestore.instance
        .collection("sellers")
        .doc(user.uid)
        .collection("addresses")
        .get();

    for (var addressDoc in addressQue.docs) {
      if (addressDoc.get("main")) {
        await addressDoc.reference.update({"main": false});
      }
    }

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(user.uid)
        .collection("addresses")
        .doc(addressId)
        .update({"main": true});

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(user.uid)
        .update({"main_address": addressId});
  }

  @action
  deleteAddress(context, String addressId) async {
    canBack = false;
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(overlayEntry);
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection("sellers")
        .doc(user.uid)
        .get();

    await _user.reference
        .collection("addresses")
        .doc(addressId)
        .update({"status": "DELETED", "main": false});

    if (_user.get("main_address") == addressId) {
      await _user.reference.update({"main_address": null});
    }

    overlayEntry.remove();
    mainStore.globalOverlay!.remove();
    mainStore.globalOverlay = null;
    canBack = true;
  }
}
