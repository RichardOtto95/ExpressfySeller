import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller/app/modules/advertisement/advertisement_store.dart';
import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:delivery_seller/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChooseCategory extends StatelessWidget {
  final AdvertisementStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future:
                    FirebaseFirestore.instance.collection("categories").get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CenterLoadCircular();
                  }
                  List<QueryDocumentSnapshot<Map<String, dynamic>>> categories =
                      snapshot.data!.docs;
                  return Column(
                    children: [
                      SizedBox(height: wXD(77, context)),
                      ...categories.map((e) => InkWell(
                            onTap: () async {
                              store.editingAd
                                  ? store.adEdit.category = e.get("label")
                                  : store.setAdsCategory(e.get("label"));
                              await Modular.to.pushNamed(
                                  '/advertisement/category',
                                  arguments: e.id);
                            },
                            child: Container(
                              width: maxWidth(context),
                              height: wXD(52, context),
                              margin: EdgeInsets.symmetric(
                                  horizontal: wXD(23, context)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: darkGrey.withOpacity(.2)))),
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.get("label"),
                                    style: textFamily(
                                      color: primary,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: wXD(23, context),
                                    color: primary,
                                  )
                                ],
                              ),
                            ),
                          ))
                    ],
                  );
                }),
          ),
          DefaultAppBar('Escolha uma categoria')
        ],
      ),
    );
  }
}
