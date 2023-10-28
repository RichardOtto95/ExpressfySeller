import 'dart:io';

import 'package:delivery_seller/app/modules/messages/messages_store.dart';
import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:delivery_seller/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart' as mobx;

import '../../../shared/widgets/floating_circle_button.dart';
import 'message.dart';
import 'message_bar.dart';

class Chat extends StatefulWidget {
  final String receiverId;
  final String receiverCollection;
  final String messageId;
  const Chat({
    Key? key,
    required this.receiverId,
    required this.receiverCollection,
    this.messageId = "",
  }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final MessagesStore store = Modular.get();

  final PageController pageController = PageController();

  GlobalKey messageKey = GlobalKey();

  FocusNode focusNode = FocusNode();

  String messageId = "";

  @override
  void initState() {
    messageId = widget.messageId;
    // print("messageId: ${widget.messageId}");
    // print("receiverId: ${widget.receiverId}");
    // print("receiverCollection: ${widget.receiverCollection}");
    store.textChatController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    pageController.dispose();
    store.disposeChat();

    super.dispose();
  }

  Future scrollToItem() async {
    // print("Pelo menos entrou no scroll to item");
    if (messageKey.currentContext != null) {
      final context = messageKey.currentContext!;
      // print("Ensure de item visibleee");
      await Scrollable.ensureVisible(
        context,
        alignment: .9,
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      );
      messageId = "";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (store.images.isNotEmpty || store.cameraImage != null) {
          store.images.clear();
          // store.imagesBool = false;
          store.cameraImage = null;
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: FutureBuilder<String>(
          future:
              store.loadChatData(widget.receiverId, widget.receiverCollection),
          builder: (context, data) {
            if (!data.hasData) {
              return CenterLoadCircular();
            }
            return Observer(
              builder: (context) {
                print("store.cameraImage: ${store.cameraImage}");
                return Stack(
                  children: [
                    Listener(
                      onPointerDown: (event) => focusNode.unfocus(),
                      child: SizedBox(
                        height: maxHeight(context),
                        width: maxWidth(context),
                        child: SingleChildScrollView(
                          reverse: true,
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          child: Observer(
                            builder: (context) {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback(((timeStamp) {
                                scrollToItem();
                              }));
                              return Column(
                                children: [
                                  SizedBox(height: wXD(80, context)),
                                  ...List.generate(
                                    store.messages.length,
                                    (i) => MessageWidget(
                                      key: store.messages[i].id == messageId
                                          ? messageKey
                                          : null,
                                      isAuthor: store.getIsAuthor(i),
                                      leftName: store.customer != null
                                          ? store.customer!.username!
                                          : store.agent!.username!,
                                      rightName: store.seller!.username!,
                                      leftAvatar: store.customer != null
                                          ? store.customer!.avatar
                                          : store.agent!.avatar,
                                      rightAvatar: store.seller!.avatar,
                                      messageData: store.messages[i],
                                      showUserData: i == 0
                                          ? true
                                          : store.getShowUserData(i),
                                      messageBold: store.messages[i].id ==
                                          widget.messageId,
                                    ),
                                  ),
                                  SizedBox(height: wXD(80, context)),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    DefaultAppBar(
                      data.data!,
                      onPop: () async {
                        if (store.images.isNotEmpty ||
                            store.cameraImage != null) {
                          store.images.clear();
                          // store.imagesBool = false;
                          store.cameraImage = null;
                        }
                        Modular.to.pop();
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      child: MessageBar(
                        controller: store.textChatController,
                        focus: focusNode,
                        onChanged: (val) => store.text = val,
                        onEditingComplete: () => store.sendMessage(),
                        onSend: () => store.sendMessage(),
                        takePictures: () async {
                          List<File> images = await pickMultiImage() ?? [];
                          store.images = images.asObservable();
                          // store.imagesBool = images.isNotEmpty;
                        },
                        getCameraImage: () async {
                          store.cameraImage = await pickCameraImage();
                          store.sendImage(context);
                        },
                      ),
                    ),
                    Visibility(
                      visible: store.images.isNotEmpty,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            color: white,
                            height: maxHeight(context),
                            width: maxWidth(context),
                            child: Container(
                              height: wXD(800, context),
                              width: maxWidth(context),
                              margin: EdgeInsets.symmetric(
                                  vertical: wXD(58, context)),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                              ),
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                child: Observer(builder: (context) {
                                  return PageView(
                                    children: List.generate(
                                      store.images.length,
                                      (index) => Image.file(
                                        store.images[index],
                                      ),
                                    ),
                                    onPageChanged: (page) =>
                                        store.imagesPage = page,
                                    controller: pageController,
                                  );
                                }),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: SizedBox(
                              width: maxWidth(context),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: wXD(10, context),
                                      bottom: wXD(10, context),
                                    ),
                                    alignment: Alignment.centerRight,
                                    child: FloatingCircleButton(
                                      onTap: () => store.sendImage(context),
                                      icon: Icons.send_outlined,
                                      iconColor: primary,
                                      size: wXD(55, context),
                                      iconSize: 30,
                                    ),
                                  ),
                                  Observer(
                                    builder: (context) {
                                      return SizedBox(
                                        width: maxWidth(context),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(
                                              store.images.length,
                                              (index) => InkWell(
                                                onTap: () => pageController
                                                    .jumpToPage(index),
                                                child: Container(
                                                  height: wXD(70, context),
                                                  width: wXD(70, context),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                    width: 2,
                                                    color: index ==
                                                            store.imagesPage
                                                        ? primary
                                                        : Colors.transparent,
                                                  )),
                                                  child: Image.file(
                                                    store.images[index],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: wXD(10, context) +
                                MediaQuery.of(context).viewPadding.top,
                            child: Container(
                              width: maxWidth(context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: wXD(10, context)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      store.cancelImages();
                                    },
                                    icon: Icon(Icons.close_rounded,
                                        size: wXD(30, context)),
                                  ),
                                  IconButton(
                                    onPressed: () => store.removeImage(),
                                    icon: Icon(Icons.delete_outline_rounded,
                                        size: wXD(30, context)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // AnimatedPositioned(
                    //   duration: Duration(milliseconds: 500),
                    //   top: store.imagesBool ? 0 : maxHeight(context),
                    //   child: Stack(
                    //     alignment: Alignment.center,
                    //     children: [
                    //       GestureDetector(
                    //         onTap: () {
                    //           store.cameraImage = null;
                    //           store.imagesBool = false;
                    //           Future.delayed(Duration(milliseconds: 500),
                    //               () => store.images = []);
                    //         },
                    //         child: Container(
                    //           color: veryLightGrey,
                    //           height: maxHeight(context),
                    //           width: maxWidth(context),
                    //         ),
                    //       ),
                    //       Container(
                    //         height: hXD(550, context),
                    //         width: maxWidth(context),
                    //         margin: EdgeInsets.symmetric(
                    //             vertical: wXD(58, context)),
                    //         decoration: BoxDecoration(
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(18)),
                    //         ),
                    //         alignment: Alignment.center,
                    //         child: ClipRRect(
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(18)),
                    //           child: SingleChildScrollView(
                    //             child: Column(
                    //               mainAxisSize: MainAxisSize.max,
                    //               children:
                    //                   //  store.cameraImage == null
                    //                   //     ?
                    //                   List.generate(
                    //                 store.images!.length,
                    //                 (index) => Image.file(
                    //                   store.images![index],
                    //                 ),
                    //               ),
                    //               // : [Image.file(store.cameraImage!)],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Positioned(
                    //         bottom: wXD(10, context),
                    //         right: wXD(10, context),
                    //         child: GestureDetector(
                    //           onTap: () => store.sendImage(context),
                    //           child: Container(
                    //             height: wXD(50, context),
                    //             width: wXD(50, context),
                    //             decoration: BoxDecoration(
                    //               color: primary,
                    //               shape: BoxShape.circle,
                    //             ),
                    //             child: Icon(
                    //               Icons.send_outlined,
                    //               color: white,
                    //               size: wXD(23, context),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Positioned(
                    //         top: wXD(10, context) +
                    //             MediaQuery.of(context).viewPadding.top,
                    //         left: wXD(15, context),
                    //         child: InkWell(
                    //           onTap: () {
                    //             store.cameraImage = null;
                    //             store.imagesBool = false;
                    //             Future.delayed(
                    //               Duration(milliseconds: 500),
                    //               () => store.images!.clear(),
                    //             );
                    //           },
                    //           child: Icon(Icons.close_rounded,
                    //               size: wXD(30, context)),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
