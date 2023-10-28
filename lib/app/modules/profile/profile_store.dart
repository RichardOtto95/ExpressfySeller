import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller/app/modules/main/main_store.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:delivery_seller/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mime/mime.dart';
import 'package:mobx/mobx.dart';

import '../../core/models/rating_model.dart';

part 'profile_store.g.dart';

class ProfileStore = _ProfileStoreBase with _$ProfileStore;

abstract class _ProfileStoreBase with Store {
  _ProfileStoreBase() {
    createSupport();
  }

  final MainStore mainStore = Modular.get();

  late OverlayEntry loadOverlay;

  @observable
  ObservableMap profileEdit = {}.asObservable();
  @observable
  bool birthdayValidate = false;
  @observable
  bool bankValidate = false;
  @observable
  bool genderValidate = false;
  @observable
  bool avatarValidate = false;
  @observable
  bool canBack = true;
  @observable
  bool concluded = false;
  @observable
  TextEditingController textController = TextEditingController();
  @observable
  List<File>? images = [];
  @observable
  List<String>? imagesName = [];
  @observable
  bool imagesBool = false;
  @observable
  File? cameraImage;
  @observable
  String? orderId;
  @observable
  String? raitingId;
  @observable
  Map<dynamic, dynamic> answerMap = {};

  @action
  setCanBack(_canBack) => canBack = _canBack;
  @action
  bool getCanBack() => canBack;

  @action
  setConcluded(bool _concluded) => concluded = _concluded;

  // @action
  // setAnswered(bool _answered) => answered = _answered;

