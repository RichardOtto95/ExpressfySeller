import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';

import 'package:flutter/material.dart';

class StatusForecast extends StatelessWidget {
  final String status;
  final String? deliveryForecast;
  const StatusForecast({
    Key? key,
    required this.status,
    required this.deliveryForecast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: wXD(56, context),
        width: wXD(343, context),
        margin: EdgeInsets.only(bottom: wXD(20, context)),
        padding: EdgeInsets.symmetric(
            vertical: wXD(13, context), horizontal: wXD(16, context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              color: Color(0x30000000),
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status atual',
                  style: textFamily(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                Text(
                  getPortugueseStatus(status),
                  style: textFamily(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Previsão de entrega',
                  style: textFamily(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                deliveryForecast == null
                    ? Container(
                        height: wXD(12, context),
                        width: wXD(80, context),
                        child: LinearProgressIndicator(
                          color: primary.withOpacity(.4),
                          backgroundColor: primary.withOpacity(.4),
                          valueColor: AlwaysStoppedAnimation(primary),
                        ),
                      )
                    : Text(
                        deliveryForecast!,
                        style: textFamily(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
