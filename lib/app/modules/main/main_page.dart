import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller/app/core/models/order_model.dart';
import 'package:delivery_seller/app/modules/advertisement/advertisement_module.dart';
import 'package:delivery_seller/app/modules/home/home_module.dart';
import 'package:delivery_seller/app/modules/notifications/notifications_module.dart';
import 'package:delivery_seller/app/modules/orders/orders_module.dart';
import 'package:delivery_seller/app/modules/profile/profile_module.dart';
import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:delivery_seller/app/shared/widgets/custom_nav_bar.dart';
import 'package:delivery_seller/app/shared/widgets/floating_circle_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'main_store.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ModularState<MainPage, MainStore> {
  @override
  void initState() {
    FirebaseMessaging.instance.onTokenRefresh.listen(store.saveTokenToDatabase);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Observer(builder: (context) {
              return Container(
                height: maxHeight(context),
                width: maxWidth(context),
                child: PageView(
                  physics: store.paginateEnable
                      ? AlwaysScrollableScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  controller: store.pageController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    HomeModule(),
                    NotificationsModule(),
                    OrdersModule(),
                    AdvertisementModule(),
                    ProfileModule(),
                  ],
                  onPageChanged: (value) {
                    // print('value: $value');
                    store.page = value;
                    store.setVisibleNav(true);
                  },
                ),
              );
            }),
            Observer(
              builder: (context) {
                return AnimatedPositioned(
                  duration: Duration(seconds: 2),
                  curve: Curves.bounceOut,
                  bottom: store.visibleNav ? 0 : wXD(-85, context),
                  child: CustomNavBar(),
                );
              },
            ),
            Observer(
              builder: (context) {
                return AnimatedPositioned(
                  duration: Duration(seconds: 1),
                  curve: Curves.bounceOut,
                  bottom:
                      store.visibleNav ? wXD(42, context) : wXD(-68, context),
                  child: Observer(
                    builder: (context) {
                      return FloatingCircleButton(
                        onTap: () async {
                          store.setPage(2);
                        },
                        iconColor: store.page == 2 ? primary : white,
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
