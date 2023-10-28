import 'package:delivery_seller/app/modules/main/main_store.dart';
import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_seller/app/modules/home/home_store.dart';
import 'package:flutter/material.dart';

import 'widgets/black_app_bar.dart';
import 'widgets/home_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeStore>
    with SingleTickerProviderStateMixin {
  MainStore mainStore = Modular.get();

  int selected = 0;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        mainStore.setVisibleNav(true);
      } else {
        mainStore.setVisibleNav(false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: viewPaddingTop(context) + wXD(70, context),
                    width: maxWidth(context)),
                HomeCard(),
                Padding(
                  padding: EdgeInsets.only(
                    left: wXD(16, context),
                    top: wXD(12, context),
                    bottom: wXD(16, context),
                  ),
                  child: Text(
                    'Operações/Estatísticas',
                    style: textFamily(
                      fontSize: 17,
                      color: textTotalBlack,
                    ),
                  ),
                ),
                Period(
                  onToday: () => setState(() => selected = 0),
                  onWeek: () => setState(() => selected = 1),
                  onMonth: () => setState(() => selected = 2),
                  selected: selected,
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                    future: store.getStatistics(selected),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }
                      return Container(
                        width: maxWidth(context),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(
                              horizontal: wXD(5, context),
                              vertical: wXD(25, context)),
                          child: Row(
                            children: [
                              // Goal(
                              //   ideal: true,
                              //   data: '98,6%',
                              //   title: 'Tempo aberto',
                              //   subtitle: 'Ideal acima de 75%',
                              //   onTap: () {},
                              // ),
                              // Goal(
                              //   ideal: false,
                              //   data: '2,1%',
                              //   title: 'Cancelamentos',
                              //   subtitle: 'Ideal abaixo de 1,8%',
                              //   onTap: () {},
                              // ),
                              // Goal(
                              //   ideal: true,
                              //   data: '10%',
                              //   title: 'Atrasos',
                              //   subtitle: 'Ideal abaixo de 13%',
                              //   onTap: () {},
                              // ),
                              Goal(
                                // ideal: true,
                                // data: '4',
                                data: snapshot.data,
                                index: 0,
                                title: 'Pedidos ' + getText(),
                                onTap: () {},
                              ),
                              Goal(
                                // ideal: true,
                                // data: 'R\$150',
                                data: snapshot.data,
                                index: 1,
                                title: 'Vendas ' + getText(),
                                onTap: () {
                                  print('onTap externo');
                                  // Modular.to.pushNamed('/home/best-sellers');
                                },
                              ),
                              Goal(
                                // ideal: true,
                                // data: '4,5',
                                data: snapshot.data,
                                index: 2,
                                title: 'Avaliações ' + getText(),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                SizedBox(height: wXD(90, context), width: maxWidth(context)),
              ],
            ),
          ),
          BlackAppBar(),
        ],
      ),
    );
  }

  String getText() {
    switch (selected) {
      case 0:
        return "de hoje";

      case 1:
        return "da semana";

      case 2:
        return "do mês";

      default:
        return "";
    }
  }
}

class Goal extends StatelessWidget {
  // final bool ideal;
  final List<Map<String, dynamic>>? data;
  final String title;
  final int index;
  final void Function() onTap;

  Goal({
    Key? key,
    // required this.ideal,
    this.data,
    required this.title,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return Container(
        height: wXD(85, context),
        width: wXD(127, context),
        padding:
            EdgeInsets.only(top: wXD(13, context), bottom: wXD(17, context)),
        margin: EdgeInsets.symmetric(horizontal: wXD(5, context)),
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: primary.withOpacity(.4)),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(0, 3),
              color: Color(0x30000000),
            )
          ],
        ),
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: primary,
        ),
      );
    }
    Map<String, dynamic> statisticMap = data![index];
    print('statisticMap: $statisticMap');
    print('statisticMap valid: ${statisticMap['valid']}');
    return GestureDetector(
      onTap: () {
        print('onTap interno');
        onTap();
      },
      child: Container(
        height: wXD(86, context),
        width: wXD(130, context),
        padding:
            EdgeInsets.only(top: wXD(13, context), bottom: wXD(17, context)),
        margin: EdgeInsets.symmetric(horizontal: wXD(5, context)),
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: primary.withOpacity(.4)),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(0, 3),
              color: Color(0x30000000),
            )
          ],
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: wXD(10, context),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: wXD(5, context)),
                    height: wXD(12, context),
                    width: wXD(12, context),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statisticMap['valid'] ? green : red,
                    ),
                  ),
                  Container(
                    // width: wXD(112, context),
                    child: Text(
                      getText(index, statisticMap),
                      style: textFamily(
                        fontSize: 15,
                        color: textTotalBlack,
                      ),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: wXD(5, context)),
            Text(
              title,
              style: textFamily(
                fontSize: 12,
                color: textTotalBlack,
              ),
            ),
            SizedBox(height: wXD(2, context)),
            Text(
              'Meta acima de ' + getSubTitle(index, statisticMap),
              style: textFamily(
                fontSize: 9,
                color: grey.withOpacity(.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getText(int index, Map<String, dynamic> statisticMap) {
    if (index == 0) {
      return statisticMap['ordersLength'].toString();
    }
    if (index == 1) {
      return '${formatedCurrency(statisticMap['totalAmount'])} R\$';
      // return formatedCurrency(99999999999999999);

      // return statisticMap['totalAmount'].toString();
    }
    if (index == 2) {
      return statisticMap['ratings'].toString();
    }
    return "";
  }

  String getSubTitle(int index, Map<String, dynamic> statisticMap) {
    if (index == 1) {
      print(
          'formattedPrice ${formatedCurrency(statisticMap['isGreaterThan'])}');
      return '${formatedCurrency(statisticMap['isGreaterThan'])} R\$';
    } else {
      return statisticMap['isGreaterThan'].toString();
    }
    // return "";
  }
}

class Period extends StatelessWidget {
  final void Function() onToday;
  final void Function() onWeek;
  final void Function() onMonth;
  final int selected;

  Period(
      {required this.onToday,
      required this.onWeek,
      required this.onMonth,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: wXD(40, context),
        width: wXD(342, context),
        decoration: BoxDecoration(
          border: Border.all(color: totalBlack, width: wXD(1.6, context)),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            Spacer(),
            GestureDetector(
              onTap: onToday,
              child: Text(
                'Hoje',
                style: textFamily(
                  fontSize: 16,
                  color: selected == 0 ? primary : textTotalBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Spacer(),
            Container(
              height: wXD(40, context),
              width: wXD(150, context),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  vertical: BorderSide(
                    color: totalBlack,
                    width: wXD(2, context),
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: onWeek,
                child: Text(
                  'Semana',
                  style: textFamily(
                    fontSize: 16,
                    color: selected == 1 ? primary : textTotalBlack,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: onMonth,
              child: Text(
                'Mês',
                style: textFamily(
                  fontSize: 16,
                  color: selected == 2 ? primary : textTotalBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
