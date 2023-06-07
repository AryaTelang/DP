class ReloadOrder {
  String? paymentStatus;
  String? createdAt;
  String? referenceNumber;
  int? reloadOrderId;
  int? cardNetwork;
  String? cardCategoryId;
  int? cardIdentifier;
  List<CardDetailList>? cardDetailList;
  String? checksum;
  String? orderDescription;
  String? externalOrderId;
  String? orderStatus;
  int? successCount;
  int? failedCount;
  String? cardDetailResponseList;
  String? orderAmount;
  int? netOrderAmount;

  ReloadOrder(
      {this.paymentStatus,
      this.createdAt,
      this.referenceNumber,
      this.reloadOrderId,
      this.cardNetwork,
      this.cardCategoryId,
      this.cardIdentifier,
      this.cardDetailList,
      this.checksum,
      this.orderDescription,
      this.externalOrderId,
      this.orderStatus,
      this.successCount,
      this.failedCount,
      this.cardDetailResponseList,
      this.orderAmount,
      this.netOrderAmount});

  ReloadOrder.fromJson(Map<String, dynamic> json) {
    paymentStatus = json['paymentStatus'];
    createdAt = json['createdAt'];
    referenceNumber = json['referenceNumber'];
    reloadOrderId = json['reloadOrderId'];
    cardNetwork = json['cardNetwork'];
    cardCategoryId = json['cardCategoryId'];
    cardIdentifier = json['cardIdentifier'];
    if (json['cardDetailList'] != null) {
      cardDetailList = <CardDetailList>[];
      json['cardDetailList'].forEach((v) {
        cardDetailList!.add(CardDetailList.fromJson(v));
      });
    }
    checksum = json['checksum'];
    orderDescription = json['orderDescription'];
    externalOrderId = json['externalOrderId'];
    orderStatus = json['orderStatus'];
    successCount = json['successCount'];
    failedCount = json['failedCount'];
    cardDetailResponseList = json['cardDetailResponseList'];
    orderAmount =
        json['orderAmount'] != null ? json['orderAmount'].toString() : '';
    netOrderAmount = json['netOrderAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentStatus'] = paymentStatus;
    data['createdAt'] = createdAt;
    data['referenceNumber'] = referenceNumber;
    data['reloadOrderId'] = reloadOrderId;
    data['cardNetwork'] = cardNetwork;
    data['cardCategoryId'] = cardCategoryId;
    data['cardIdentifier'] = cardIdentifier;
    if (cardDetailList != null) {
      data['cardDetailList'] = cardDetailList!.map((v) => v.toJson()).toList();
    }
    data['checksum'] = checksum;
    data['orderDescription'] = orderDescription;
    data['externalOrderId'] = externalOrderId;
    data['orderStatus'] = orderStatus;
    data['successCount'] = successCount;
    data['failedCount'] = failedCount;
    data['cardDetailResponseList'] = cardDetailResponseList;
    data['orderAmount'] = orderAmount;
    data['netOrderAmount'] = netOrderAmount;
    return data;
  }
}

class CardDetailList {
  String? amount;
  String? referenceNumber;

  CardDetailList({this.amount, this.referenceNumber});

  CardDetailList.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    referenceNumber = json['referenceNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['referenceNumber'] = referenceNumber;
    return data;
  }
}
