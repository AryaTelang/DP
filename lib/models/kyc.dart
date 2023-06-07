class Kyc {
  String? idFieldName;
  String? createdAt;
  String? updatedAt;
  String? id;
  int? userId;
  String? phNumber;
  String? name;
  String? orderId;
  String? kycType;
  String? kycCompleted;
  bool? paid;
  String? link;
  String? alreadyDone;
  String? expiry;

  Kyc(
      {this.idFieldName,
      this.createdAt,
      this.updatedAt,
      this.id,
      this.userId,
      this.phNumber,
      this.alreadyDone,
      this.name,
      this.orderId,
      this.kycType,
      this.kycCompleted,
      this.paid,
      this.link,
      this.expiry});

  Kyc.fromJson(Map<String, dynamic> json) {
    idFieldName = json['idFieldName'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    userId = json['userId'];
    alreadyDone = json['alreadyDone'];
    phNumber = json['phNumber'];
    name = json['name'];
    orderId = json['orderId'];
    kycType = json['kycType'];
    kycCompleted = json['kycCompleted'];
    paid = json['paid'];
    link = json['link'];
    expiry = json['expiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idFieldName'] = idFieldName;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['id'] = id;
    data['userId'] = userId;
    data['phNumber'] = phNumber;
    data['name'] = name;
    data['orderId'] = orderId;
    data['kycType'] = kycType;
    data['kycCompleted'] = kycCompleted;
    data['paid'] = paid;
    data['link'] = link;
    data['expiry'] = expiry;
    return data;
  }
}
