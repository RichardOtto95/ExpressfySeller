import 'package:delivery_seller/app/modules/orders/orders_store.dart';
import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OrdersAppBar extends StatelessWidget {
  final Function(int value) onTap;
  final OrdersStore store = Modular.get();

  OrdersAppBar({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).viewPadding.top + wXD(70, context),
      width: maxWidth(context),
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
        color: white,
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(0, 3),
            color: Color(0x30000000),
          ),
        ],
      ),
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Pedidos',
              style: textFamily(
                fontSize: 20,
                color: darkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: wXD(10, context)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: maxWidth(context),
                margin: EdgeInsets.only(left: wXD(30, context)),
                child: DefaultTabController(
                  length: 3,
                  child: TabBar(
                    indicatorColor: primary,
                    indicatorSize: TabBarIndicatorSize.label,
                    labelPadding: EdgeInsets.symmetric(vertical: 8),
                    labelColor: primary,
                    labelStyle: textFamily(fontWeight: FontWeight.bold),
                    unselectedLabelColor: darkGrey,
                    indicatorWeight: 3,
                    onTap: (value) {
                      print('value value: $value');
                      onTap(value);
                      // if (value == 0)
                      //   store.setOrderStatusView(["REQUESTED"].asObservable());
                      // else if (value == 1)
                      //   store.setOrderStatusView([
                      //     "SENDED",
                      //     "PROCESSING",
                      //     "DELIVERY_REQUESTED",
                      //     "DELIVERY_REFUSED",
                      //     "DELIVERY_ACCEPTED",
                      //     "TIMEOUT",
                      //   ].asObservable());
                      // else if (value == 2)
                      //   store.setOrderStatusView([
                      //     "CANCELED",
                      //     "REFUSED",
                      //     "CONCLUDED",
                      //   ].asObservable());
                    },
                    tabs: [
                      Text('Pendentes'),
                      Text('Em andamento'),
                      Text('Concluídos'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
