import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../profile_store.dart';

class RatingsAppbar extends StatelessWidget {
  final Function(int)? onTap;
  RatingsAppbar({Key? key, this.onTap}) : super(key: key);
  final ProfileStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).viewPadding.top + wXD(70, context),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top,
            right: wXD(30, context),
            left: wXD(30, context),
          ),
          width: maxWidth(context),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Avaliações',
                style: textFamily(
                  fontSize: 20,
                  color: darkBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: wXD(10, context)),
              DefaultTabController(
                length: 2,
                child: TabBar(
                  onTap: onTap,
                  indicatorColor: primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.symmetric(vertical: 8),
                  labelColor: primary,
                  labelStyle: textFamily(fontWeight: FontWeight.bold),
                  unselectedLabelColor: darkGrey,
                  indicatorWeight: 3,
                  tabs: [
                    Text('Pendentes'),
                    Text('Concluídas'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: wXD(30, context),
          top: MediaQuery.of(context).viewPadding.top,
          child: GestureDetector(
            onTap: () => Modular.to.pop(),
            child:
                Icon(Icons.arrow_back, color: darkGrey, size: wXD(25, context)),
          ),
        )
      ],
    );
  }
}
