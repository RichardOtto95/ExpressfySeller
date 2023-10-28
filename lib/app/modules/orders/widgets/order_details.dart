import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller/app/core/models/ads_model.dart';
import 'package:delivery_seller/app/core/models/time_model.dart';
import 'package:delivery_seller/app/modules/orders/widgets/accounts.dart';
import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:delivery_seller/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import '../../main/main_store.dart';
import '../orders_store.dart';

class OrderDetails extends StatelessWidget {
  final OrdersStore store = Modular.get();
  // final MainStore mainStore = Modular.get();
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> adsOrder;
  late OverlayEntry overlayEntry;
  OrderDetails({Key? key, required this.adsOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('store.orderSelected.status: ${store.orderSelected.status}');
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: wXD(83, context)),
                OrderStatus(),
                SizedBox(height: wXD(18, context)),
                ...adsOrder.map(
                  (adsDoc) {
                    return StreamBuilder<
                        DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("ads")
                          .doc(adsDoc.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        AdsModel ads = AdsModel.fromDoc(snapshot.data!);
                        return OrderProduct(
                          ads: ads,
                          amount: adsDoc["amount"],
                        );
                      },
                    );
                  },
                ).toList(),
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: wXD(30, context), right: wXD(3, context)),
                          child: Icon(
                            Icons.email_outlined,
                            color: primary,
                            size: wXD(20, context),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Modular.to
                              .pushNamed('/messages/chat', arguments: {
                            "receiverId": store.orderSelected.customerId,
                            "receiverCollection": "customers",
                          }),
                          child: Text(
                            'Enviar uma mensagem',
                            style: textFamily(
                              fontSize: 14,
                              color: primary,
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: wXD(14, context)),
                          child: Icon(
                            Icons.arrow_forward,
                            color: primary,
                            size: wXD(20, context),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                // Characteristics(),
                SizedBox(height: wXD(5, context)),

                store.orderSelected.couponId == null
                    ? Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: wXD(27, context),
                                    right: wXD(4, context)),
                                child: Icon(
                                  Icons.bookmark_outline,
                                  size: wXD(20, context),
                                  color: primary,
                                ),
                              ),
                              Text(
                                'Sem Cupom promocional',
                                style: textFamily(
                                    color: totalBlack,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Accounts(
                            change: store.orderSelected.change,
                            totalPrice: store.orderSelected.priceTotal!,
                            shippingPrice:
                                store.orderSelected.priceRateDelivery!,
                          ),
                        ],
                      )
                    : FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('coupons')
                            .doc(store.orderSelected.couponId!)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              color: primary,
                            );
                          }
                          DocumentSnapshot couponDoc = snapshot.data!;
                          print('couponDoc: ${couponDoc['type']}');
                          return Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: wXD(27, context),
                                        right: wXD(4, context)),
                                    child: Icon(
                                      Icons.bookmark_outline,
                                      size: wXD(20, context),
                                      color: primary,
                                    ),
                                  ),
                                  Text(
                                    couponDoc['type'] == 'FRIEND_INVITE'
                                        ? 'Cupom: Convite de amigo'
                                        : '',
                                    style: textFamily(
                                        color: totalBlack,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Accounts(
                                change: store.orderSelected.change,
                                totalPrice: store.orderSelected.priceTotal!,
                                shippingPrice:
                                    store.orderSelected.priceRateDelivery!,
                                discount: getDiscount(
                                  store.orderSelected.priceTotal!,
                                  couponDoc['type'],
                                  couponDoc['percent_off'],
                                  couponDoc['discount'],
                                ),
                                newTotalPrice:
                                    store.orderSelected.priceTotalWithDiscount,
                              ),
                            ],
                          );
                        }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SideButton(
                      isWhite: true,
                      height: wXD(52, context),
                      width: wXD(142, context),
                      title: store.orderSelected.status == "PROCESSING"
                          ? 'Cancelar'
                          : 'Recusar',
                      onTap: () async {
                        String newStatus = "";
                        if (store.orderSelected.status == "PROCESSING") {
                          newStatus = "CANCELED";
                        } else {
                          newStatus = "REFUSED";
                        }

                        await store.changeOrderStatus(
                          store.orderSelected,
                          newStatus,
                          "",
                          context,
                        );
                        Modular.to.pop();
                      },
                    ),
                    SideButton(
                      height: wXD(52, context),
                      width: wXD(142, context),
                      title: store.orderSelected.status == "PROCESSING"
                          ? 'Enviar'
                          : 'Confirmar',
                      onTap: () async {
                        String newStatus = "";
                        if (store.orderSelected.status == "PROCESSING") {
                          newStatus = "DELIVERY_REQUESTED";
                        } else {
                          newStatus = "PROCESSING";
                        }

                        await store.changeOrderStatus(
                          store.orderSelected,
                          newStatus,
                          "",
                          context,
                        );
                        Modular.to.pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: wXD(19, context)),
              ],
            ),
          ),
          DefaultAppBar('Detalhes'),
        ],
      ),
    );
  }

  getDiscount(num price, String type, double? _percentOff, num? discount) {
    if (type == "FRIEND_INVITE") {
      num response = price * _percentOff!;
      return response;
    } else {
      num response = price - discount!;
      return response;
    }
  }
}

class OrderProduct extends StatelessWidget {
  final AdsModel ads;
  final int amount;
  OrderProduct({Key? key, required this.ads, required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      margin: EdgeInsets.fromLTRB(
        wXD(32, context),
        wXD(0, context),
        wXD(16, context),
        wXD(11, context),
      ),
      padding: EdgeInsets.only(bottom: wXD(11, context)),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: darkGrey.withOpacity(.2)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            child: CachedNetworkImage(
              imageUrl: ads.images.first,
              height: wXD(65, context),
              width: wXD(62, context),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: wXD(8, context)),
            width: wXD(255, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: wXD(3, context)),
                Text(
                  ads.title,
                  style: textFamily(color: totalBlack),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: wXD(3, context)),
                Text(
                  ads.description,
                  style: textFamily(
                    color: lightGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: wXD(3, context)),
                Text(
                  amount > 1 ? '$amount itens' : '$amount item',
                  style: textFamily(color: grey.withOpacity(.7)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderStatus extends StatelessWidget {
  final OrdersStore store = Modular.get();
  OrderStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: wXD(59, context),
        width: wXD(343, context),
        padding: EdgeInsets.only(
          left: wXD(15, context),
          top: wXD(14, context),
          right: wXD(8, context),
          bottom: wXD(13, context),
        ),
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: primary.withOpacity(.2)),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Color(0x25000000),
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pedido #${store.orderSelected.id!.substring(store.orderSelected.id!.length - 5, store.orderSelected.id!.length).toUpperCase()}',
                  style: textFamily(
                    fontSize: 11,
                    color: primary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Horário ${Time(store.orderSelected.createdAt!.toDate()).hour()}',
                  style: textFamily(
                    fontSize: 12,
                    color: primary,
                  ),
                ),
              ],
            ),
            Container(
              height: wXD(24, context),
              width: wXD(102, context),
              decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              alignment: Alignment.center,
              child: Text(
                store.orderSelected.status == "PROCESSING"
                    ? 'Processando'
                    : 'Pendente',
                style: textFamily(
                  fontSize: 12,
                  color: white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
