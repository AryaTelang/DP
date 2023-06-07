class Transaction {
  String? transactionDate;
  String? transactionAmount;
  String? transactionType;
  String? merchantName;

  Transaction(
      {this.transactionDate,
      this.transactionAmount,
      this.transactionType,
      this.merchantName});

  Transaction.fromJson(Map<String, dynamic> json) {
    transactionDate = json['transactionDate'];
    transactionAmount = (json['transactionAmount'] / 100).toString();
    transactionType = json['transactionType'].toString();
    merchantName = json['merchantName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transactionDate'] = transactionDate;
    data['transactionAmount'] = transactionAmount;
    data['transactionType'] = transactionType;
    return data;
  }
}