  @action
  Future<void> clearNewRatings() async {
    print('clearNewRatings');
    User? _user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user!.uid)
        .update({
      "new_ratings": 0,
    });
    setProfileEditFromDoc();
  }

  @action
  Future<void> clearNewQuestions() async {
    print('clearNewQuestions');
    User? _user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user!.uid)
        .update({
      "new_questions": 0,
    });
    setProfileEditFromDoc();
  }

  @action
  Future<void> clearNewSupportMessages() async {
    print('clearNewSupportMessages');
    User? _user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_user!.uid)
        .update({
      "new_support_messages": 0,
    });
    setProfileEditFromDoc();
  }

  @action
  Future<void> pickAvatar() async {
    final User? _userAuth = FirebaseAuth.instance.currentUser;
    profileEdit['avatar'] = '';

    File? _imageFile = await pickImage();
    if (_imageFile != null) {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('sellers/${_userAuth!.uid}/avatar/$_imageFile');

      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;

      // taskSnapshot.ref.getDownloadURL().then((downloadURL) async {
      //   print(
      //       'downloadURLdownloadURLdownloadURLdownloadURLdownloadURL    $downloadURL');
      //   profileEdit['avatar'] = downloadURL;
      //   avatarValidate = false;
      // });
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      print(
          'downloadURLdownloadURLdownloadURLdownloadURLdownloadURL    $downloadURL');
      profileEdit['avatar'] = downloadURL;
      avatarValidate = false;
    }
  }

  @action
  Future saveProfile(context) async {
    final User? _userAuth = FirebaseAuth.instance.currentUser;
    loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);
    Map<String, dynamic> _profileMap = profileEdit.cast();
    // print("_profileMap: $_profileMap");
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_userAuth!.uid)
        .update(_profileMap);
    loadOverlay.remove();
    Modular.to.pop();
  }

  @action
  bool getValidate() {
    if (profileEdit['birthday'] == null) {
      birthdayValidate = true;
    } else {
      birthdayValidate = false;
    }

    if (profileEdit['bank'] == null || profileEdit['bank'] == '') {
      bankValidate = true;
    } else {
      bankValidate = false;
    }

    if (profileEdit['gender'] == null || profileEdit['gender'] == '') {
      genderValidate = true;
    } else {
      genderValidate = false;
    }

    if (profileEdit['avatar'] == null || profileEdit['avatar'] == '') {
      avatarValidate = true;
    } else {
      avatarValidate = false;
    }

    return !birthdayValidate &&
        !bankValidate &&
        !genderValidate &&
        !avatarValidate;
  }

  @action
  changeNotificationEnabled(bool change) async {
    print('changeNotificationEnabled $change');
    profileEdit['notification_enabled'] = change;
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(profileEdit['id'])
        .update({'notification_enabled': change});
  }

  @action
  setProfileEditFromDoc() async {
    final User? _userAuth = FirebaseAuth.instance.currentUser;

    DocumentSnapshot _ds = await FirebaseFirestore.instance
        .collection("sellers")
        .doc(_userAuth?.uid)
        .get();
    Map<String, dynamic> map = _ds.data() as Map<String, dynamic>;
    map['linked_to_cnpj'] = map['linked_to_cnpj'] ?? false;
    map['savings_account'] = map['savings_account'] ?? false;
    ObservableMap<String, dynamic> sellerMap = map.asObservable();
    profileEdit = sellerMap;
    // print("Seller Map: $sellerMap");
    // print("Username: ${sellerMap['username']}");
  }

  @action
  setBirthday(context, Function callBack) async {
    DateTime? _birthday;
    // await selectDate(context,
    //     initialDate: profileEdit['birthday'] != null
    //         ? profileEdit['birthday'].toDate()
    //         : DateTime.now());
    await pickDate(
      context,
      onConfirm: (_date) {
        _birthday = _date;
        print('setBirthday: $_birthday - ${profileEdit['birthday']}');
        if (_birthday != null && _birthday != profileEdit['birthday']) {
          profileEdit['birthday'] = Timestamp.fromDate(_birthday!);
          birthdayValidate = false;
          callBack();
        }
      },
      initialDate: profileEdit['birthday'] != null
          ? profileEdit['birthday'].toDate()
          : DateTime.now(),
    );
  }

  Future<void> setTokenLogout() async {
    final User? _userAuth = FirebaseAuth.instance.currentUser;
    String? token = await FirebaseMessaging.instance.getToken();
    print('user token: $token');
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(_userAuth!.uid)
        .get();

    List tokens = _user['token_id'];
    print('tokens length: ${tokens.length}');

    for (var i = 0; i < tokens.length; i++) {
      if (tokens[i] == token) {
        print('has $token');
        tokens.removeAt(i);
        print('tokens: $tokens');
      }
    }
    print('tokens2: $tokens');
    _user.reference.update({'token_id': tokens});
  }

  @action
  Future<void> answerAvaliation(
      Map<dynamic, dynamic> mapAnswer, context) async {
    User? _user = FirebaseAuth.instance.currentUser;
    print('answerAvaliation $mapAnswer');
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);
    canBack = false;
    List<Object> rating = [];
    mapAnswer.forEach((key, value) {
      rating.add({
        "ads_id": key,
        "answer": value,
      });
    });

    await cloudFunction(function: "answerAvaliation", object: {
      "rating": rating,
      "orderId": orderId,
      // "sellerId": 'dlEJdrp6q9YF6uphwaS5zRtQ4Yi2',
      "sellerId": _user!.uid,
    });

    Modular.to.pop();
    loadOverlay.remove();
    answerMap = {};
    canBack = true;
  }

  @action
  Future answerQuestion(String questionId, String answer, context) async {
    final User? _userAuth = FirebaseAuth.instance.currentUser;

    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);
    canBack = false;

    await cloudFunction(function: "toAnswer", object: {
      "questionId": questionId,
      "answer": answer,
      "sellerId": _userAuth!.uid,
    });

    loadOverlay.remove();
    canBack = true;
  }

  @action
  Future<void> createSupport() async {
    User? _user = FirebaseAuth.instance.currentUser;

    QuerySnapshot supportQuery = await FirebaseFirestore.instance
        .collection("supports")
        .where("user_id", isEqualTo: _user!.uid)
        .where("user_collection", isEqualTo: "SELLERS")
        .get();

    print("create support: ${supportQuery.docs.isEmpty}");

    if (supportQuery.docs.isEmpty) {
      DocumentReference suporteRef =
          await FirebaseFirestore.instance.collection("supports").add({
        "user_id": _user.uid,
        "id": null,
        "created_at": FieldValue.serverTimestamp(),
        "updated_at": FieldValue.serverTimestamp(),
        "support_notification": 0,
        "last_update": "",
        "user_collection": "SELLERS",
      });
      await suporteRef.update({"id": suporteRef.id});
    }
  }

  @action
  Future<void> sendSupportMessage() async {
    if (textController.text == "") return;
    User? _user = FirebaseAuth.instance.currentUser;
    QuerySnapshot supportQuery = await FirebaseFirestore.instance
        .collection("supports")
        .where("user_id", isEqualTo: _user!.uid)
        .where("user_collection", isEqualTo: "SELLERS")
        .get();

    print('supportQuery.docs.isNotEmpty: ${supportQuery.docs.isNotEmpty}');
    if (supportQuery.docs.isNotEmpty) {
      DocumentReference messageRef =
          await supportQuery.docs.first.reference.collection("messages").add({
        "id": null,
        "author": _user.uid,
        "text": textController.text,
        "created_at": FieldValue.serverTimestamp(),
        "file": null,
        "file_type": null,
      });

      await messageRef.update({
        "id": messageRef.id,
      });

      await supportQuery.docs.first.reference.update({
        "last_update": textController.text,
        "support_notification": FieldValue.increment(1),
      });
    }
    textController.clear();
  }

  @action
  Future sendImage(context) async {
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);

    User? _user = FirebaseAuth.instance.currentUser;

    List<File> _images = cameraImage == null ? images! : [cameraImage!];

    QuerySnapshot supportQuery = await FirebaseFirestore.instance
        .collection("supports")
        .where("user_id", isEqualTo: _user!.uid)
        .where("user_collection", isEqualTo: "SELLERS")
        .get();

    if (supportQuery.docs.isNotEmpty) {
      DocumentSnapshot supportDoc = supportQuery.docs.first;
      for (int i = 0; i < _images.length; i++) {
        File _imageFile = _images[i];
        String _imageName = imagesName![i];

        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('supports/${_user.uid}/images/$_imageName');

        UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);

        TaskSnapshot taskSnapshot = await uploadTask;

        String imageString = await taskSnapshot.ref.getDownloadURL();

        String? mimeType = lookupMimeType(_imageFile.path);

        DocumentReference messageRef =
            await supportDoc.reference.collection('messages').add({
          "created_at": FieldValue.serverTimestamp(),
          "author": _user.uid,
          "text": null,
          "id": null,
          "file": imageString,
          "file_type": mimeType,
        });

        await messageRef.update({
          "id": messageRef.id,
        });
      }

      Map<String, dynamic> chatUpd = {
        "updated_at": FieldValue.serverTimestamp(),
        "last_update": "[imagem]",
        "support_notification": FieldValue.increment(1 + _images.length),
      };

      await supportDoc.reference.update(chatUpd);
    }

    imagesBool = false;
    cameraImage = null;
    await Future.delayed(Duration(milliseconds: 500), () => images!.clear());
    loadOverlay.remove();
  }

  @action
  Future<Map<String, dynamic>> getAdsDoc(RatingModel ratingModel) async {
    DocumentSnapshot orderDoc = await FirebaseFirestore.instance
        .collection("orders")
        .doc(ratingModel.orderId)
        .get();
    QuerySnapshot adsQuery = await orderDoc.reference.collection("ads").get();
    DocumentSnapshot firstAdsDoc = await FirebaseFirestore.instance
        .collection('ads')
        .doc(adsQuery.docs.first.id)
        .get();
    num ratings = 0;
    List<Map<String, dynamic>> ratingModelList = [
      {
        'ads_id': null,
        'model': ratingModel,
      },
    ];
    for (int i = 0; i < adsQuery.docs.length; i++) {
      DocumentSnapshot adsDocx = adsQuery.docs[i];
      DocumentSnapshot adsDoc = await FirebaseFirestore.instance
          .collection("ads")
          .doc(adsDocx.id)
          .get();
      QuerySnapshot ratingQuery = await adsDoc.reference
          .collection("ratings")
          .where("order_id", isEqualTo: ratingModel.orderId)
          .get();
      DocumentSnapshot ratingDoc = ratingQuery.docs.first;
      ratingModelList.add(
        {
          'ads_id': adsDoc.id,
          'model': RatingModel.fromDocSnapshot(ratingDoc),
        },
      );
      ratings += ratingDoc['rating'];
    }
    ;

    num average = (ratings + ratingModel.rating!) / 2;
    return {
      "firstAdsDoc": firstAdsDoc,
      "average": average,
      "ratingModelList": ratingModelList,
    };
  }
}
