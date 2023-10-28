import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivery_seller/app/core/models/address_model.dart';
import 'package:delivery_seller/app/core/models/customer_model.dart';
import 'package:delivery_seller/app/core/models/directions_model.dart';
import 'package:delivery_seller/app/core/models/order_model.dart';
import 'package:delivery_seller/app/core/models/seller_model.dart';
import 'package:delivery_seller/app/core/models/time_model.dart';
import 'package:delivery_seller/app/core/services/directions/directions_repository.dart';
import 'package:delivery_seller/app/shared/utilities.dart';
import 'package:delivery_seller/app/shared/widgets/load_circular_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobx/mobx.dart';

import '../../core/models/agent_model.dart';
part 'orders_store.g.dart';

class OrdersStore = _OrdersStoreBase with _$OrdersStore;

abstract class _OrdersStoreBase with Store {
  @observable
  String? deliveryForecast;
  // @observable
  // ObservableList viewableOrderStatus = <String>[].asObservable();
  @observable
  Order orderSelected = Order();
  @observable
  GoogleMapController? googleMapController;
  @observable
  Order? order;
  @observable
  Seller? seller;
  @observable
  Customer? customer;
  @observable
  Agent? agent;
  @observable
  Marker? origin;
  @observable
  Marker? destination;
  @observable
  Address? destinationAddress;
  @observable
  Directions? info;
  @observable
  // ignore: cancel_subscriptions
  StreamSubscription<DocumentSnapshot>? orderSubs;
  @observable
  // ignore: cancel_subscriptions
  StreamSubscription<DocumentSnapshot>? agentSubs;
  @observable
  ObservableList steps = [].asObservable();

  @action
  Future<void> addOrderListener(orderId, context) async {
    print('addOrderListener');
    Stream<DocumentSnapshot> orderSnap = FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .snapshots();

    orderSubs = orderSnap.listen((_orderDoc) async {
      print("_orderDoc: ${_orderDoc.get("status")}");
      getShippingDetails(_orderDoc, context);
      deliveryForecast = await getDeliveryForecast(_orderDoc);
    });
  }

