// ignore: implementation_imports
import 'package:delivery_seller/app/core/services/auth/auth_service.dart';
import 'package:delivery_seller/app/core/services/auth/auth_store.dart';
import 'package:delivery_seller/app/modules/advertisement/advertisement_store.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'main_page.dart';
import 'main_store.dart';

class MainModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => MainStore()),
    Bind.lazySingleton((i) => AdvertisementStore()),
    Bind.lazySingleton((i) => AuthStore()),
    Bind<AuthService>((i) => AuthService()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => MainPage()),
  ];

  @override
  Widget get view => MainPage();
}
