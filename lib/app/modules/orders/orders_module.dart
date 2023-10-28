import 'package:delivery_seller/app/modules/orders/orders_Page.dart';
import 'package:delivery_seller/app/modules/orders/orders_store.dart';
import 'package:delivery_seller/app/modules/orders/widgets/all_characteristics.dart';
import 'package:delivery_seller/app/modules/orders/widgets/order_details.dart';
import 'package:delivery_seller/app/modules/orders/widgets/shipping_details.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OrdersModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => OrdersStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => OrdersPage()),
    ChildRoute('/order-details',
        child: (_, args) => OrderDetails(adsOrder: args.data)),
    ChildRoute('/characteristics', child: (_, args) => AllCharacteristics()),
    ChildRoute('/shipping-details',
        child: (_, args) => ShippingDetails(orderId: args.data)),
  ];

  @override
  Widget get view => OrdersPage();
}
