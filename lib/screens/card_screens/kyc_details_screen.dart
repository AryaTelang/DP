import 'package:bachat_cards/Constants/constants.dart';
import 'package:bachat_cards/screens/card_screens/web_view.dart';
import 'package:bachat_cards/screens/temporary_paytm.dart';
import 'package:bachat_cards/sevrices/shared_prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../appbar/appbar.dart';
import '../../theme/theme.dart';

class KYCDetailsScreen extends StatefulWidget {
  const KYCDetailsScreen({super.key, required this.kycType});

  final KYCType kycType;

  @override
  State<KYCDetailsScreen> createState() => _KYCDetailsScreenState();
}

class _KYCDetailsScreenState extends State<KYCDetailsScreen> {
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  final _formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;

  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> initiateKyc() async {
    isLoading.value = true;
    try {
      final response =
          await dio.post('${Constants.url}/mbc/v1/card/initiateKyc', data: {
        'phoneNumber': SharedPrefs.getPhoneNumber().substring(3),
        'name': _nameController.text.trim()
      });
      if (response.data['link'] != null) {
        _launchUrl(response.data['link']);
      } else if (response.data['orderId'] != null) {
        Get.to(() => TempPaytm(
            kycType: KYCType.max,
            name: _nameController.text.trim(),
            orderId: response.data['orderId'],
            amount: "24",
            type: "kyc"));
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
      final response =
          await dio.post('${Constants.url}/mbc/v1/card/initiateMinKyc', data: {
        'phoneNumber': SharedPrefs.getPhoneNumber().substring(3),
        'name': _nameController.text.trim()
      });
      if (response.data['link'] != null) {
        _launchUrl(response.data['link']);
      } else if (response.data['orderId'] != null) {
        Get.to(() => TempPaytm(
            orderId: response.data['orderId'],
            amount: "7",
            name: _nameController.text.trim(),
            kycType: KYCType.min,
            type: "kyc"));
      }
    } on DioError catch (e) {
      debugPrint(e.response.toString());
    }
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(),
        title: Text(
          "KYC Details",
          style: poppinsSemiBold18.copyWith(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Name",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                keyboardType: TextInputType.name,
                autofocus: true,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter name of the cardholder';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Mobile Number",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            TextFormField(
              enabled: false,
              initialValue: SharedPrefs.getPhoneNumber(),
              keyboardType: TextInputType.name,
              autofocus: true,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => FloatingActionButton.extended(
          backgroundColor: secondaryColor,
          label: SizedBox(
            width: 100,
            child: isLoading.value
                ? const SizedBox(
                    height: 20,
                    child: FittedBox(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                : const Text(
                    "Proceed",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
          ),
          onPressed: isLoading.value
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    if (widget.kycType == KYCType.max) {
                      initiateKyc();
                    }
                    if (widget.kycType == KYCType.min) {
                      initiateMinKYC();
                    }
                  }
                },
        ),
      ),
    );
  }
}
