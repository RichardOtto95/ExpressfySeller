import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller/app/core/models/ads_model.dart';
import 'package:delivery_seller/app/modules/main/main_store.dart';
import 'package:delivery_seller/app/modules/product/widgets/characteristics.dart';
import 'package:delivery_seller/app/modules/product/widgets/store_informations.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:delivery_seller/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'product_store.dart';
import 'widgets/item_data.dart';
import 'widgets/opinions.dart';

class ProductPage extends StatelessWidget {
  final MainStore mainStore = Modular.get();
  final ProductStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    print('product page: ${mainStore.adsId}');
    return Listener(
      onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Stack(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('ads')
                  .doc(mainStore.adsId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CenterLoadCircular();
                } else {
                  AdsModel model = AdsModel.fromDoc(snapshot.data!);
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: wXD(97, context)),
                        ItemData(model: model),
                        Characteristics(model: model),
                        StoreInformations(
                            sellerId: model.sellerId, adsId: model.id),
                        Opinions(model: model),
                      ],
                    ),
                  );
                }
              },
            ),
            DefaultAppBar('Detalhes')
          ],
        ),
      ),
    );
  }
}
