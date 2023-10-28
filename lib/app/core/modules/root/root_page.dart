import 'package:delivery_seller/app/core/modules/root/root_store.dart';
import 'package:delivery_seller/app/core/modules/splash/splash_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  final RootStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    // print(
    //     'FirebaseAuth.instance.currentUser != null ?? ${FirebaseAuth.instance.currentUser != null}');
    return SplashModule();
    // if (FirebaseAuth.instance.currentUser != null) {
    //   return MainModule();
    // } else {
    //   return OnBoarding();
    // }
  }
}
