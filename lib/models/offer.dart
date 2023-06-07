class Offer {
  String? code;
  List<String>? tags;
  OfferDetails? offerDetails;
  String? title;

  Offer({this.code, this.tags, this.offerDetails, this.title});

  Offer.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    tags = json['tags'].cast<String>();
    offerDetails = json['offer_details'] != null
        ? OfferDetails.fromJson(json['offer_details'])
        : null;
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['tags'] = tags;
    if (offerDetails != null) {
      data['offer_details'] = offerDetails!.toJson();
    }
    data['title'] = title;
    return data;
  }
}

class OfferDetails {
  String? offerCode;
  String? title;
  String? imageLink;
  String? mobileImageLink;
  String? logoImageLink;
  String? description;
  String? redemptionProcess;
  String? escalationMatrix;
  String? endDateTime;
  String? termAndCondition;
  String? longDescription;

  OfferDetails(
      {this.offerCode,
      this.title,
      this.imageLink,
      this.mobileImageLink,
      this.logoImageLink,
      this.description,
      this.redemptionProcess,
      this.escalationMatrix,
      this.endDateTime,
      this.termAndCondition,
      this.longDescription});

  OfferDetails.fromJson(Map<String, dynamic> json) {
    offerCode = json['offerCode'];
    title = json['title'];
    imageLink = json['imageLink'];
    mobileImageLink = json['mobileImageLink'];
    logoImageLink = json['logoImageLink'];
    description = json['description'];
    redemptionProcess = json['redemptionProcess'];
    escalationMatrix = json['escalationMatrix'];
    endDateTime = json['endDateTime'];
    termAndCondition = json['termAndCondition'];
    longDescription = json['longDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offerCode'] = offerCode;
    data['title'] = title;
    data['imageLink'] = imageLink;
    data['mobileImageLink'] = mobileImageLink;
    data['logoImageLink'] = logoImageLink;
    data['description'] = description;
    data['redemptionProcess'] = redemptionProcess;
    data['escalationMatrix'] = escalationMatrix;
    data['endDateTime'] = endDateTime;
    data['termAndCondition'] = termAndCondition;
    data['longDescription'] = longDescription;
    return data;
  }
}
