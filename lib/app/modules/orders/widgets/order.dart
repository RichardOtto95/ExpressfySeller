import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller/app/core/models/order_model.dart';
import 'package:delivery_seller/app/modules/main/main_store.dart';
import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:delivery_seller/app/shared/widgets/load_circular_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import '../../../shared/widgets/confirm_popup.dart';
import '../orders_store.dart';

class OrderWidget extends StatefulWidget {
  final Map<String, dynamic> orderMap;
  final String status;
  final String agentStatus;

  OrderWidget({
    Key? key,
    required this.orderMap,
    required this.status,
    required this.agentStatus,
  }) : super(key: key);

  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  final MainStore mainStore = Modular.get();
  final OrdersStore store = Modular.get();
  late OverlayEntry overlayEntry;

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String canRefStatus = "";
    String canRefText = "";
    String accSenStatus = "";
    String accSenText = "";

    switch (widget.status) {
      case "REQUESTED":
        canRefStatus = "REFUSED";
        canRefText = "Recusar";
        accSenStatus = "PROCESSING";
        accSenText = "Confirmar";
        break;
      case "PROCESSING":
        canRefStatus = "CANCELED";
        canRefText = "Cancelar";
        accSenStatus = "DELIVERY_REQUESTED";
        accSenText = "Enviar";
        break;
      case "DELIVERY_REFUSED":
        canRefStatus = "CANCELED";
        canRefText = "Cancelar";
        accSenStatus = "DELIVERY_REQUESTED";
        accSenText = "Enviar";
        break;
      case "DELIVERY_REQUESTED":
        canRefText = "Cancelar";
        accSenText = "Despachar";
        break;
      case "DELIVERY_ACCEPTED":
        canRefStatus = "CANCELED";
        canRefText = "Cancelar";
        accSenStatus = "SENDED";
        accSenText = "Despachar";
        break;
      case "TIMEOUT":
        canRefStatus = "CANCELED";
        canRefText = "Cancelar";
        accSenStatus = "DELIVERY_REQUESTED";
        accSenText = "Enviar";
        break;
      case "SENDED":
        canRefText = "Cancelar";
        accSenText = "Despachar";
        break;
      case "CONCLUDED":
        canRefText = "Reembolsar";
        accSenText = "Enviar mensagem";
        break;
      default:
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: wXD(6, context),
              left: wXD(4, context),
              top: wXD(20, context),
            ),
            child: Text(
              getOrderDate(widget.orderMap['created_at'].toDate()),
              style: textFamily(
                fontSize: 14,
                color: textDarkGrey,
              ),
            ),
          ),
          Container(
            height: wXD(140, context),
            width: wXD(352, context),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffF1F1F1)),
              borderRadius: BorderRadius.all(Radius.circular(11)),
              color: white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0, 3),
                  color: Color(0x20000000),
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: darkGrey.withOpacity(.2)))),
                  padding: EdgeInsets.only(bottom: wXD(7, context)),
                  margin: EdgeInsets.fromLTRB(
                    wXD(19, context),
                    wXD(18, context),
                    wXD(15, context),
                    wXD(0, context),
                  ),
                  alignment: Alignment.center,
                  child: FutureBuilder<
                      List<DocumentSnapshot<Map<String, dynamic>>>>(
                    future: Order.fromJson(widget.orderMap).getAds(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: wXD(65, context),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              primary,
                            ),
                          ),
                        );
                      }
                      // print(
                      //     "snapshot.data!.first.id: ${snapshot.data!.first.id}");
                      return StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("ads")
                              .doc(snapshot.data!.first["ads_id"])
                              .snapshots(),
                          builder: (context, adsSnapshot) {
                            if (!snapshot.hasData || adsSnapshot.data == null) {
                              return CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(primary),
                              );
                            } else {
                              DocumentSnapshot pdt = adsSnapshot.data!;
                              // print("pdt: ${pdt.id}");
                              return InkWell(
                                onTap: () async {
                                  OverlayEntry _loadOverlay = OverlayEntry(
                                      builder: (context) =>
                                          LoadCircularOverlay());
                                  Overlay.of(context)!.insert(_loadOverlay);
                                  if (widget.orderMap['status'] ==
                                          "PROCESSING" ||
                                      widget.orderMap['status'] ==
                                          "REQUESTED") {
                                    store.setOrderSelected(
                                        Order.fromJson(widget.orderMap));
                                    _loadOverlay.remove();
                                    await Modular.to.pushNamed(
                                        '/orders/order-details',
                                        arguments: snapshot.data);
                                  } else {
                                    _loadOverlay.remove();
                                    await Modular.to.pushNamed(
                                        '/orders/shipping-details',
                                        arguments:
                                            Order.fromJson(widget.orderMap).id);
                                  }
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      child: CachedNetworkImage(
                                        imageUrl: pdt['images'].first,
                                        height: wXD(65, context),
                                        width: wXD(62, context),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: wXD(8, context)),
                                          width: wXD(220, context),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(height: wXD(3, context)),
                                              Text(
                                                pdt['title'],
                                                style: textFamily(
                                                    color: totalBlack),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: wXD(3, context)),
                                              Text(
                                                pdt['description'],
                                                style: textFamily(
                                                    color: lightGrey),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: wXD(3, context)),
                                              Text(
                                                Order.fromJson(widget.orderMap)
                                                            .totalAmount! >
                                                        1
                                                    ? '${Order.fromJson(widget.orderMap).totalAmount} itens'
                                                    : '${Order.fromJson(widget.orderMap).totalAmount} item',
                                                style: textFamily(
                                                    color:
                                                        grey.withOpacity(.7)),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: wXD(10, context)),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: wXD(14, context),
                                          color: grey.withOpacity(.7),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                          });
                    },
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: widget.status == "CONCLUDED"
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceAround,
                  children: [
                    widget.status == "CONCLUDED"
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              if (canRefStatus != "") {
                                if (accSenStatus == "SENDED") {
                                  overlayEntry = getTokenOverlay();
                                  Overlay.of(context)!.insert(overlayEntry);
                                } else {
                                  store.changeOrderStatus(
                                    Order.fromJson(widget.orderMap),
                                    canRefStatus,
                                    "",
                                    context,
                                  );
                                }
                              }
                            },
                            child: Text(
                              canRefText,
                              style: textFamily(
                                color: canRefStatus == "" ? lightGrey : primary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                    GestureDetector(
                      onTap: () {
                        if (accSenStatus != "") {
                          if (accSenStatus == "SENDED") {
                            overlayEntry = getTokenOverlay();
                            Overlay.of(context)!.insert(overlayEntry);
                          } else {
                            store.changeOrderStatus(
                              Order.fromJson(widget.orderMap),
                              accSenStatus,
                              "",
                              context,
                            );
                          }
                        } else {
                          if (accSenText == "Enviar mensagem") {
                            print('widget.orderMap: ${widget.orderMap}');
                            Modular.to.pushNamed('/messages/chat', arguments: {
                              "receiverId": widget.orderMap['customer_id'],
                              "receiverCollection": "customers",
                            });
                          }
                        }
                      },
                      child: Text(
                        accSenText,
                        style: textFamily(
                          color: accSenStatus == "" ? lightGrey : primary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  OverlayEntry getTokenOverlay() {
    final _formKey = GlobalKey<FormState>();
    String token = "";
    mainStore.setVisibleNav(false);
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          child: Stack(
            alignment: Alignment.center,
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: GestureDetector(
                  onTap: () {
                    overlayEntry.remove();
                    mainStore.setVisibleNav(true);
                  },
                  child: Container(
                    height: maxHeight(context),
                    width: maxWidth(context),
                    color: totalBlack.withOpacity(.6),
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Material(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                ),
                child: Container(
                  height: wXD(180, context),
                  width: wXD(327, context),
                  padding: EdgeInsets.all(wXD(24, context)),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                      topRight: Radius.circular(80),
                    ),
                    boxShadow: [BoxShadow(blurRadius: 18, color: totalBlack)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Preencha com o token do pedido fornecido pelo emissario!",
                        style: textFamily(fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                      Spacer(),
                      Form(
                        key: _formKey,
                        child: Container(
                          // width: wXD(120, context),
                          child: TextFormField(
                            onChanged: (val) => token = val,
                            style: textFamily(
                              fontSize: 18,
                              color: textBlack,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration.collapsed(
                              hintText: "Token",
                              hintStyle: textFamily(
                                fontSize: 18,
                                color: textLightGrey.withOpacity(.5),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primary,
                                  width: wXD(2, context),
                                ),
                              ),
                              fillColor: primary,
                              focusColor: primary.withOpacity(.7),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Campo obrigatório";
                              }
                              if (value.length != 6) {
                                return "6 dígitos necessários";
                              }
                              return null;
                            },
                            cursorColor: primary,
                          ),
                        ),
                      ),
                      Spacer(),
                      Center(
                        child: BlackButton(
                          width: 110,
                          text: 'Confirmar',
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await store.changeOrderStatus(
                                Order.fromJson(widget.orderMap),
                                "SENDED",
                                token,
                                context,
                              );
                              overlayEntry.remove();
                              mainStore.setVisibleNav(true);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String getOrderDate(DateTime date) {
    String strDate = '';

    String weekDay = DateFormat('EEEE').format(date);

    String month = DateFormat('MMMM').format(date);

    strDate =
        "${weekDay.substring(0, 1).toUpperCase()}${weekDay.substring(1, 3)} ${date.day} $month ${date.year}";

    return strDate;
  }
}
