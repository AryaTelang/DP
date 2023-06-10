import 'dart:io';

import 'package:bachat_cards/controllers/home_screen_controller.dart';
import 'package:bachat_cards/screens/orders_screens/orders_screen.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/constants.dart';
import '../../sevrices/shared_prefs.dart';
import '../card_screens/web_view.dart';
import '../temporary_paytm.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen(
      {super.key, required this.orderId, this.type, this.kycType, this.name});

  final String orderId;
  final CardType? type;
  final KYCType? kycType;
  final String? name;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late TapGestureRecognizer _tapRecognizer;
  var isLoading = false.obs;
  Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  Future<void> initiateKyc() async {
    isLoading.value = true;
    try {
      final response = await dio
          .post('${Constants.url}/mbc/v1/card/initiateKyc', data: {
        'phoneNumber': SharedPrefs.getPhoneNumber().substring(3),
        'name': widget.name
      });
      if (response.data['alreadyDone'] != null) {
        Get.snackbar('Info',
            "The ${response.data['alreadyDone']} KYC for this mobile number has already been done");
      }
      if (response.data['link'] != null) {
        _launchUrl(response.data['link']);
      } else if (response.data['orderId'] != null) {
        Get.to(() => TempPaytm(
            orderId: response.data['orderId'], amount: "24", type: "kyc"));
      }
    } on DioError catch (e) {
      debugPrint(e.response.toString());
    }
    isLoading.value = false;
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not launch external browser');
    }
  }

  Future<void> initiateMinKYC() async {
    isLoading.value = true;
    try {
      final response = await dio
          .post('${Constants.url}/mbc/v1/card/initiateMinKyc', data: {
        'phoneNumber': SharedPrefs.getPhoneNumber().substring(3),
        'name': widget.name
      });
      if (response.data['alreadyDone'] != null) {
        Get.snackbar('Info',
            "The ${response.data['alreadyDone']} KYC for this mobile number has already been done");
      }
      if (response.data['link'] != null) {
        _launchUrl(response.data['link']);
      } else if (response.data['orderId'] != null) {
        Get.to(() => TempPaytm(
            orderId: response.data['result']['orderId'],
            amount: "7",
            type: "kyc"));
      }
    } on DioError catch (e) {
      debugPrint(e.response.toString());
    }
    isLoading.value = false;
  }

  @override
  void initState() {
    _tapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Get.off(() => const OrdersScreen());
      };
    if (widget.kycType != null) {
      Get.find<HomeScreenController>().getKycStatus(dio);
    }
    super.initState();
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height,width,size;
    size=MediaQuery.of(context).size;
    height=size.height;
    width=size.width;
    return Scaffold(
      appBar: Platform.isIOS ? AppBar() : null,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SizedBox(height: 40,),
            Image.asset('assets/images/greentick.png',height: 100,),
            SizedBox(height: 20,),
            Text("Success",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700),),
            Text("Order placed",style: TextStyle(color: Colors.grey,fontSize: 14),),

            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 20,),
                Text("Payment Status",
                  style: poppinsSemiBold24.copyWith(color:grey,fontSize: 16),),
                SizedBox(width: width*0.35,),
                Text("Success",style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xffff6b6b)),),
              ],
            ),
            SizedBox(height: 10,),

            Row(
              children: [
                SizedBox(width: 20,),
                Text("Reciever Email",
                  style: poppinsSemiBold24.copyWith(color:grey,fontSize: 16),),
                SizedBox(width: width*0.3,),
                Text("Reciever Email",style: TextStyle(fontWeight: FontWeight.w700),),
              ],
            ),
            SizedBox(height: 10,),

            Row(

              children:
              [
                SizedBox(width: 20,),
                Text("Date",
                  style: poppinsSemiBold24.copyWith(color:grey,fontSize: 16),),
                SizedBox(width: width*0.6,),
                Align(alignment:AlignmentDirectional.bottomEnd,child: Text("Date",style: TextStyle(fontWeight: FontWeight.w700),)),
              ],
            ),
            SizedBox(height: 10,),

            Row(
              children: [
                SizedBox(width: 20,),
                Text("Amount",
                  style: poppinsSemiBold24.copyWith(color:grey,fontSize: 16),),
                SizedBox(width: width*0.55,),
                Text("Rs.7",style: TextStyle(fontWeight: FontWeight.w700),),
              ],
            ),



            SizedBox(height: 10,),

            if (widget.type != CardType.multiReload)
              Row(
                children: [

                  SizedBox(width: 20,),
                  Text("Order ID",
                    style: poppinsSemiBold24.copyWith(color:grey,fontSize: 16),),
                  SizedBox(width: width*0.36,),
                  Text(widget.orderId,style: TextStyle(fontWeight: FontWeight.w700),),
                ],
              ),
            SizedBox(height: height/3,),
            SizedBox(
              width: width*0.9,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(

                    backgroundColor: primaryColor,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                child: const Text(
                  'Order Status',
                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                ),
                onPressed: () {},
              ),
            ),
          ]),
        ),
      )),
    );
  }

  _spacer16() {
    return const SizedBox(
      height: 16,
    );
  }
}
