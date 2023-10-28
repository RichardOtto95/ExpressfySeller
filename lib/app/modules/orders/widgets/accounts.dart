import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class Accounts extends StatelessWidget {
  final num totalPrice, shippingPrice;
  final num? discount, newTotalPrice, change;
  const Accounts(
      {Key? key,
      required this.totalPrice,
      required this.shippingPrice,
      this.discount,
      this.newTotalPrice,
      required this.change})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.fromLTRB(
        wXD(30, context),
        wXD(15, context),
        wXD(20, context),
        wXD(30, context),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Sub Total',
                style: textFamily(
                  fontSize: 15,
                  color: darkGrey,
                ),
              ),
              Spacer(),
              Text(
                'R\$ ${formatedCurrency(totalPrice - shippingPrice)}',
                style: textFamily(
                  fontSize: 15,
                  color: primary,
                ),
              ),
            ],
          ),
          SizedBox(height: wXD(12, context)),
          Row(
            children: [
              Text(
                'Frete',
                style: textFamily(
                  fontSize: 15,
                  color: darkGrey,
                ),
              ),
              Spacer(),
              Text(
                'R\$ ${formatedCurrency(shippingPrice)}',
                style: textFamily(
                  fontSize: 15,
                  color: primary,
                ),
              ),
            ],
          ),
          SizedBox(height: wXD(12, context)),
          Row(
            children: [
              Text(
                'Total',
                style: textFamily(
                  fontSize: 15,
                  color: darkGrey,
                ),
              ),
              Spacer(),
              Text(
                'R\$ ${formatedCurrency((totalPrice))}',
                style: textFamily(
                  fontSize: 15,
                  color: primary,
                ),
              ),
            ],
          ),
          discount == null
              ? Container()
              : Column(
                  children: [
                    SizedBox(height: wXD(12, context)),
                    Row(
                      children: [
                        Text(
                          'Desconto',
                          style: textFamily(
                            fontSize: 15,
                            color: darkGrey,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'R\$ -${formatedCurrency((discount))}',
                          style: textFamily(
                            fontSize: 15,
                            color: red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: wXD(12, context)),
                    Row(
                      children: [
                        Text(
                          'Pago',
                          style: textFamily(
                            fontSize: 15,
                            color: darkGrey,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'R\$ ${formatedCurrency((newTotalPrice))}',
                          style: textFamily(
                            fontSize: 15,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          change == null
              ? Container()
              : Column(
                  children: [
                    SizedBox(height: wXD(12, context)),
                    Row(
                      children: [
                        Text(
                          'Troco',
                          style: textFamily(
                            fontSize: 15,
                            color: darkGrey,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'R\$ ${formatedCurrency((change))}',
                          style: textFamily(
                            fontSize: 15,
                            color: primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
