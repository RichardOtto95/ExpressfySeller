import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';

import 'package:flutter/material.dart';

class SearchMessages extends StatefulWidget {
  final void Function(String) onChanged;

  SearchMessages({Key? key, required this.onChanged}) : super(key: key);
  @override
  _SearchMessagesState createState() => _SearchMessagesState();
}

class _SearchMessagesState extends State<SearchMessages> {
  FocusNode searchFocus = FocusNode();
  bool searching = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOutQuart,
      width:
          searching ? maxWidth(context) - wXD(16, context) : wXD(68, context),
      height: wXD(41, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(17)),
        border: Border.all(color: darkGrey.withOpacity(.2)),
        color: backgroundGrey,
        boxShadow: [
          BoxShadow(
              blurRadius: 4, offset: Offset(0, 3), color: Color(0x10000000)),
        ],
      ),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // print('searchFocus: ${searchFocus.hasFocus}');
            if (!searching) {
              searchFocus.requestFocus();
            } else {
              searchFocus.unfocus();
            }
            setState(() => searching = !searching);
          },
          borderRadius: BorderRadius.all(Radius.circular(17)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: searching ? wXD(65, context) : 0,
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOutQuart,
                  width: searching ? wXD(200, context) : 0,
                  alignment: Alignment.center,
                  child: TextField(
                    onChanged: widget.onChanged,
                    focusNode: searchFocus,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Buscar mensagens',
                      hintStyle: textFamily(
                        fontSize: 14,
                        color: Color(0xff8F9AA2).withOpacity(.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: wXD(65, context),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: searching ? wXD(35, context) : 0),
                    child: Icon(
                      Icons.search,
                      size: wXD(26, context),
                      color: Color(0xff8f9aa2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
