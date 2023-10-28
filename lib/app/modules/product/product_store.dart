import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:mobx/mobx.dart';

part 'product_store.g.dart';

class ProductStore = _ProductStoreBase with _$ProductStore;

abstract class _ProductStoreBase with Store {
  @observable
  int imageIndex = 1;
  @observable
  ObservableList<DocumentSnapshot> ratings =
      <DocumentSnapshot>[].asObservable();

  @action
  void setImageIndex(_imageIndex) => imageIndex = _imageIndex;

  @action 
  Future<Map<String, dynamic>> getAverageRating(String adsId) async {
    QuerySnapshot ratingsQuery = await FirebaseFirestore.instance.collection('ads')
      .doc(adsId)
      .collection('ratings')
      .where("status", isEqualTo: "VISIBLE")
      .get();
      
    num averageRating = 0;
    num lengthRating = ratingsQuery.docs.length;

    for (var ratingDoc in ratingsQuery.docs) {
      averageRating += ratingDoc['rating'];    
    }

    averageRating = averageRating / lengthRating;
     
    return {
      "length-rating": lengthRating,
      "average-rating": averageRating,
    };
  }

  void getRatings(int ratingView, List<DocumentSnapshot> ratingDocs) {
    print("ratingView: $ratingView ratingDocs: $ratingDocs");
    if (ratingView == 0) {
      ratings = ratingDocs.asObservable();
    } else {
      List<DocumentSnapshot> opnionsDocs = [];
      for (DocumentSnapshot ratingDoc in ratingDocs) {
        print("product_ratings: ${ratingDoc["rating"]} ");
        if (ratingView == 1 && ratingDoc["rating"] >= 3) {
          opnionsDocs.add(ratingDoc);
        } else if (ratingView == 2 && ratingDoc["rating"] < 3) {
          opnionsDocs.add(ratingDoc);
        }
      }
      ratings = opnionsDocs.asObservable();
    }
    print("ratings: $ratings");
  }

  @action
  Future<void> share() async {
    await FlutterShare.share(
      title: 'Se liga!!',
      text: 'Se liga nesse aplicativo Mercado Expresso',
      linkUrl: 'https://delivery-dev-319ba.web.app/',
      chooserTitle: 'Compartilhar usando'
    );
  }
}
