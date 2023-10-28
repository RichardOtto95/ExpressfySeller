import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_seller/app/core/models/ads_model.dart';
import 'package:delivery_seller/app/modules/advertisement/advertisement_store.dart';
import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:delivery_seller/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_seller/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'ads_details.dart';
import 'delete_photo_pop_up.dart';
import 'include_photos.dart';
import 'include_photos_pop_up.dart';
import 'search_type.dart';

class CreateAds extends StatefulWidget {
  CreateAds({Key? key}) : super(key: key);

  @override
  _CreateAdsState createState() => _CreateAdsState();
}

class _CreateAdsState extends State<CreateAds> {
  final AdvertisementStore store = Modular.get();
  final ScrollController scrollController = ScrollController();
  OverlayEntry? overlayEntry;
  final _formKey = GlobalKey<FormState>();
  late ScrollPhysics _physics;
  bool clampScroll = false;

  OverlayEntry getOverlay() {
    return OverlayEntry(
      builder: (context) => ConfirmPopup(
        height: wXD(140, context),
        text: 'Tem certeza em cancelar? \nSeu anúncio será descartado!',
        onConfirm: () {
          overlayEntry!.remove();
          overlayEntry = null;
          Modular.to.pop();
          store.cleanVars();
        },
        onCancel: () {
          overlayEntry!.remove();
          overlayEntry = null;
        },
      ),
    );
  }

