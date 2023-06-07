class CardOrder {
  String? paymentStatus;
  String? createdAt;
  String? referenceNumber;
  int? orderId;
  String? externalOrderId;
  String? orderAmount;
  int? quantity;
  String? orderStatus;
  int? userId;
  int? cardIdentifier;
  int? pinMode;
  String? orderResponse;
  String? cardType;
  String? reloadType;
  String? cardCategoryId;
  String? orderDescription;

  CardOrder(
      {this.paymentStatus,
      this.createdAt,
      this.referenceNumber,
      this.orderId,
      this.externalOrderId,
      this.orderAmount,
      this.quantity,
      this.orderResponse,
      this.orderStatus,
      this.userId,
      this.cardIdentifier,
      this.pinMode,
      this.cardType,
      this.reloadType,
      this.cardCategoryId,
      this.orderDescription});

  CardOrder.fromJson(Map<String, dynamic> json) {
    paymentStatus = json['paymentStatus'];
    createdAt = json['createdAt'];
    referenceNumber = json['referenceNumber'];
    orderId = json['orderId'];
    externalOrderId = json['externalOrderId'];
    orderAmount = json['orderAmount'].toString();
    quantity = json['quantity'];
    orderStatus = json['orderStatus'];
    orderResponse = json['orderResponse'];
    userId = json['userId'];
    cardIdentifier = json['cardIdentifier'];
    pinMode = json['pinMode'];
    cardType = json['cardType'];
    reloadType = json['reloadType'];
    cardCategoryId = json['cardCategoryId'];
    orderDescription = json['orderDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentStatus'] = paymentStatus;
    data['createdAt'] = createdAt;
    data['referenceNumber'] = referenceNumber;
    data['orderId'] = orderId;
    data['externalOrderId'] = externalOrderId;
    data['orderAmount'] = orderAmount;
    data['quantity'] = quantity;
    data['orderStatus'] = orderStatus;
    data['userId'] = userId;
    data['cardIdentifier'] = cardIdentifier;
    data['pinMode'] = pinMode;
    data['cardType'] = cardType;
    data['reloadType'] = reloadType;
    data['cardCategoryId'] = cardCategoryId;
    data['orderDescription'] = orderDescription;
    return data;
  }
}
