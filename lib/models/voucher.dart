class Voucher {
  String? createdAt;
  String? redemptionId;
  String? brandId;
  String? denomination;
  int? amount;
  String? status;
  String? rewardManagementOrderId;
  Vouchers? vouchers;
  Brand? brand;

  Voucher(
      {this.redemptionId,
      this.createdAt,
      this.brandId,
      this.denomination,
      this.amount,
      this.status,
      this.rewardManagementOrderId,
      this.vouchers,
      this.brand});

  Voucher.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    redemptionId = json['redemptionId'];
    brandId = json['brandId'];
    denomination = json['denomination'];
    amount = json['amount'];
    status = json['status'];
    rewardManagementOrderId = json['rewardManagementOrderId'];
    vouchers =
        json['vouchers'] != null ? Vouchers.fromJson(json['vouchers']) : null;
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['redemptionId'] = redemptionId;
    data['brandId'] = brandId;
    data['denomination'] = denomination;
    data['amount'] = amount;
    data['status'] = status;
    data['rewardManagementOrderId'] = rewardManagementOrderId;
    if (vouchers != null) {
      data['vouchers'] = vouchers!.toJson();
    }
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    return data;
  }
}

class Vouchers {
  String? denomination;
  String? cardNumber;
  String? cardPin;
  String? activationCode;
  String? validity;
  String? brandId;
  String? refId;
  String? purchasedDate;

  Vouchers(
      {this.denomination,
      this.cardNumber,
      this.cardPin,
      this.activationCode,
      this.validity,
      this.brandId,
      this.refId,
      this.purchasedDate});

  Vouchers.fromJson(Map<String, dynamic> json) {
    denomination = json['denomination'];
    cardNumber = json['cardNumber'];
    cardPin = json['cardPin'];
    activationCode = json['activationCode'];
    validity = json['validity'];
    brandId = json['brandId'];
    refId = json['refId'];
    purchasedDate = json['purchasedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['denomination'] = denomination;
    data['cardNumber'] = cardNumber;
    data['cardPin'] = cardPin;
    data['activationCode'] = activationCode;
    data['validity'] = validity;
    data['brandId'] = brandId;
    data['refId'] = refId;
    data['purchasedDate'] = purchasedDate;
    return data;
  }
}

class Brand {
  String? brandLogo;
  String? brandName;
  String? brandUrlName;
  String? name;

  Brand({this.brandLogo, this.brandName, this.brandUrlName, this.name});

  Brand.fromJson(Map<String, dynamic> json) {
    brandLogo = json['brandLogo'];
    brandName = json['brandName'];
    brandUrlName = json['brandUrlName'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brandLogo'] = brandLogo;
    data['brandName'] = brandName;
    data['brandUrlName'] = brandUrlName;
    data['name'] = name;
    return data;
  }
}