  @override
  void initState() {
    _physics = BouncingScrollPhysics();
    scrollController.addListener(() {
      // print(
      //     "scrollController.position.pixels: ${scrollController.position.pixels}");
      // print(
      //     "scrollController.position.userScrollDirection: ${scrollController.position.userScrollDirection}");
      // print(
      //     "applyPhysicsToUserOffset: ${_physics.applyPhysicsToUserOffset(scrollController.position, scrollController.offset)}");
      print("_physics: $_physics");

      mobx.when(
        (_) =>
            scrollController.position.pixels >= 3 &&
            scrollController.position.userScrollDirection ==
                ScrollDirection.reverse &&
            !clampScroll,
        () => setState(() {
          clampScroll = true;
          _physics = ClampingScrollPhysics();
        }),
      );
      mobx.when(
        (_) =>
            scrollController.position.pixels < 3 &&
            scrollController.position.userScrollDirection ==
                ScrollDirection.forward &&
            clampScroll,
        () => setState(() {
          clampScroll = false;
          _physics = BouncingScrollPhysics();
        }),
      );

      // if (scrollController.position.pixels >= 0 &&
      //     scrollController.position.userScrollDirection ==
      //         ScrollDirection.reverse &&
      //     _physics != ClampingScrollPhysics()) {
      //   print("settingState");
      // } else if (_physics != BouncingScrollPhysics()) {
      //   print("settingState");
      //   setState(() => _physics = BouncingScrollPhysics());
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('store.adEdit.images: ${store.adEdit.images}');
    return WillPopScope(
      onWillPop: () async {
        print('WillPopScope onWillPop createads: ${store.getProgress()}');
        if (store.getProgress()) {
          return false;
        } else if (store.takePicture) {
          store.settakePicture(false);
        } else if (store.searchType) {
          store.setSearchType(false);
        } else if (store.deleteImage) {
          store.setDeleteImage(false);
        } else if ((store.adsTitle != '' ||
                store.adsDescription != '' ||
                store.adsCategory != '' ||
                store.adsType != '' ||
                // store.adsIsNew != true ||
                store.sellerPrice != null ||
                store.adsOption != '' ||
                store.images.isNotEmpty) &&
            !store.editingAd) {
          if (store.redirectOverlay != null && store.redirectOverlay!.mounted) {
            store.redirectOverlay!.remove();
            store.redirectOverlay = null;
          }
          if (overlayEntry != null && overlayEntry!.mounted) {
            overlayEntry!.remove();
            overlayEntry = null;
          } else {
            overlayEntry = getOverlay();
            Overlay.of(context)?.insert(overlayEntry!);
          }
        } else {
          store.setEditingAd(false);
          store.setAdEdit(AdsModel());
          store.cleanVars();
          return true;
        }
        return false;
      },
      child: Listener(
        onPointerDown: (a) {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        onPointerUp: (a) {
          if (wXD(scrollController.offset, context) < -55) {
            store.setSearchType(false);
          }
        },
        child: Scaffold(
          backgroundColor: backgroundGrey,
          body: Observer(builder: (context) {
            return Stack(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: wXD(90, context)),
                      Container(
                        width: maxWidth(context),
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          // physics: PageScrollPhysics(),
                          padding:
                              EdgeInsets.symmetric(horizontal: wXD(6, context)),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(
                                store.adEdit.images.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    print('ontap 1');
                                    // print('after: ${store.deleteImage}');
                                    store.setImageSelected(index);
                                    store.setDeleteImage(true);
                                    store.setRemovingEditingAd(true);
                                    // print('before: ${store.deleteImage}');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: wXD(20, context),
                                      left: wXD(6, context),
                                      right: wXD(6, context),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            color: Color(0x30000000))
                                      ],
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        child: CachedNetworkImage(
                                          imageUrl: store.adEdit.images[index],
                                          fit: BoxFit.cover,
                                          height: wXD(196, context),
                                          width: wXD(282, context),
                                        )),
                                  ),
                                ),
                              ),
                              ...List.generate(
                                store.images.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    print('ontap 2');
                                    // print('after: ${store.deleteImage}');
                                    store.setRemovingEditingAd(false);
                                    store.setImageSelected(index);
                                    store.setDeleteImage(true);
                                    // print('before: ${store.deleteImage}');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: wXD(20, context),
                                      left: wXD(6, context),
                                      right: wXD(6, context),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                            color: Color(0x30000000))
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      child: Image.file(
                                        store.images[index],
                                        fit: BoxFit.cover,
                                        height: wXD(196, context),
                                        width: wXD(282, context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IncludePhotos(
                                imagesLength: store.images.length,
                                onTap: () => store.settakePicture(true),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Form(key: _formKey, child: AdsDetails()),
                      SizedBox(height: wXD(42, context)),
                      SideButton(
                        onTap: () {
                          _formKey.currentState!.validate();
                          if (store.getValidate() &&
                              _formKey.currentState!.validate()) {
                            store.editingAd
                                ? store.editAds(context)
                                : store.createAds(context);
                          }
                        },
                        height: wXD(52, context),
                        width: wXD(142, context),
                        title: store.editingAd ? 'Salvar' : 'Enviar',
                      ),
                      SizedBox(height: wXD(29, context)),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: textFamily(color: grey),
                            children: [
                              TextSpan(
                                  text:
                                      'Ao publicar você concorda e aceita nossos'),
                              TextSpan(
                                  style: textFamily(color: primary),
                                  text: ' Termos \nde Uso e Privacidade'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: wXD(10, context)),
                    ],
                  ),
                ),
                DefaultAppBar(
                  store.editingAd ? 'Editar anúncio' : 'Inserir anúncio',
                  onPop: () {
                    if (store.getProgress()) {
                    } else if (store.takePicture) {
                      store.settakePicture(false);
                    } else if (store.searchType) {
                      store.setSearchType(false);
                    } else if (store.deleteImage) {
                      store.setDeleteImage(false);
                    } else if ((store.adsTitle != '' ||
                            store.adsDescription != '' ||
                            store.adsCategory != '' ||
                            store.adsType != '' ||
                            // store.adsIsNew != true ||
                            store.sellerPrice != null ||
                            store.adsOption != '' ||
                            store.images.isNotEmpty) &&
                        !store.editingAd) {
                      if (store.redirectOverlay != null &&
                          store.redirectOverlay!.mounted) {
                        store.redirectOverlay!.remove();
                        store.redirectOverlay = null;
                      }
                      if (overlayEntry != null && overlayEntry!.mounted) {
                        overlayEntry!.remove();
                        overlayEntry = null;
                      } else {
                        overlayEntry = getOverlay();
                        Overlay.of(context)?.insert(overlayEntry!);
                      }
                    } else {
                      store.setEditingAd(false);
                      store.setAdEdit(AdsModel());
                      store.cleanVars();
                      Modular.to.pop();
                    }
                  },
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: store.takePicture ||
                            store.searchType ||
                            store.deleteImage
                        ? 2
                        : 0,
                    sigmaY: store.takePicture ||
                            store.searchType ||
                            store.deleteImage
                        ? 2
                        : 0,
                  ),
                  child: AnimatedOpacity(
                    opacity: store.takePicture ||
                            store.searchType ||
                            store.deleteImage
                        ? .6
                        : 0,
                    duration: Duration(milliseconds: 600),
                    child: GestureDetector(
                      onTap: () => store.deleteImage
                          ? store.setDeleteImage(false)
                          : store.settakePicture(false),
                      child: Container(
                        height: store.takePicture ||
                                store.searchType ||
                                store.deleteImage
                            ? maxHeight(context)
                            : 0,
                        width: store.takePicture ||
                                store.searchType ||
                                store.deleteImage
                            ? maxWidth(context)
                            : 0,
                        color: totalBlack,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 600),
                  bottom: store.takePicture ? 0 : wXD(-181, context),
                  child: IncludePhotosPopUp(),
                ),
                AnimatedPositioned(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 600),
                  bottom: store.deleteImage ? 0 : wXD(-181, context),
                  child: DeletePhotoPupUp(),
                ),
                AnimatedPositioned(
                  top: store.searchType ? 0 : maxHeight(context),
                  duration: Duration(milliseconds: 600),
                  child: Container(
                    height: maxHeight(context),
                    width: maxWidth(context),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: _physics,
                      child: Column(
                        children: [
                          GestureDetector(
                              onTap: () => store.setSearchType(false),
                              child: Container(
                                  color: Colors.transparent,
                                  height: hXD(144, context),
                                  width: maxWidth(context))),
                          SearchType(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
