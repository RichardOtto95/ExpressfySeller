import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

import 'splash_store.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({Key? key, this.title = 'SplashPage'}) : super(key: key);
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final SplashStore store = Modular.get();

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      if (FirebaseAuth.instance.currentUser != null) {
        // Modular.to.pushNamed("/main");
        Modular.to.pushReplacementNamed("/main");
      } else {
        // Modular.to.pushNamed("/on-boarding");
        Modular.to.pushReplacementNamed("/on-boarding");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: wXD(100, context)),
        child: Image.asset(
          "./assets/images/mercado_expresso_light.jpg",
          fit: BoxFit.fitHeight,
          height: maxHeight(context),
        ),
      ),
    );
  }
}