  @action
  Future getShippingDetails(DocumentSnapshot orderDoc, context) async {
    print("getShippingDetails");

    order = Order.fromDoc(orderDoc);

    print("order!.status: ${order!.status}");

    steps = [
      {
        'title': 'Aguardando confirmação',
        'sub_title': 'Aguarde a confirmação da loja',
      },
      {
        'title': 'Em preparação',
        'sub_title': 'O vendedor está preparando o seu pacote.',
      },
      {
        'title': 'A caminho',
        'sub_title': 'Seu pacote está a caminho',
      },
      {
        'title': 'Entregue',
        'sub_title': 'O seu pedido foi entregue',
      },
      // 'sub_title': 'Seu pedido foi entregue às 13:00 PM',
    ].asObservable();

    if (order!.status == "REFUSED") {
      steps[0]["title"] = "Pedido recusado";
      steps[0]["sub_title"] = "O vendedor recusou o seu pedido";
    }

    if (order!.status! == "CANCELED") {
      steps[1]["title"] = "Pedido cancelado";
      steps[1]["sub_title"] = "O seu pedido foi cancelado";
    }

    if (order!.status! == "DELIVERY_REFUSED") {
      steps[1]["title"] = "Envio recusado";
      steps[1]["sub_title"] = "O emissário recusou a entrega";
    }

    if (order!.status! == "DELIVERY_CANCELED") {
      steps[2]["title"] = "Envio cancelado";
      steps[2]["sub_title"] = "O emissário cancelou a entrega";
    }

    if (order!.status! == "CONCLUDED") {
      String _hour = Time(order!.endDate!.toDate()).hour();
      String _period = "PM";
      if (int.parse(_hour.substring(0, 2)) <= 12) {
        _period = "AM";
      }
      steps[3]["sub_title"] = "Seu pedido foi entregue às $_hour $_period";
    }

    print('order!.sellerId: ${order!.sellerId}');
    DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
        .collection("sellers")
        .doc(order!.sellerId)
        .get();
    print('sellerDoc id ${sellerDoc.id}');

    seller = Seller.fromDoc(sellerDoc);

    print('order!.sellerId: ${order!.customerId}');
    DocumentSnapshot customerDoc = await FirebaseFirestore.instance
        .collection("customers")
        .doc(order!.customerId)
        .get();
    print('customerDoc id ${customerDoc.id}');

    customer = Customer.fromDoc(customerDoc);

    if (order!.status == "DELIVERY_ACCEPTED") {
      destinationAddress = Address.fromDoc(await FirebaseFirestore.instance
          .collection("sellers")
          .doc(order!.sellerId)
          .collection("addresses")
          .doc(order!.sellerAdderessId)
          .get());
    } else {
      print('else: ${order!.customerAdderessId}');
      destinationAddress = Address.fromDoc(await FirebaseFirestore.instance
          .collection("customers")
          .doc(order!.customerId)
          .collection("addresses")
          .doc(order!.customerAdderessId)
          .get());
      // print('destinationAddress: ${destinationAddress!.toJson()}');
    }

    print(
        'destinationAddress!.latitude! ${destinationAddress!.latitude!} - destinationAddress!.longitude! ${destinationAddress!.longitude!}');

    destination = Marker(
      markerId: MarkerId("destination"),
      infoWindow: InfoWindow(title: "destination"),
      icon: await bitmapDescriptorFromSvgAsset(
          context, "./assets/svg/location.svg"),
      position:
          LatLng(destinationAddress!.latitude!, destinationAddress!.longitude!),
    );

    print('order!.agentId ${order!.agentId}');
    if (order!.agentId != null && order!.status != "CONCLUDED") {
      print('if');
      Stream<DocumentSnapshot> agentStream = FirebaseFirestore.instance
          .collection("agents")
          .doc(order!.agentId)
          .snapshots();

      agentSubs = agentStream.listen((_agentDoc) async {
        agent = Agent.fromDoc(_agentDoc);

        info = await DirectionRepository().getDirections(
          origin: LatLng(
              agent!.position!["latitude"], agent!.position!["longitude"]),
          destination: destination!.position,
        );

        origin = Marker(
          markerId: MarkerId("origin"),
          infoWindow: InfoWindow(title: "origin"),
          icon: await bitmapDescriptorFromSvgAsset(
              context, "./assets/svg/location.svg"),
          position: LatLng(
            agent!.position!["latitude"],
            agent!.position!["longitude"],
          ),
        );
        if (googleMapController != null)
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            googleMapController!.animateCamera(
                CameraUpdate.newLatLngBounds(info!.bounds, wXD(10, context)));
          });
      });
    } else {
      origin = null;
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        if (googleMapController != null)
          googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: destination!.position, zoom: 14)));
      });
    }
  }

  @action
  Future<String> getDeliveryForecast(_orderDoc) async {
    String? deliveryForecast;

    Order _order = Order.fromDoc(_orderDoc);

    Position _currentPosition = await determinePosition();

    Address _storeAddress;

    Directions? _storeDirection;

    Address _customerAddress = Address.fromDoc(await FirebaseFirestore.instance
        .collection("customers")
        .doc(_order.customerId)
        .collection("addresses")
        .doc(_order.customerAdderessId)
        .get());

    Directions? _customerDirection;

    if (_order.status == "DELIVERY_ACCEPTED") {
      _storeAddress = Address.fromDoc(await FirebaseFirestore.instance
          .collection("sellers")
          .doc(_order.sellerId)
          .collection("addresses")
          .doc(_order.sellerAdderessId)
          .get());

      _storeDirection = await DirectionRepository().getDirections(
        origin: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        destination: LatLng(_storeAddress.latitude!, _storeAddress.longitude!),
      );

      _customerDirection = await DirectionRepository().getDirections(
        origin: LatLng(_storeAddress.latitude!, _storeAddress.longitude!),
        destination:
            LatLng(_customerAddress.latitude!, _customerAddress.longitude!),
      );

      String getDeliveryAcceptedText() {
        if (_storeDirection != null && _customerDirection != null) {
          print("Now: ${DateTime.now()}");
          print(
              "_storeDirection.durationValue: ${_storeDirection.durationValue}");
          print(
              "_customerDirection.durationValue: ${_customerDirection.durationValue}");
          DateTime _deliveryForecast = DateTime.now().add(Duration(
              seconds: _storeDirection.durationValue +
                  _customerDirection.durationValue +
                  600));
          print("_deliveryForecast: $_deliveryForecast");

          String period = " PM";
          if (_deliveryForecast.hour < 12) {
            period = " AM";
          }
          return Time(_deliveryForecast).hour() + period;
        } else {
          return "Sem previsão";
        }
      }

      return getDeliveryAcceptedText();
    } else if (_order.status == "SENDED") {
      _customerDirection = await DirectionRepository().getDirections(
        origin: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        destination:
            LatLng(_customerAddress.latitude!, _customerAddress.longitude!),
      );
      String getDeliverySendText() {
        if (_customerDirection != null) {
          print("Now: ${DateTime.now()}");
          print(
              "_customerDirection.durationValue: ${_customerDirection.durationValue}");
          DateTime _deliveryForecast = DateTime.now()
              .add(Duration(seconds: _customerDirection.durationValue));
          print("DeliveryForecast: $_deliveryForecast");
          String period = " PM";
          if (_deliveryForecast.hour < 12) {
            period = " AM";
          }
          return Time(_deliveryForecast).hour() + period;
        } else {
          return "Sem previsão";
        }
      }

      return getDeliverySendText();
    } else {
      return deliveryForecast ?? "- - -";
    }
  }

  @action
  void clearShippingDetails() {
    if (googleMapController != null) googleMapController!.dispose();
    if (agentSubs != null) agentSubs!.cancel();
    if (orderSubs != null) orderSubs!.cancel();
    order = null;
    seller = null;
    customer = null;
    agent = null;
    origin = null;
    destination = null;
    destinationAddress = null;
    info = null;
    deliveryForecast = null;
  }

  // @action
  // setOrderStatusView(ObservableList _viewableOrderStatus) =>
  //     viewableOrderStatus = _viewableOrderStatus;

  @action
  setOrderSelected(Order _order) => orderSelected = _order;

  @action
  Future changeOrderStatus(
      Order model, String status, String token, context) async {
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());

    Overlay.of(context)!.insert(loadOverlay);

    String function = "";

    Map<String, dynamic> object = {
      "id": model.id,
      "seller_id": model.sellerId,
      "customer_id": model.customerId,
    };

    print("status: $status - orderId: ${model.id}");

    switch (status) {
      case "PROCESSING":
        function = "acceptOrder";
        break;
      case "REFUSED":
        function = "refuseOrder";
        break;
      case "DELIVERY_REQUESTED":
        print('case DELIVERY_REQUESTED: ${model.id}');
        function = "requestDelivery";
        object = {"orderId": model.id};
        break;
      case "SENDED":
        function = "sendOrder";
        object = {
          "order": {
            "order_id": model.id,
            "seller_id": model.sellerId,
            "customer_id": model.customerId,
            "agent_id": model.agentId,
          },
          "token": token,
        };
        print("object: $object");
        break;
      case "CANCELED":
        function = "cancelOrder";
        print("agentId: ${model.agentId}");
        object = {
          "order": {
            "order_id": model.id,
            "seller_id": model.sellerId,
            "customer_id": model.customerId,
          },
          "userId": model.sellerId,
          "userCollection": "sellers"
        };
        break;
      default:
        print("sem caso para o status: $status");
    }

    print("function: $function, Object: $object");
    if (function == '') {
      showToast("Erro ao alterar status");
      loadOverlay.remove();
      return false;
    }

    print('function: $function');
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(function);

    HttpsCallableResult callableResult = await callable.call(object);
    print("result != null: ${callableResult.data}");

    var response = callableResult.data;

    if (response['status'] != "success") {
      showToast(response['message']);
    }

    loadOverlay.remove();
  }
}
