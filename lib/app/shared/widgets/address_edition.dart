import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:place_picker/place_picker.dart';
import '../../core/models/address_model.dart';
import '../../modules/address/address_page.dart';
import '../../modules/address/address_store.dart';
import '../color_theme.dart';
import '../utilities.dart';
import 'overlays.dart';
import 'side_button.dart';

class AddressEdition extends StatefulWidget {
  final bool homeRoot;
  final Future<void> Function() onBack;
  final bool editing;
  final BuildContext context;
  final Address model;

  AddressEdition({
    Key? key,
    required this.homeRoot,
    required this.onBack,
    required this.context,
    this.editing = false,
    required this.model,
  }) : super(key: key);

  @override
  _AddressEditionState createState() => _AddressEditionState();
}

class _AddressEditionState extends State<AddressEdition> {
  final AddressStore addressStore = Modular.get();

  final _formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  double height = 0;

  bool withoutComplement = false;
  bool main = false;

  Map<String, dynamic> addressMap = {};
  Map<String, dynamic> addressEditMap = {};

  FocusNode numberFocus = FocusNode();
  FocusNode complementFocus = FocusNode();
  FocusNode neighborhoodFocus = FocusNode();

  late Address address;

  @override
  void initState() {
    address = widget.model;
    addressMap = widget.model.toJson();
    main = widget.model.main ?? false;
    withoutComplement = widget.model.withoutComplement ?? false;
    if (!widget.editing) {
      addressMap["cep"] = addressStore.locationResult!.postalCode != null
          ? addressStore.locationResult!.postalCode!.replaceAll("-", "")
          : "";
      addressMap["city"] =
          addressStore.locationResult!.administrativeAreaLevel2 != null
              ? addressStore.locationResult!.administrativeAreaLevel2!.name
              : "";
      addressMap["state"] =
          addressStore.locationResult!.administrativeAreaLevel1 != null
              ? addressStore.locationResult!.administrativeAreaLevel1!.name
              : "";
      addressMap["main"] = widget.model.main;
      addressMap["formated_address"] =
          addressStore.locationResult!.formattedAddress;
      addressMap["latitude"] = addressStore.locationResult!.latLng!.latitude;
      addressMap["longitude"] = addressStore.locationResult!.latLng!.longitude;
      addressMap["status"] = "ACTIVE";
    }

    if (widget.editing) {
      addressEditMap = addressMap;
      addressMap["main"] = widget.model.main;
      addressEditMap["main"] = addressMap["main"];
      addressEditMap.remove("created_at");
    }

    if (addressMap["main"] == null) {
      addressMap["main"] = false;
    }

    if (addressEditMap["main"] == null) {
      addressEditMap["main"] = false;
    }

    print("addressMap: $addressMap");
    print("addressEditMap: $addressEditMap");

    numberFocus.addListener(() async {
      if (numberFocus.hasFocus) {
        height = 100;
        setState(() {});
        print("height = 100");

        await Future.delayed(Duration(milliseconds: 300));
        print("Animating");
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        setState(() {
          height = 0;
        });
      }
    });

    complementFocus.addListener(() async {
      if (complementFocus.hasFocus) {
        height = 100;
        setState(() {});
        print("height = 100");

        await Future.delayed(Duration(milliseconds: 300));
        print("Animating");
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        setState(() {
          height = 0;
        });
      }
    });

    neighborhoodFocus.addListener(() async {
      if (neighborhoodFocus.hasFocus) {
        // height = 100;
        // setState(() {});
        // print("height = 100");

        // await Future.delayed(Duration(milliseconds: 300));
        // print("Animating");
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    numberFocus.removeListener(() {});
    numberFocus.dispose();
    complementFocus.removeListener(() {});
    complementFocus.dispose();
    neighborhoodFocus.removeListener(() {});
    neighborhoodFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) =>
          FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        height: maxHeight(context),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  color: Colors.transparent,
                  height: wXD(141, context),
                  width: maxWidth(context),
                ),
              ),
              Container(
                // height: hXD(526, context),
                width: maxWidth(context),
                padding: EdgeInsets.only(top: wXD(24, context)),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(17)),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: maxWidth(context),
                              alignment: Alignment.center,
                              child: Text(
                                'Conferir endereço',
                                style: textFamily(
                                  fontSize: 15,
                                  color: Color(0xff241332).withOpacity(.5),
                                ),
                              ),
                            ),
                            Positioned(
                              right: wXD(26, context),
                              child: InkWell(
                                onTap: widget.onBack,
                                child: Icon(
                                  Icons.close,
                                  size: wXD(22, context),
                                  color: Color(0xff241332).withOpacity(.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: wXD(21, context),
                            right: wXD(21, context),
                            top: wXD(28, context),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Esse é o endereço do local indicado no mapa.',
                                style: textFamily(
                                  fontSize: 14,
                                  color: Color(0xff241332),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Você pode editar o texto, se necessário.',
                                style: textFamily(
                                    fontSize: 14,
                                    color: Color(0xff241332),
                                    fontWeight: FontWeight.w400,
                                    height: 1.4),
                              ),
                            ],
                          ),
                        ),
                        AddressField(
                          'Nome',
                          initialValue: addressMap["address_name"],
                          onChanged: (val) {
                            address.addressName = val;
                            !widget.editing
                                ? addressMap['address_name'] = val
                                : addressEditMap["address_name"] = val;
                          },
                        ),
                        AddressField(
                          'CEP',
                          textInputType: TextInputType.number,
                          initialValue: addressMap["cep"],
                          inputFormatters: [cepMask],
                          onChanged: (val) => !widget.editing
                              ? addressMap['cep'] = val
                              : addressEditMap["cep"] = val,
                          enabled: true,
                          validate: true,
                          validator: (txt) {
                            if (txt != null && txt.length < 8) {
                              return "Preencha o campo por completo";
                            }
                            return null;
                          },
                        ),
                        AddressField(
                          'Cidade',
                          enabled: false,
                          initialValue: addressMap["city"],
                        ),
                        AddressField(
                          'Estado',
                          enabled: false,
                          initialValue: addressMap["state"],
                        ),
                        AddressField(
                          'Bairro',
                          onChanged: (val) {
                            address.neighborhood = val;
                            !widget.editing
                                ? addressMap['neighborhood'] = val
                                : addressEditMap["neighborhood"] = val;
                          },
                          initialValue: addressMap["neighborhood"],
                          focus: neighborhoodFocus,
                        ),
                        AddressField(
                          'Endereço',
                          initialValue: addressMap["formated_address"],
                          onChanged: (val) => !widget.editing
                              ? addressMap['formated_address'] = val
                              : addressEditMap["formated_address"] = val,
                        ),
                        Row(
                          children: [
                            SizedBox(width: wXD(18, context)),
                            AddressField(
                              'Número',
                              width: wXD(120, context),
                              initialValue: addressMap["address_number"],
                              onChanged: (val) {
                                address.addressNumber = val;
                                !widget.editing
                                    ? addressMap['address_number'] = val
                                    : addressEditMap["address_number"] = val;
                              },
                              focus: numberFocus,
                            ),
                            SizedBox(width: wXD(12, context)),
                            AddressField(
                              'Complemento',
                              width: wXD(207, context),
                              onChanged: (val) {
                                address.addressComplement = val;
                                !widget.editing
                                    ? addressMap['address_complement'] = val
                                    : addressEditMap["address_complement"] =
                                        val;
                              },
                              initialValue: addressMap["address_complement"],
                              validate: !withoutComplement,
                              focus: complementFocus,
                            ),
                          ],
                        ),
                        Container(
                          width: maxWidth(context),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            top: wXD(23, context),
                            left: wXD(15, context),
                            bottom: wXD(38, context),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    withoutComplement = !withoutComplement;                                  
                                    addressMap["withoutcomplement"] = withoutComplement;
                                    addressEditMap["withoutcomplement"] = withoutComplement;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: wXD(20, context),
                                      width: wXD(20, context),
                                      margin: EdgeInsets.only(
                                          right: wXD(3, context)),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        border: Border.all(
                                          color: veryLightGrey,
                                        ),
                                        color: withoutComplement
                                            ? primary
                                            : Colors.transparent,
                                      ),
                                    ),
                                    Text(
                                      'Não tenho complemento',
                                      style: textFamily(
                                        fontSize: 13,
                                        color:
                                            Color(0xff555869).withOpacity(.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: wXD(12, context)),
                              GestureDetector(
                                onTap: () => setState(() {
                                  main = !main;
                                  addressMap["main"] = main;
                                  addressEditMap["main"] = main;
                                }),
                                child: Row(
                                  children: [
                                    Container(
                                      height: wXD(20, context),
                                      width: wXD(20, context),
                                      margin: EdgeInsets.only(
                                          right: wXD(3, context)),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        border: Border.all(
                                          color: veryLightGrey,
                                        ),
                                        color:
                                            main ? primary : Colors.transparent,
                                      ),
                                    ),
                                    Text(
                                      'Definir como principal',
                                      style: textFamily(
                                        fontSize: 13,
                                        color:
                                            Color(0xff555869).withOpacity(.6),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SideButton(
                          onTap: () async {
                            // addressStore.setCheckLocation(false);
                            // print("homeRoot: $homeRoot");

                            if (_formKey.currentState!.validate()) {
                              if (widget.editing) {
                                await addressStore.newAddress(
                                    addressEditMap, context, widget.editing);
                                widget.onBack();
                              } else {
                                await addressStore.newAddress(
                                    addressMap, context, widget.editing);
                                widget.onBack();
                              }
                            }
                          },
                          title: 'Salvar',
                          width: wXD(142, context),
                          height: wXD(52, context),
                        ),
                        SizedBox(height: wXD(16, context)),
                        TextButton(
                          onPressed: () async {
                            await widget.onBack();
                            LatLng latLng = LatLng(addressMap["latitude"],
                                addressMap["longitude"]);

                            LocationResult? locationResult = await Modular.to
                                .pushNamed("/address/place-picker",
                                    arguments: latLng);

                            print("locationResult: $locationResult");

                            if (locationResult != null) {
                              print("location diferente de nulo");
                              addressStore.locationResult = locationResult;

                              if (locationResult.postalCode != null) {
                                address.cep = locationResult.postalCode!
                                    .replaceAll("-", "");
                              }
                              if (locationResult.administrativeAreaLevel2 !=
                                  null) {
                                address.city = locationResult
                                    .administrativeAreaLevel2!.name;
                              }
                              if (locationResult.administrativeAreaLevel1 !=
                                  null) {
                                address.state = locationResult
                                    .administrativeAreaLevel1!.name;
                              }
                              if (locationResult.formattedAddress != null) {
                                address.formatedAddress =
                                    locationResult.formattedAddress;
                              }
                              address.main = addressMap["main"];
                              address.latitude =
                                  locationResult.latLng!.latitude;
                              address.longitude =
                                  locationResult.latLng!.longitude;
                              OverlayEntry? _overlay;
                              _overlay = OverlayEntry(
                                builder: (context) => EditAddress(
                                  context,
                                  address: address,
                                  editing: widget.editing,
                                  onBack: () => _overlay!.remove(),
                                ),
                              );
                              Overlay.of(addressStore.addressPageContext!)!
                                  .insert(_overlay);
                              // Overlays(widget.context).insertAddAddress(
                              //   editing: true,
                              // );
                            } else {
                              print("location igual a nulo");
                              Overlays(context).insertAddAddress(
                                editing: widget.editing,
                              );
                            }
                          },
                          child: Text(
                            'Alterar local no mapa',
                            style: textFamily(fontSize: 14, color: blue),
                          ),
                        ),
                        SizedBox(height: wXD(17, context)),
                        Container(height: wXD(height, context)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddressField extends StatelessWidget {
  final double? width;
  final String title;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool validate;
  final bool enabled;
  final void Function(String)? onChanged;
  final FocusNode? focus;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;

  AddressField(
    this.title, {
    this.width,
    this.initialValue,
    this.inputFormatters,
    this.validate = true,
    this.onChanged,
    this.enabled = true,
    this.focus,
    this.validator,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? wXD(339, context),
      margin: EdgeInsets.only(top: wXD(29, context)),
      padding: EdgeInsets.fromLTRB(
        wXD(8, context),
        wXD(6, context),
        wXD(8, context),
        wXD(6, context),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: totalBlack.withOpacity(.11)),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: white,
        boxShadow: [
          BoxShadow(
              blurRadius: wXD(7, context),
              offset: Offset(0, wXD(10, context)),
              color: totalBlack.withOpacity(.06))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textFamily(
              fontSize: 15,
              color: Color(0xff898989).withOpacity(.7),
              // fontWeight: FontWeight.w400,
              // height: 1.4
            ),
          ),
          Container(
            width: wXD(315, context),
            child: TextFormField(
              keyboardType: textInputType,
              focusNode: focus,
              enabled: enabled,
              onChanged: onChanged,
              validator: (val) {
                if (validate) {
                  if (val != null && val.isEmpty) {
                    return "Preencha o campo corretamente";
                  }
                  if (validator != null) {
                    return validator!(val);
                  }
                }
              },
              initialValue: initialValue,
              inputFormatters: inputFormatters,
              decoration: InputDecoration.collapsed(hintText: ''),
            ),
          ),
        ],
      ),
    );
  }
}
