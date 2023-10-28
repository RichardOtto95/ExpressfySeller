import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_seller/app/core/models/time_model.dart';
import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:delivery_seller/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_seller/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_seller/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../profile_store.dart';
import 'profile_data_tile.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileStore store = Modular.get();
  final genderKey = GlobalKey();
  final bankKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final LayerLink genderLayerLink = LayerLink();
  final LayerLink bankLayerLink = LayerLink();

  late OverlayEntry genderOverlay;
  late OverlayEntry bankOverlay;
  late OverlayEntry loadOverlay;

  FocusNode fullnameFocus = FocusNode();
  FocusNode birthdayFocus = FocusNode();
  FocusNode cpfFocus = FocusNode();
  FocusNode rgFocus = FocusNode();
  FocusNode issuerFocus = FocusNode();
  FocusNode genderFocus = FocusNode();
  FocusNode corporatenameFocus = FocusNode();
  FocusNode storenameFocus = FocusNode();
  FocusNode categoryFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode devolutionFocus = FocusNode();
  FocusNode warrantyFocus = FocusNode();
  FocusNode paymentFocus = FocusNode();
  FocusNode cnpjFocus = FocusNode();
  FocusNode openingHoursFocus = FocusNode();
  FocusNode bankFocus = FocusNode();
  FocusNode agencyFocus = FocusNode();
  FocusNode accountFocus = FocusNode();
  FocusNode operationFocus = FocusNode();

  @override
  void initState() {
    store.setProfileEditFromDoc();
    addGenderFocusListener();
    addBankFocusListener();
    addBirthdayFocusListener();
    super.initState();
  }

  @override
  void dispose() {
    openingHoursFocus.dispose();
    store.setProfileEditFromDoc();
    print('dispose profile edit');
    fullnameFocus.dispose();
    birthdayFocus.removeListener(() {});
    birthdayFocus.dispose();
    cpfFocus.dispose();
    rgFocus.dispose();
    issuerFocus.dispose();
    genderFocus.removeListener(() {});
    genderFocus.dispose();
    corporatenameFocus.dispose();
    storenameFocus.dispose();
    categoryFocus.dispose();
    descriptionFocus.dispose();
    devolutionFocus.dispose();
    warrantyFocus.dispose();
    paymentFocus.dispose();
    cnpjFocus.dispose();
    bankFocus.removeListener(() {});
    bankFocus.dispose();
    agencyFocus.dispose();
    accountFocus.dispose();
    operationFocus.dispose();
    super.dispose();
  }

  Future scrollToGender() async {
    final _context = genderKey.currentContext;
    double proportion = hXD(73, context) / maxWidth(context);
    // print(
    //     "propotion: ${(maxHeight(context) *) / maxHeight(context)}");
    await Scrollable.ensureVisible(_context!,
        alignment: proportion, duration: Duration(milliseconds: 400));
  }

  Future scrollToBank() async {
    final _context = bankKey.currentContext;
    double proportion = hXD(73, context) / maxWidth(context);
    // print(
    //     "propotion: ${(maxHeight(context) *) / maxHeight(context)}");
    await Scrollable.ensureVisible(_context!,
        alignment: proportion, duration: Duration(milliseconds: 400));
  }

  addGenderFocusListener() {
    genderFocus.addListener(() async {
      if (genderFocus.hasFocus) {
        scrollToGender();
        genderOverlay = getGenderOverlay();
        Overlay.of(context)!.insert(genderOverlay);
      } else {
        genderOverlay.remove();
      }
    });
  }

  addBankFocusListener() {
    bankFocus.addListener(() async {
      if (bankFocus.hasFocus) {
        scrollToBank();
        bankOverlay = getBankOverlay();
        Overlay.of(context)!.insert(bankOverlay);
      } else {
        bankOverlay.remove();
      }
    });
  }

  addBirthdayFocusListener() {
    birthdayFocus.addListener(() async {
      if (birthdayFocus.hasFocus) {
        FocusScope.of(context).requestFocus(new FocusNode());
        await store.setBirthday(context, () {
          cpfFocus.requestFocus();
        });
      }
    });
  }

  OverlayEntry getGenderOverlay() {
    List<String> genders = ["Feminino", "Masculino", "Outro"];
    return OverlayEntry(
      builder: (context) => Positioned(
        height: wXD(100, context),
        width: wXD(80, context),
        child: CompositedTransformFollower(
          offset: Offset(wXD(35, context), wXD(60, context)),
          link: genderLayerLink,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                color: white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      offset: Offset(0, 3),
                      color: totalBlack.withOpacity(.3))
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: genders
                    .map(
                      (gender) => InkWell(
                        onTap: () {
                          store.profileEdit['gender'] = gender;
                          genderFocus.unfocus();
                          corporatenameFocus.requestFocus();
                        },
                        child: Container(
                          height: wXD(20, context),
                          padding: EdgeInsets.only(left: wXD(8, context)),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            gender,
                            style: textFamily(),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry getBankOverlay() {
    List<String> banks = [
      "Itaú",
      "Inter",
      "Bradesco",
      "Caixa",
      "Santander",
      "Sicob",
      "Banco do Brasil",
      "C6 Bank",
    ];
    return OverlayEntry(
      builder: (context) => Positioned(
        // height: wXD(100, context),
        width: wXD(120, context),
        child: CompositedTransformFollower(
          offset: Offset(wXD(35, context), wXD(60, context)),
          link: bankLayerLink,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: wXD(10, context)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                color: white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      offset: Offset(0, 3),
                      color: totalBlack.withOpacity(.3))
                ],
              ),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: banks
                    .map(
                      (bank) => InkWell(
                        onTap: () {
                          store.profileEdit['bank'] = bank;
                          agencyFocus.requestFocus();
                        },
                        child: Container(
                          height: wXD(20, context),
                          padding: EdgeInsets.only(left: wXD(8, context)),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            bank,
                            style: textFamily(),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) =>
          FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Stack(
          children: [
            Observer(
              builder: (context) {
                if (store.profileEdit.isEmpty) {
                  return CenterLoadCircular();
                }
                return SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: wXD(22, context)),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 3,
                                      offset: Offset(0, 3),
                                      color: totalBlack.withOpacity(.2))
                                ],
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(60)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(60)),
                                child: Container(
                                  height: wXD(338, context),
                                  width: maxWidth(context),
                                  child: store.profileEdit['avatar'] == null
                                      ? Image.asset(
                                          "./assets/images/defaultUser.png",
                                          height: wXD(338, context),
                                          width: maxWidth(context),
                                          fit: BoxFit.fitWidth,
                                        )
                                      : store.profileEdit['avatar'] == ""
                                          ? Container(
                                              height: wXD(338, context),
                                              width: maxWidth(context),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: primary,
                                                ),
                                              ),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  store.profileEdit['avatar'],
                                              height: wXD(338, context),
                                              width: maxWidth(context),
                                              fit: BoxFit.fitWidth,
                                              progressIndicatorBuilder:
                                                  (context, value,
                                                      donwloadProgress) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: primary,
                                                ));
                                              },
                                            ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: wXD(30, context),
                              right: wXD(17, context),
                              child: InkWell(
                                onTap: () => store.pickAvatar(),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: veryLightGrey,
                                  size: wXD(30, context),
                                ),
                              ),
                            )
                          ],
                        ),
                        Visibility(
                          visible: store.avatarValidate,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: wXD(24, context), top: wXD(15, context)),
                            child: Text(
                              "Selecione uma imagem para continuar",
                              style: TextStyle(
                                color: Colors.red[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: wXD(23, context), top: wXD(21, context)),
                          child: Text(
                            'Dados do proprietário',
                            style: textFamily(
                              fontSize: 16,
                              color: primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ProfileDataTile(
                          title: 'Nome completo',
                          data: store.profileEdit['username'],
                          hint: 'Fulano Ciclano',
                          focusNode: fullnameFocus,
                          onComplete: () {
                            birthdayFocus.requestFocus();
                          },
                          onChanged: (txt) =>
                              store.profileEdit['username'] = txt,
                        ),
                        ProfileDataTile(
                          title: 'Data de nascimento',
                          hint: '99/99/9999',
                          data: store.profileEdit['birthday'] != null
                              ? Time(store.profileEdit['birthday'].toDate())
                                  .dayDate()
                              : null,
                          onPressed: () {
                            birthdayFocus.requestFocus();
                          },
                          focusNode: birthdayFocus,
                          validate: store.birthdayValidate,
                        ),
                        ProfileDataTile(
                          title: 'CPF',
                          hint: '999.999.999-99',
                          keyboardType: TextInputType.number,
                          data:
                              cpfMask.maskText(store.profileEdit['cpf'] ?? ''),
                          mask: cpfMask,
                          length: 11,
                          focusNode: cpfFocus,
                          onComplete: () => rgFocus.requestFocus(),
                          onChanged: (txt) => store.profileEdit['cpf'] = txt,
                        ),
                        ProfileDataTile(
                          title: 'RG',
                          hint: '999.999.99',
                          keyboardType: TextInputType.number,
                          data: rgMask.maskText(store.profileEdit['rg'] ?? ''),
                          mask: rgMask,
                          length: null,
                          focusNode: rgFocus,
                          onComplete: () => issuerFocus.requestFocus(),
                          onChanged: (txt) => store.profileEdit['rg'] = txt,
                        ),
                        ProfileDataTile(
                          title: 'Órgão emissor',
                          hint: 'SSP',
                          data: store.profileEdit['issuing_agency'],
                          focusNode: issuerFocus,
                          onComplete: () => genderFocus.requestFocus(),
                          onChanged: (txt) =>
                              store.profileEdit['issuing_agency'] = txt,
                        ),
                        CompositedTransformTarget(
                          link: genderLayerLink,
                          child: ProfileDataTile(
                            key: genderKey,
                            title: 'Gênero',
                            hint: 'Feminino',
                            data: store.profileEdit['gender'],
                            focusNode: genderFocus,
                            validate: store.genderValidate,
                            onPressed: () {
                              // print("Render press");
                              genderFocus.requestFocus();
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: wXD(23, context), top: wXD(21, context)),
                          child: Text(
                            'Dados da loja',
                            style: textFamily(
                              fontSize: 16,
                              color: primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ProfileDataTile(
                          title: 'Razão social',
                          hint: 'Lorem ipsum dolor sit amet',
                          data: store.profileEdit['corporate_name'],
                          focusNode: corporatenameFocus,
                          onComplete: () => storenameFocus.requestFocus(),
                          onChanged: (txt) =>
                              store.profileEdit['corporate_name'] = txt,
                        ),
                        ProfileDataTile(
                          title: 'Nome da loja',
                          hint: 'Lorem ipsum dolor sit amet',
                          data: store.profileEdit['store_name'],
                          focusNode: storenameFocus,
                          onComplete: () => categoryFocus.requestFocus(),
                          onChanged: (txt) =>
                              store.profileEdit['store_name'] = txt,
                        ),
                        ProfileDataTile(
                          title: 'Categoria da loja',
                          hint: 'Lorem ipsum dolor sit amet',
                          data: store.profileEdit['store_category'],
                          focusNode: categoryFocus,
                          onComplete: () => descriptionFocus.requestFocus(),
                          onChanged: (txt) =>
                              store.profileEdit['store_category'] = txt,
                        ),
                        ProfileDataTile(
                          title: 'Descrição da loja',
                          hint: 'Lorem ipsum dolor sit amet',
                          data: store.profileEdit['store_description'],
                          focusNode: descriptionFocus,
                          onComplete: () => devolutionFocus.requestFocus(),
                          onChanged: (txt) =>
                              store.profileEdit['store_description'] = txt,
                        ),
                        ProfileDataTile(
                          title: 'Políticas de devolução grátis',
                          hint: 'Lorem ipsum dolor sit amet',
                          data: store.profileEdit['return_policies'],
                          focusNode: devolutionFocus,
                          onComplete: () => warrantyFocus.requestFocus(),
                          onChanged: (txt) =>
                              store.profileEdit['return_policies'] = txt,
                        ),
                        ProfileDataTile(
                          title: 'Garantia',
                          hint: 'Lorem ipsum dolor sit amet',
                          data: store.profileEdit['warranty'],
                          focusNode: warrantyFocus,
                          onComplete: () => paymentFocus.requestFocus(),
                          onChanged: (txt) =>
                              store.profileEdit['warranty'] = txt,
                        ),
                        ProfileDataTile(
                          title: 'Forma de pagamento',
                          hint: 'Lorem ipsum dolor sit amet',
                          data: store.profileEdit['payment_method'],
                          focusNode: paymentFocus,
                          onComplete: () => cnpjFocus.requestFocus(),
                          onChanged: (txt) =>
                              store.profileEdit['payment_method'] = txt,
                        ),
                        ProfileDataTile(
                          title: 'CNPJ',
                          hint: '99.999.999/9999-99',
                          focusNode: cnpjFocus,
                          keyboardType: TextInputType.number,
                          data: cnpjMask
                              .maskText(store.profileEdit['cnpj'] ?? ''),
                          mask: cnpjMask,
                          length: 14,
                          onComplete: () => openingHoursFocus.requestFocus(),
                          onChanged: (txt) => store.profileEdit['cnpj'] = txt,
                        ),
                        ProfileDataTile(
                          keyboardType: TextInputType.number,
                          title: 'Horário de funcionamento',
                          hint: '14:00 às 16:00',
                          focusNode: openingHoursFocus,
                          data: openingHoursMask.maskText(
                              store.profileEdit['opening_hours'] ?? ''),
                          mask: openingHoursMask,
                          length: 8,
                          onComplete: () => bankFocus.requestFocus(),
                          onChanged: (txt) =>
                              store.profileEdit['opening_hours'] = txt,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: wXD(23, context), top: wXD(21, context)),
                          child: Text(
                            'Dados bancários',
                            style: textFamily(
                                fontSize: 16,
                                color: primary,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        CompositedTransformTarget(
                          link: bankLayerLink,
                          child: ProfileDataTile(
                            key: bankKey,
                            title: 'Banco',
                            data: store.profileEdit['bank'],
                            hint: 'Selecione seu banco',
                            focusNode: bankFocus,
                            validate: store.bankValidate,
                            onPressed: () => bankFocus.requestFocus(),
                          ),
                        ),
                        ProfileDataTile(
                          title: 'Agência',
                          hint: '9999',
                          keyboardType: TextInputType.number,
                          data: agencyMask
                              .maskText(store.profileEdit['agency'] ?? ''),
                          mask: agencyMask,
                          focusNode: agencyFocus,
                          length: 4,
                          onComplete: () => accountFocus.requestFocus(),
                          onChanged: (txt) => store.profileEdit['agency'] = txt,
                        ),
                        ProfileDataTile(
                          title: 'Conta',
                          hint: '999999999-99',
                          keyboardType: TextInputType.number,
                          data: accountMask
                              .maskText(store.profileEdit['account'] ?? ''),
                          mask: accountMask,
                          focusNode: accountFocus,
                          length: 11,
                          onComplete: () => operationFocus.requestFocus(),
                          onChanged: (txt) =>
                              store.profileEdit['account'] = txt,
                        ),
                        ProfileDataTile(
                          title: 'Operação',
                          hint: '999',
                          keyboardType: TextInputType.number,
                          data: store.profileEdit['operation'],
                          mask: operationMask,
                          focusNode: operationFocus,
                          length: 3,
                          onComplete: () => operationFocus.unfocus(),
                          onChanged: (txt) =>
                              store.profileEdit['operation'] = txt,
                        ),
                        SavingsCNPJ(),
                        SideButton(
                          onTap: () async {
                            bool _validate = store.getValidate();
                            if (_formKey.currentState!.validate() &&
                                _validate) {
                              await store.saveProfile(context);
                            }
                          },
                          height: wXD(52, context),
                          width: wXD(142, context),
                          title: 'Salvar',
                        ),
                        SizedBox(height: wXD(20, context))
                      ],
                    ),
                  ),
                );
              },
            ),
            DefaultAppBar('Editar perfil')
          ],
        ),
      ),
    );
  }
}

