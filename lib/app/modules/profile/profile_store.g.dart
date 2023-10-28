// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ProfileStore on _ProfileStoreBase, Store {
  final _$profileEditAtom = Atom(name: '_ProfileStoreBase.profileEdit');

  @override
  ObservableMap<dynamic, dynamic> get profileEdit {
    _$profileEditAtom.reportRead();
    return super.profileEdit;
  }

  @override
  set profileEdit(ObservableMap<dynamic, dynamic> value) {
    _$profileEditAtom.reportWrite(value, super.profileEdit, () {
      super.profileEdit = value;
    });
  }

  final _$birthdayValidateAtom =
      Atom(name: '_ProfileStoreBase.birthdayValidate');

  @override
  bool get birthdayValidate {
    _$birthdayValidateAtom.reportRead();
    return super.birthdayValidate;
  }

  @override
  set birthdayValidate(bool value) {
    _$birthdayValidateAtom.reportWrite(value, super.birthdayValidate, () {
      super.birthdayValidate = value;
    });
  }

  final _$bankValidateAtom = Atom(name: '_ProfileStoreBase.bankValidate');

  @override
  bool get bankValidate {
    _$bankValidateAtom.reportRead();
    return super.bankValidate;
  }

  @override
  set bankValidate(bool value) {
    _$bankValidateAtom.reportWrite(value, super.bankValidate, () {
      super.bankValidate = value;
    });
  }

  final _$genderValidateAtom = Atom(name: '_ProfileStoreBase.genderValidate');

  @override
  bool get genderValidate {
    _$genderValidateAtom.reportRead();
    return super.genderValidate;
  }

  @override
  set genderValidate(bool value) {
    _$genderValidateAtom.reportWrite(value, super.genderValidate, () {
      super.genderValidate = value;
    });
  }

  final _$avatarValidateAtom = Atom(name: '_ProfileStoreBase.avatarValidate');

  @override
  bool get avatarValidate {
    _$avatarValidateAtom.reportRead();
    return super.avatarValidate;
  }

  @override
  set avatarValidate(bool value) {
    _$avatarValidateAtom.reportWrite(value, super.avatarValidate, () {
      super.avatarValidate = value;
    });
  }

  final _$canBackAtom = Atom(name: '_ProfileStoreBase.canBack');

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

  final _$concludedAtom = Atom(name: '_ProfileStoreBase.concluded');

  @override
  bool get concluded {
    _$concludedAtom.reportRead();
    return super.concluded;
  }

  @override
  set concluded(bool value) {
    _$concludedAtom.reportWrite(value, super.concluded, () {
      super.concluded = value;
    });
  }

  final _$textControllerAtom = Atom(name: '_ProfileStoreBase.textController');

  @override
  TextEditingController get textController {
    _$textControllerAtom.reportRead();
    return super.textController;
  }

  @override
  set textController(TextEditingController value) {
    _$textControllerAtom.reportWrite(value, super.textController, () {
      super.textController = value;
    });
  }

  final _$imagesAtom = Atom(name: '_ProfileStoreBase.images');

  @override
  List<File>? get images {
    _$imagesAtom.reportRead();
    return super.images;
  }

  @override
  set images(List<File>? value) {
    _$imagesAtom.reportWrite(value, super.images, () {
      super.images = value;
    });
  }

  final _$imagesNameAtom = Atom(name: '_ProfileStoreBase.imagesName');

  @override
  List<String>? get imagesName {
    _$imagesNameAtom.reportRead();
    return super.imagesName;
  }

  @override
  set imagesName(List<String>? value) {
    _$imagesNameAtom.reportWrite(value, super.imagesName, () {
      super.imagesName = value;
    });
  }

  final _$imagesBoolAtom = Atom(name: '_ProfileStoreBase.imagesBool');

  @override
  bool get imagesBool {
    _$imagesBoolAtom.reportRead();
    return super.imagesBool;
  }

  @override
  set imagesBool(bool value) {
    _$imagesBoolAtom.reportWrite(value, super.imagesBool, () {
      super.imagesBool = value;
    });
  }

  final _$cameraImageAtom = Atom(name: '_ProfileStoreBase.cameraImage');

  @override
  File? get cameraImage {
    _$cameraImageAtom.reportRead();
    return super.cameraImage;
  }

  @override
  set cameraImage(File? value) {
    _$cameraImageAtom.reportWrite(value, super.cameraImage, () {
      super.cameraImage = value;
    });
  }

  final _$orderIdAtom = Atom(name: '_ProfileStoreBase.orderId');

  @override
  String? get orderId {
    _$orderIdAtom.reportRead();
    return super.orderId;
  }

  @override
  set orderId(String? value) {
    _$orderIdAtom.reportWrite(value, super.orderId, () {
      super.orderId = value;
    });
  }

  final _$raitingIdAtom = Atom(name: '_ProfileStoreBase.raitingId');

  @override
  String? get raitingId {
    _$raitingIdAtom.reportRead();
    return super.raitingId;
  }

  @override
  set raitingId(String? value) {
    _$raitingIdAtom.reportWrite(value, super.raitingId, () {
      super.raitingId = value;
    });
  }

  final _$answerMapAtom = Atom(name: '_ProfileStoreBase.answerMap');

  @override
  Map<dynamic, dynamic> get answerMap {
    _$answerMapAtom.reportRead();
    return super.answerMap;
  }

  @override
  set answerMap(Map<dynamic, dynamic> value) {
    _$answerMapAtom.reportWrite(value, super.answerMap, () {
      super.answerMap = value;
    });
  }

  final _$clearNewRatingsAsyncAction =
      AsyncAction('_ProfileStoreBase.clearNewRatings');

  @override
  Future<void> clearNewRatings() {
    return _$clearNewRatingsAsyncAction.run(() => super.clearNewRatings());
  }

  final _$clearNewQuestionsAsyncAction =
      AsyncAction('_ProfileStoreBase.clearNewQuestions');

  @override
  Future<void> clearNewQuestions() {
    return _$clearNewQuestionsAsyncAction.run(() => super.clearNewQuestions());
  }

  final _$clearNewSupportMessagesAsyncAction =
      AsyncAction('_ProfileStoreBase.clearNewSupportMessages');

  @override
  Future<void> clearNewSupportMessages() {
    return _$clearNewSupportMessagesAsyncAction
        .run(() => super.clearNewSupportMessages());
  }

  final _$pickAvatarAsyncAction = AsyncAction('_ProfileStoreBase.pickAvatar');

  @override
  Future<void> pickAvatar() {
    return _$pickAvatarAsyncAction.run(() => super.pickAvatar());
  }

  final _$saveProfileAsyncAction = AsyncAction('_ProfileStoreBase.saveProfile');

  @override
  Future<dynamic> saveProfile(dynamic context) {
    return _$saveProfileAsyncAction.run(() => super.saveProfile(context));
  }

  final _$changeNotificationEnabledAsyncAction =
      AsyncAction('_ProfileStoreBase.changeNotificationEnabled');

  @override
  Future changeNotificationEnabled(bool change) {
    return _$changeNotificationEnabledAsyncAction
        .run(() => super.changeNotificationEnabled(change));
  }

  final _$setProfileEditFromDocAsyncAction =
      AsyncAction('_ProfileStoreBase.setProfileEditFromDoc');

  @override
  Future setProfileEditFromDoc() {
    return _$setProfileEditFromDocAsyncAction
        .run(() => super.setProfileEditFromDoc());
  }

  final _$setBirthdayAsyncAction = AsyncAction('_ProfileStoreBase.setBirthday');

  @override
  Future setBirthday(dynamic context, Function callBack) {
    return _$setBirthdayAsyncAction
        .run(() => super.setBirthday(context, callBack));
  }

  final _$answerAvaliationAsyncAction =
      AsyncAction('_ProfileStoreBase.answerAvaliation');

  @override
  Future<void> answerAvaliation(
      Map<dynamic, dynamic> mapAnswer, dynamic context) {
    return _$answerAvaliationAsyncAction
        .run(() => super.answerAvaliation(mapAnswer, context));
  }

  final _$answerQuestionAsyncAction =
      AsyncAction('_ProfileStoreBase.answerQuestion');

  @override
  Future<dynamic> answerQuestion(
      String questionId, String answer, dynamic context) {
    return _$answerQuestionAsyncAction
        .run(() => super.answerQuestion(questionId, answer, context));
  }

  final _$createSupportAsyncAction =
      AsyncAction('_ProfileStoreBase.createSupport');

  @override
  Future<void> createSupport() {
    return _$createSupportAsyncAction.run(() => super.createSupport());
  }

  final _$sendSupportMessageAsyncAction =
      AsyncAction('_ProfileStoreBase.sendSupportMessage');

  @override
  Future<void> sendSupportMessage() {
    return _$sendSupportMessageAsyncAction
        .run(() => super.sendSupportMessage());
  }

  final _$sendImageAsyncAction = AsyncAction('_ProfileStoreBase.sendImage');

  @override
  Future<dynamic> sendImage(dynamic context) {
    return _$sendImageAsyncAction.run(() => super.sendImage(context));
  }

  final _$getAdsDocAsyncAction = AsyncAction('_ProfileStoreBase.getAdsDoc');

  @override
  Future<Map<String, dynamic>> getAdsDoc(RatingModel ratingModel) {
    return _$getAdsDocAsyncAction.run(() => super.getAdsDoc(ratingModel));
  }

  final _$_ProfileStoreBaseActionController =
      ActionController(name: '_ProfileStoreBase');

  @override
  dynamic setCanBack(dynamic _canBack) {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
        name: '_ProfileStoreBase.setCanBack');
    try {
      return super.setCanBack(_canBack);
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool getCanBack() {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
        name: '_ProfileStoreBase.getCanBack');
    try {
      return super.getCanBack();
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setConcluded(bool _concluded) {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
        name: '_ProfileStoreBase.setConcluded');
    try {
      return super.setConcluded(_concluded);
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool getValidate() {
    final _$actionInfo = _$_ProfileStoreBaseActionController.startAction(
        name: '_ProfileStoreBase.getValidate');
    try {
      return super.getValidate();
    } finally {
      _$_ProfileStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
profileEdit: ${profileEdit},
birthdayValidate: ${birthdayValidate},
bankValidate: ${bankValidate},
genderValidate: ${genderValidate},
avatarValidate: ${avatarValidate},
canBack: ${canBack},
concluded: ${concluded},
textController: ${textController},
images: ${images},
imagesName: ${imagesName},
imagesBool: ${imagesBool},
cameraImage: ${cameraImage},
orderId: ${orderId},
raitingId: ${raitingId},
answerMap: ${answerMap}
    ''';
  }
}
