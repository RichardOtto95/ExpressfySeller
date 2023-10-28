import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller/app/core/services/auth/auth_store.dart';
import 'package:delivery_seller/app/modules/main/main_store.dart';
import 'package:delivery_seller/app/modules/profile/widget/profile_app_bar.dart';
import 'package:delivery_seller/app/modules/profile/widget/profile_tile.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:delivery_seller/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_seller/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_seller/app/modules/profile/profile_store.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String title;
  const ProfilePage({Key? key, this.title = 'ProfilePage'}) : super(key: key);
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final ProfileStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final AuthStore authStore = Modular.get();
  late OverlayEntry overlayEntry;
  OverlayEntry? overlayCircular;

  @override
  initState() {
    store.setProfileEditFromDoc();
    super.initState();
  }

  @override
  dispose() {
    // print('dispose profile');
    super.dispose();
  }

  OverlayEntry getOverlay() {
    return OverlayEntry(
      builder: (context) => ConfirmPopup(
        text: 'Tem certeza que deseja sair?',
        onConfirm: () async {
          overlayCircular =
              OverlayEntry(builder: (context) => LoadCircularOverlay());
          overlayEntry.remove();
          Overlay.of(context)!.insert(overlayCircular!);
          User? _user = FirebaseAuth.instance.currentUser;
          String? token = await FirebaseMessaging.instance.getToken();
          await FirebaseFirestore.instance
              .collection('sellers')
              .doc(_user!.uid)
              .update({
            'token_id': FieldValue.arrayRemove([token]),
          });

          authStore.signout();
          overlayCircular!.remove();
          overlayCircular = null;
          mainStore.page = 0;
          await Modular.to.pushReplacementNamed("/sign");
        },
        onCancel: () {
          overlayEntry.remove();
          // print('naaaaaaoo');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      print(
          "observer store.profileEdit['new_ratings']: ${store.profileEdit['new_ratings']}");
      if (store.profileEdit.isEmpty) {
        return CenterLoadCircular();
      }
      return Column(
        children: [
          ProfileAppBar(),
          SizedBox(height: wXD(8, context)),
          ProfileTile(
            icon: Icons.star_outline_rounded,
            title: 'Avaliações',
            notifications: store.profileEdit['new_ratings'],
            onTap: () async => await Modular.to.pushNamed('/profile/ratings'),
          ),
          ProfileTile(
            icon: Icons.question_answer_outlined,
            title: 'Perguntas',
            notifications: store.profileEdit['new_questions'],
            onTap: () async => await Modular.to.pushNamed('/profile/questions'),
          ),
          ProfileTile(
            icon: Icons.email_outlined,
            title: 'Mensagens',
            notifications: store.profileEdit['new_messages'],
            onTap: () async => await Modular.to.pushNamed('/messages'),
          ),
          // ProfileTile(
          //   icon: Icons.account_balance_wallet_outlined,
          //   title: 'Financeiro',
          //   onTap: () async => await Modular.to.pushNamed('/financial'),
          // ),
          ProfileTile(
            icon: Icons.headset_mic_outlined,
            title: 'Suporte',
            notifications: store.profileEdit['new_support_messages'],
            onTap: () async => await Modular.to.pushNamed('/profile/support'),
          ),
          ProfileTile(
            icon: Icons.settings_outlined,
            title: 'Configurações',
            onTap: () async => await Modular.to.pushNamed('/profile/settings'),
          ),
          ProfileTile(
            icon: Icons.exit_to_app_outlined,
            title: 'Sair',
            onTap: () {
              overlayEntry = getOverlay();
              Overlay.of(context)?.insert(overlayEntry);
            },
          ),
        ],
      );
    });
  }
}
