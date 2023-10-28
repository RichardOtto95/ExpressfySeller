import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: totalBlack),
      ),
      debugShowCheckedModeBanner: false,
      title: "DeliveryApp",
      initialRoute: "/",
    ).modular();
  }
}
