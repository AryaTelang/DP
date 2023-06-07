class UserProfile {
  ErrorInfo? errorInfo;
  UserInfo? userInfo;

  UserProfile({this.errorInfo, this.userInfo});

  UserProfile.fromJson(Map<String, dynamic> json) {
    errorInfo = json['error_info'] != null
        ? ErrorInfo.fromJson(json['error_info'])
        : null;
    userInfo =
        json['user_info'] != null ? UserInfo.fromJson(json['user_info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (errorInfo != null) {
      data['error_info'] = errorInfo!.toJson();
    }
    if (userInfo != null) {
      data['user_info'] = userInfo!.toJson();
    }
    return data;
  }
}

class ErrorInfo {
  String? svcStatus;
  int? errorCode;
  String? errorText;

  ErrorInfo({this.svcStatus, this.errorCode, this.errorText});

  ErrorInfo.fromJson(Map<String, dynamic> json) {
    svcStatus = json['svc_status'];
    errorCode = json['error_code'];
    errorText = json['error_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['svc_status'] = svcStatus;
    data['error_code'] = errorCode;
    data['error_text'] = errorText;
    return data;
  }
}

class UserInfo {
  String? userId;
  String? mobileNo;
  String? email;
  double? rewardBalance;
  double? superCashbackBalance;
  String? userStatus;
  String? gender;
  String? firstName;
  String? lastName;

  UserInfo(
      {this.userId,
      this.mobileNo,
      this.email,
      this.rewardBalance,
      this.superCashbackBalance,
      this.userStatus,
      this.gender,
      this.firstName,
      this.lastName});

  UserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    mobileNo = json['mobile_no'];
    email = json['email'];
    rewardBalance = json['reward_balance'] != null
        ? double.parse(json['reward_balance'].toString())
        : 0.0;
    superCashbackBalance = json['super_cashback_balance'] != null
        ? double.parse(json['super_cashback_balance'].toString())
        : 0.0;
    userStatus = json['user_status'];
    gender = json['gender'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['mobile_no'] = mobileNo;
    data['email'] = email;
    data['reward_balance'] = rewardBalance;
    data['super_cashback_balance'] = superCashbackBalance;
    data['user_status'] = userStatus;
    data['gender'] = gender;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}
