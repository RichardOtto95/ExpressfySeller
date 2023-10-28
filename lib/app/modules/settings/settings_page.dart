import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:delivery_seller/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../profile/profile_store.dart';
import 'widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  final ProfileStore store = Modular.get();
  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: wXD(100, context)),
                Container(
                  width: maxWidth(context),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: darkGrey.withOpacity(.2)))),
                  padding: EdgeInsets.only(bottom: wXD(4, context)),
                  margin: EdgeInsets.only(
                    left: wXD(32, context),
                    right: wXD(16, context),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notificações',
                        style: textFamily(
                          color: darkGrey,
                          fontSize: 18,
                        ),
                      ),
                      Observer(builder: (context) {
                        return Switch(
                          value: store.profileEdit['notification_enabled'],
                          onChanged: (change) {
                            store.changeNotificationEnabled(change);
                          },
                        );
                      }),
                    ],
                  ),
                ),
                SettingsTile(
                  title: 'Informações do app',
                  onTap: () => Modular.to.pushNamed('/profile/app-info'),
                ),
                SettingsTile(
                  title: 'Termos de uso',
                  onTap: () => Modular.to.pushNamed('/profile/terms'),
                ),
                SettingsTile(
                  title: 'Política de privacidade',
                  onTap: () => Modular.to.pushNamed('/profile/privacy'),
                ),
                SettingsTile(
                  title: 'Ajuda',
                  onTap: () {},
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: wXD(32, context),
                    top: wXD(20, context),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Versão ',
                        style: textFamily(
                          color: darkGrey,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '1.0',
                        style: textFamily(
                          color: darkGrey.withOpacity(.7),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DefaultAppBar('Configurações'),
        ],
      ),
    );
  }
}
