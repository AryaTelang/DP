class Card {
  String? cardReferenceNumber;
  String? maskedCardNumber;
  String? cardSchemeId;
  String? cardCategoryId;
  String? loadAmount;
  String? redeemedAmount;
  String? balance;
  int? kycStatus;
  String? issuedOn;
  String? expiryDate;
  String? activatedOn;
  String? customerName;
  String? customerMobile;
  String? customerEmail;
  String? reloadType;
  String? cardType;
  String? cardLink;
  String? userTag;
  String? orderId;

  Card(
      {this.cardReferenceNumber,
      this.maskedCardNumber,
      this.cardSchemeId,
      this.cardCategoryId,
      this.loadAmount,
      this.kycStatus,
      this.redeemedAmount,
      this.balance,
      this.issuedOn,
      this.expiryDate,
      this.activatedOn,
      this.customerName,
      this.cardLink,
      this.customerMobile,
      this.customerEmail,
      this.reloadType,
      this.cardType,
      this.userTag,
      this.orderId});

  Card.fromJson(Map<String, dynamic> json) {
    cardReferenceNumber = json['cardReferenceNumber'];
    maskedCardNumber = json['maskedCardNumber'];
    cardSchemeId = json['cardSchemeId'];
    cardCategoryId = json['cardCategoryId'];
    kycStatus = json['kycStatus'];
    loadAmount = json['loadAmount'].toString();
    redeemedAmount = json['redeemedAmount'].toString();
    cardLink = json['cardLink'];
    balance = json['balance'].toString();
    issuedOn = json['issuedOn'];
    expiryDate = json['expiryDate'];
    activatedOn = json['activatedOn'];
    customerName = json['customerName'];
    customerMobile = json['customerMobile'];
    customerEmail = json['customerEmail'];
    reloadType = json['reloadType'];
    cardType = json['cardType'];
    userTag = json['userTag'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cardReferenceNumber'] = cardReferenceNumber;
    data['maskedCardNumber'] = maskedCardNumber;
    data['cardSchemeId'] = cardSchemeId;
    data['cardCategoryId'] = cardCategoryId;
    data['loadAmount'] = loadAmount;
    data['redeemedAmount'] = redeemedAmount;
    data['balance'] = balance;
    data['issuedOn'] = issuedOn;
    data['expiryDate'] = expiryDate;
    data['activatedOn'] = activatedOn;
    data['customerName'] = customerName;
    data['customerMobile'] = customerMobile;
    data['customerEmail'] = customerEmail;
    data['reloadType'] = reloadType;
    data['cardType'] = cardType;
    data['userTag'] = userTag;
    data['orderId'] = orderId;
    return data;
  }
}
