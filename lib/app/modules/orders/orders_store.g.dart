// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$OrdersStore on _OrdersStoreBase, Store {
  final _$deliveryForecastAtom =
      Atom(name: '_OrdersStoreBase.deliveryForecast');

  @override
  String? get deliveryForecast {
    _$deliveryForecastAtom.reportRead();
    return super.deliveryForecast;
  }

  @override
  set deliveryForecast(String? value) {
    _$deliveryForecastAtom.reportWrite(value, super.deliveryForecast, () {
      super.deliveryForecast = value;
    });
  }

  final _$orderSelectedAtom = Atom(name: '_OrdersStoreBase.orderSelected');

  @override
  Order get orderSelected {
    _$orderSelectedAtom.reportRead();
    return super.orderSelected;
  }

  @override
  set orderSelected(Order value) {
    _$orderSelectedAtom.reportWrite(value, super.orderSelected, () {
      super.orderSelected = value;
    });
  }

  final _$googleMapControllerAtom =
      Atom(name: '_OrdersStoreBase.googleMapController');

  @override
  GoogleMapController? get googleMapController {
    _$googleMapControllerAtom.reportRead();
    return super.googleMapController;
  }

  @override
  set googleMapController(GoogleMapController? value) {
    _$googleMapControllerAtom.reportWrite(value, super.googleMapController, () {
      super.googleMapController = value;
    });
  }

  final _$orderAtom = Atom(name: '_OrdersStoreBase.order');

  @override
  Order? get order {
    _$orderAtom.reportRead();
    return super.order;
  }

  @override
  set order(Order? value) {
    _$orderAtom.reportWrite(value, super.order, () {
      super.order = value;
    });
  }

  final _$sellerAtom = Atom(name: '_OrdersStoreBase.seller');

  @override
  Seller? get seller {
    _$sellerAtom.reportRead();
    return super.seller;
  }

  @override
  set seller(Seller? value) {
    _$sellerAtom.reportWrite(value, super.seller, () {
      super.seller = value;
    });
  }

  final _$customerAtom = Atom(name: '_OrdersStoreBase.customer');

  @override
  Customer? get customer {
    _$customerAtom.reportRead();
    return super.customer;
  }

  @override
  set customer(Customer? value) {
    _$customerAtom.reportWrite(value, super.customer, () {
      super.customer = value;
    });
  }

  final _$agentAtom = Atom(name: '_OrdersStoreBase.agent');

  @override
  Agent? get agent {
    _$agentAtom.reportRead();
    return super.agent;
  }

  @override
  set agent(Agent? value) {
    _$agentAtom.reportWrite(value, super.agent, () {
      super.agent = value;
    });
  }

  final _$originAtom = Atom(name: '_OrdersStoreBase.origin');

  @override
  Marker? get origin {
    _$originAtom.reportRead();
    return super.origin;
  }

  @override
  set origin(Marker? value) {
    _$originAtom.reportWrite(value, super.origin, () {
      super.origin = value;
    });
  }

  final _$destinationAtom = Atom(name: '_OrdersStoreBase.destination');

  @override
  Marker? get destination {
    _$destinationAtom.reportRead();
    return super.destination;
  }

  @override
  set destination(Marker? value) {
    _$destinationAtom.reportWrite(value, super.destination, () {
      super.destination = value;
    });
  }

  final _$destinationAddressAtom =
      Atom(name: '_OrdersStoreBase.destinationAddress');

  @override
  Address? get destinationAddress {
    _$destinationAddressAtom.reportRead();
    return super.destinationAddress;
  }

  @override
  set destinationAddress(Address? value) {
    _$destinationAddressAtom.reportWrite(value, super.destinationAddress, () {
      super.destinationAddress = value;
    });
  }

  final _$infoAtom = Atom(name: '_OrdersStoreBase.info');

  @override
  Directions? get info {
    _$infoAtom.reportRead();
    return super.info;
  }

  @override
  set info(Directions? value) {
    _$infoAtom.reportWrite(value, super.info, () {
      super.info = value;
    });
  }

  final _$orderSubsAtom = Atom(name: '_OrdersStoreBase.orderSubs');

  @override
  StreamSubscription<DocumentSnapshot<Object?>>? get orderSubs {
    _$orderSubsAtom.reportRead();
    return super.orderSubs;
  }

  @override
  set orderSubs(StreamSubscription<DocumentSnapshot<Object?>>? value) {
    _$orderSubsAtom.reportWrite(value, super.orderSubs, () {
      super.orderSubs = value;
    });
  }

  final _$agentSubsAtom = Atom(name: '_OrdersStoreBase.agentSubs');

  @override
  StreamSubscription<DocumentSnapshot<Object?>>? get agentSubs {
    _$agentSubsAtom.reportRead();
    return super.agentSubs;
  }

  @override
  set agentSubs(StreamSubscription<DocumentSnapshot<Object?>>? value) {
    _$agentSubsAtom.reportWrite(value, super.agentSubs, () {
      super.agentSubs = value;
    });
  }

  final _$stepsAtom = Atom(name: '_OrdersStoreBase.steps');

  @override
  ObservableList<dynamic> get steps {
    _$stepsAtom.reportRead();
    return super.steps;
  }

  @override
  set steps(ObservableList<dynamic> value) {
    _$stepsAtom.reportWrite(value, super.steps, () {
      super.steps = value;
    });
  }

  final _$addOrderListenerAsyncAction =
      AsyncAction('_OrdersStoreBase.addOrderListener');

  @override
  Future<void> addOrderListener(dynamic orderId, dynamic context) {
    return _$addOrderListenerAsyncAction
        .run(() => super.addOrderListener(orderId, context));
  }

  final _$getShippingDetailsAsyncAction =
      AsyncAction('_OrdersStoreBase.getShippingDetails');

  @override
  Future<dynamic> getShippingDetails(
      DocumentSnapshot<Object?> orderDoc, dynamic context) {
    return _$getShippingDetailsAsyncAction
        .run(() => super.getShippingDetails(orderDoc, context));
  }

  final _$getDeliveryForecastAsyncAction =
      AsyncAction('_OrdersStoreBase.getDeliveryForecast');

  @override
  Future<String> getDeliveryForecast(dynamic _orderDoc) {
    return _$getDeliveryForecastAsyncAction
        .run(() => super.getDeliveryForecast(_orderDoc));
  }

  final _$changeOrderStatusAsyncAction =
      AsyncAction('_OrdersStoreBase.changeOrderStatus');

  @override
  Future<dynamic> changeOrderStatus(
      Order model, String status, String token, dynamic context) {
    return _$changeOrderStatusAsyncAction
        .run(() => super.changeOrderStatus(model, status, token, context));
  }

  final _$_OrdersStoreBaseActionController =
      ActionController(name: '_OrdersStoreBase');

  @override
  void clearShippingDetails() {
    final _$actionInfo = _$_OrdersStoreBaseActionController.startAction(
        name: '_OrdersStoreBase.clearShippingDetails');
    try {
      return super.clearShippingDetails();
    } finally {
      _$_OrdersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setOrderSelected(Order _order) {
    final _$actionInfo = _$_OrdersStoreBaseActionController.startAction(
        name: '_OrdersStoreBase.setOrderSelected');
    try {
      return super.setOrderSelected(_order);
    } finally {
      _$_OrdersStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
deliveryForecast: ${deliveryForecast},
orderSelected: ${orderSelected},
googleMapController: ${googleMapController},
order: ${order},
seller: ${seller},
customer: ${customer},
agent: ${agent},
origin: ${origin},
destination: ${destination},
destinationAddress: ${destinationAddress},
info: ${info},
orderSubs: ${orderSubs},
agentSubs: ${agentSubs},
steps: ${steps}
    ''';
  }
}