class SavingsCNPJ extends StatelessWidget {
  final ProfileStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: wXD(26, context),
        top: wXD(16, context),
        bottom: wXD(33, context),
      ),
      alignment: Alignment.centerLeft,
      child: Observer(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Esta é uma conta poupança?',
                style: textFamily(color: totalBlack.withOpacity(.6)),
              ),
              SizedBox(height: wXD(10, context)),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(300),
                    onTap: () => store.profileEdit['savings_account'] = true,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(right: wXD(9, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: primary, width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['savings_account']
                          ? Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primary,
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  Text(
                    'Sim',
                    style: textFamily(color: totalBlack.withOpacity(.6)),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(300),
                    onTap: () => store.profileEdit['savings_account'] = false,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(
                          right: wXD(9, context), left: wXD(15, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: primary, width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['savings_account']
                          ? Container()
                          : Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primary,
                              ),
                            ),
                    ),
                  ),
                  Text(
                    'Não',
                    style: textFamily(color: totalBlack.withOpacity(.6)),
                  ),
                ],
              ),
              SizedBox(height: wXD(24, context)),
              Text(
                'Esta conta bancária está vinculada ao CNPJ da \nloja?',
                style: textFamily(color: totalBlack.withOpacity(.6)),
              ),
              SizedBox(height: wXD(10, context)),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(300),
                    onTap: () => store.profileEdit['linked_to_cnpj'] = true,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(right: wXD(9, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: primary, width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['linked_to_cnpj']
                          ? Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primary,
                              ),
                            )
                          : Container(),
                    ),
                  ),
                  Text(
                    'Sim',
                    style: textFamily(color: totalBlack.withOpacity(.6)),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(300),
                    onTap: () => store.profileEdit['linked_to_cnpj'] = false,
                    child: Container(
                      height: wXD(17, context),
                      width: wXD(17, context),
                      margin: EdgeInsets.only(
                          right: wXD(9, context), left: wXD(15, context)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: primary, width: wXD(2, context)),
                      ),
                      alignment: Alignment.center,
                      child: store.profileEdit['linked_to_cnpj']
                          ? Container()
                          : Container(
                              height: wXD(9, context),
                              width: wXD(9, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primary,
                              ),
                            ),
                    ),
                  ),
                  Text(
                    'Não',
                    style: textFamily(color: totalBlack.withOpacity(.6)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
