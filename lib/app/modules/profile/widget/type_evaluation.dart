import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_seller/app/shared/color_theme.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TypeEvaluation extends StatelessWidget {
  final String title;
  final String opinion;
  final String text;
  final String? adsId;
  final num rating;
  final void Function(String) onChanged;

  TypeEvaluation({
    required this.title,
    required this.opinion,
    required this.text,
    required this.rating,
    required this.onChanged,
    this.adsId,
  });

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('text.isNotEmpty: ${text.isNotEmpty}');
    if (text.isNotEmpty) {
      textEditingController.text = text;
    }
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
            wXD(16, context),
            wXD(12, context),
            wXD(16, context),
            wXD(21, context),
          ),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: darkGrey.withOpacity(.2)))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingBar(
                initialRating: rating.toDouble(),
                onRatingUpdate: (value) {},
                ignoreGestures: true,
                glowColor: primary.withOpacity(.4),
                unratedColor: primary.withOpacity(.4),
                allowHalfRating: true,
                itemSize: wXD(35, context),
                ratingWidget: RatingWidget(
                  full: Icon(Icons.star_rounded, color: primary),
                  empty: Icon(Icons.star_outline_rounded, color: primary),
                  half: Icon(Icons.star_half_rounded, color: primary),
                ),
              ),
              SizedBox(height: wXD(15, context)),
              Text(
                title,
                style: textFamily(
                  color: totalBlack,
                  fontSize: 14,
                ),
              ),
              Container(
                // height: wXD(52, context),
                width: wXD(343, context),
                decoration: BoxDecoration(
                    border: Border.all(color: primary.withOpacity(.65)),
                    borderRadius: BorderRadius.all(Radius.circular(11))),
                margin: EdgeInsets.only(top: wXD(16, context)),
                padding: EdgeInsets.symmetric(
                    horizontal: wXD(11, context), vertical: wXD(10, context)),
                alignment: Alignment.topLeft,
                child: Text(
                  opinion == "" ? "Sem opinião" : opinion,
                  style: textFamily(
                      color: opinion == ""
                          ? textTotalBlack.withOpacity(.3)
                          : textTotalBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
              SizedBox(height: wXD(20, context)),
              Row(
                children: [
                  Text(
                    'Responder',
                    style: textFamily(
                      color: totalBlack,
                      fontSize: 14,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${text.length}/300',
                    style: textFamily(
                      color: darkGrey.withOpacity(.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                // height: wXD(52, context),
                width: wXD(343, context),
                decoration: BoxDecoration(
                    border: Border.all(color: primary.withOpacity(.65)),
                    borderRadius: BorderRadius.all(Radius.circular(11))),
                margin: EdgeInsets.only(top: wXD(16, context)),
                padding: EdgeInsets.symmetric(
                    horizontal: wXD(10, context), vertical: wXD(13, context)),
                alignment: Alignment.topLeft,
                child: TextFormField(
                  // controller: textEditingController,
                  initialValue: text,
                  validator: (val) {
                    if (val != null && val.length > 300) {
                      return "Sua resposta não pode ter mais de 300 caracteres";
                      // } else if (val == null || val == "") {
                      //   return "Sua resposta não pode ser vazia";
                    } else {
                      if (val == null || val == '') {
                        return 'Campo obrigatório';
                      }
                      return null;
                    }
                  },
                  onChanged: onChanged,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Deixe sua resposta em relação à opinião',
                    hintStyle: textFamily(
                      color: darkGrey.withOpacity(.55),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        adsId == null
            ? Container()
            : Positioned(
                right: 0,
                top: 0,
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("ads")
                      .doc(adsId)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator(
                        color: primary,
                      );
                    }
                    DocumentSnapshot adsDoc = snapshot.data!;
                    return CachedNetworkImage(
                      imageUrl: adsDoc['images'].first,
                      height: wXD(65, context),
                      width: wXD(62, context),
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, progress) =>
                          CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(primary),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
