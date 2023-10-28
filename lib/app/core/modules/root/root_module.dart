import 'package:delivery_seller/app/core/modules/splash/splash_module.dart';
import 'package:delivery_seller/app/modules/address/address_module.dart';
import 'package:delivery_seller/app/modules/advertisement/advertisement_module.dart';
import 'package:delivery_seller/app/modules/financial/financial_module.dart';
import 'package:delivery_seller/app/modules/home/home_module.dart';
import 'package:delivery_seller/app/modules/main/main_module.dart';
import 'package:delivery_seller/app/modules/messages/messages_module.dart';
import 'package:delivery_seller/app/modules/orders/orders_module.dart';
import 'package:delivery_seller/app/modules/product/product_module.dart';
import 'package:delivery_seller/app/modules/profile/profile_module.dart';
import 'package:delivery_seller/app/modules/sign/sign_module.dart';
import 'package:delivery_seller/app/modules/sign/widgets/on_boarding.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../modules/main/main_store.dart';
import 'root_page.dart';
import 'root_store.dart';

class RootModule extends MainModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RootStore()),
    Bind.lazySingleton((i) => MainStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => RootPage()),
    ChildRoute('/on-boarding', child: (_, args) => OnBoarding()),
    ModuleRoute('/splash', module: SplashModule()),
    ModuleRoute('/main', module: MainModule()),
    ModuleRoute('/home', module: HomeModule()),
    ModuleRoute('/sign', module: SignModule()),
    ModuleRoute('/orders', module: OrdersModule()),
    ModuleRoute('/product', module: ProductModule()),
    ModuleRoute('/address', module: AddressModule()),
    ModuleRoute('/profile', module: ProfileModule()),
    ModuleRoute('/messages', module: MessagesModule()),
    ModuleRoute('/financial', module: FinancialModule()),
    ModuleRoute('/advertisement', module: AdvertisementModule()),
  ];
}
