class Rewards {
  String? title;
  List<Brands>? brands;

  Rewards({this.title, this.brands});

  Rewards.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(Brands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (brands != null) {
      data['brands'] = brands!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brands {
  String? sId;
  String? name;
  List<String>? commonNames;
  List<Categories>? categories;
  PineImage? pineImage;
  String? gyftrImage;
  double? discountOthers;
  List<String>? brandImages;
  String? urlName;

  Brands(
      {this.sId,
      this.name,
      this.commonNames,
      this.categories,
      this.pineImage,
      this.gyftrImage,
      this.discountOthers,
      this.brandImages,
      this.urlName});

  Brands.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    commonNames =
        json['commonNames'] != null ? json['commonNames'].cast<String>() : [];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    pineImage = json['pineImage'] != null
        ? PineImage.fromJson(json['pineImage'])
        : null;
    gyftrImage = json['gyftrImage'];
    discountOthers = double.tryParse(json['discountOthers'].toString());
    brandImages =
        json['brandImages'] != null ? json['brandImages'].cast<String>() : [];
    urlName = json['urlName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['commonNames'] = commonNames;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (pineImage != null) {
      data['pineImage'] = pineImage!.toJson();
    }
    data['gyftrImage'] = gyftrImage;
    data['discountOthers'] = discountOthers;
    data['brandImages'] = brandImages;
    data['urlName'] = urlName;
    return data;
  }
}

class Categories {
  String? category;
  List<String>? subCategories;

  Categories({this.category, this.subCategories});

  Categories.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    subCategories = json['subCategories'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['subCategories'] = subCategories;
    return data;
  }
}

class PineImage {
  String? thumbnail;
  String? mobile;
  String? base;
  String? small;

  PineImage({this.thumbnail, this.mobile, this.base, this.small});

  PineImage.fromJson(Map<String, dynamic> json) {
    thumbnail = json['thumbnail'];
    mobile = json['mobile'];
    base = json['base'];
    small = json['small'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['thumbnail'] = thumbnail;
    data['mobile'] = mobile;
    data['base'] = base;
    data['small'] = small;
    return data;
  }
}
