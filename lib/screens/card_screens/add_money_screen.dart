import 'package:bachat_cards/Constants/constants.dart';
import 'package:bachat_cards/appbar/appbar.dart';
import 'package:bachat_cards/controllers/post_login_screen_controller.dart';
import 'package:bachat_cards/screens/payment_status_screens/fail_screen.dart';
import 'package:bachat_cards/screens/payment_status_screens/success_screen.dart';
import 'package:bachat_cards/screens/temporary_paytm.dart';
import 'package:bachat_cards/sevrices/firebase_analytics.dart';
import 'package:bachat_cards/sevrices/shared_prefs.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

import '../../controllers/cards_controller.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key, required this.type});

  final CardType type;

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController amountController = TextEditingController();
  var isLoading = false.obs;
  final maxReloadAmount = 0.obs;
  var isCheckingAmount = false.obs;

  @override
  void initState() {
    if (widget.type == CardType.multiReloadAddAmount) {
      checkMaxReloadAmount();
    }
    super.initState();
  }

  void checkMaxReloadAmount() async {
    isCheckingAmount.value = true;
    try {
      final response = await dio
          .get('${Constants.url}/mbc/v1/card/balance', queryParameters: {
        'referenceId': Get.find<CardsController>()
            .multiLoadableCard
            .value
            .cardReferenceNumber
      });
      setState(() {
        maxReloadAmount.value = response.data['monthlyReloadableAmount'];
      });
    } on DioError catch (e) {
      debugPrint('Get balance error : ${e.response}');
      Get.snackbar('Error',
          "Some error occured while trying to get balance. Please try again later");
    } finally {
      isCheckingAmount.value = false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(),
        title: Text(
          widget.type == CardType.onceReload
              ? 'Buy once loadable card'
              : widget.type == CardType.multiReload
                  ? 'Buy multi loadable card'
                  : 'Reload your card',
          style: poppinsSemiBold18.copyWith(color: Colors.black),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Wrap(runSpacing: 16, children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: AspectRatio(
                            aspectRatio: 10.5 / 16,
                            child: Container(
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'assets/images/cardBackground.png')),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (widget.type == CardType.multiReloadAddAmount)
                      Obx(
                        () => Text(
                            'Max Permisable amount \u{20B9} $maxReloadAmount',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Lato')),
                      ),
                    if (widget.type != CardType.multiReloadAddAmount)
                      _textFields(const Key('Name'),
                          title: 'Enter your name',
                          hintText: 'Name',
                          controller: nameController, validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      }),
                    if (widget.type != CardType.multiReload)
                      _textFields(const Key('Amount'),
                          hintText: 'Enter Amount',
                          title: 'Enter  amount',
                          controller: amountController, validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter amount';
                        }
                        if (val.contains(',')) {
                          return 'Enter amount without special charcters';
                        }
                        if (widget.type == CardType.multiReloadAddAmount &&
                            (int.parse(val) > maxReloadAmount.value ||
                                int.parse(val) < 1)) {
                          return 'Please enter amount between \u{20B9}1 - \u{20B9}$maxReloadAmount';
                        }
                        if (widget.type == CardType.onceReload &&
                            (int.parse(val) < 1 || int.parse(val) > 10000)) {
                          return 'Please enter amount between \u{20B9}1 - \u{20B9}10,000';
                        }
                        return null;
                      }),
                    Obx(
                      () => Center(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  maximumSize: Size(
                                      MediaQuery.of(context).size.width / 3,
                                      44),
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width / 3,
                                      44),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (widget.type == CardType.onceReload ||
                                      widget.type == CardType.multiReload) {
                                    _buyCard();
                                  } else {
                                    _reloadCard();
                                  }
                                }
                              },
                              child: isLoading.value
                                  ? const Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : Text(widget.type !=
                                          CardType.multiReloadAddAmount
                                      ? 'Get Card'
                                      : 'Add Money'))),
                    )
                  ]),
                ),
                Obx(() => isCheckingAmount.value
                    ? Container(
                        height: constraints.maxHeight,
                        color: Colors.white.withOpacity(0.5),
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    : Container()),
              ],
            ),
          ),
        );
      }),
    );
  }

  _textFields(Key key,
      {required String title,
      required String hintText,
      required TextEditingController controller,
      required String? Function(String?) validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: latoRegular16.copyWith(
              fontWeight: FontWeight.w600, color: secondaryColor),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          key: key,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: const Color(0xFFF5F5F5),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black.withOpacity(.15)),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFF5F5F5)),
            ),
          ),
          keyboardType: controller == amountController
              ? TextInputType.number
              : TextInputType.name,
        )
      ],
    );
  }

  void _reloadCard() async {
    isLoading.value = true;
    try {
      final response =
          await dio.post('${Constants.url}/mbc/v1/order/reload', data: {
        'cardId': Get.find<CardsController>()
            .multiLoadableCard
            .value
            .cardReferenceNumber,
        'amount': int.parse(amountController.text)
      });
      tempPaytm(orderId: response.data['result']['orderId']);
      // _initiatePaytmTransaction(
      //     transactionToken: response.data['result']['transactionToken'],
      //     orderId: response.data['result']['orderId']);
    } on DioError catch (e) {
      if (e.response != null && e.response!.data != null) {
        Get.snackbar(
            'Error', e.response!.data['message'] ?? 'Some error occured');
      }
      debugPrint('Reload card: ${e.response}');
    }
    isLoading.value = false;
  }

  void _buyCard() async {
    isLoading.value = true;
    try {
      final response =
          await dio.post('${Constants.url}/mbc/v1/order/card', data: {
        "cardType":
            widget.type == CardType.onceReload ? 'nonreloadable' : 'reloadable',
        "userId": int.parse(SharedPrefs.getUserEarnestId()),
        "cardDetails": [
          {
            "customerName": nameController.text,
            "mobileNumber": SharedPrefs.getPhoneNumber().substring(3),
            "email": Get.find<PostLoginScreenController>()
                .userProfile
                .value
                .userInfo!
                .email,
            "amount": int.tryParse(amountController.text.trim()) ?? 0,
          }
        ],
        "amount": int.tryParse(amountController.text.trim()) ?? 0,
        "upiOnly": false,
        "sessionId": false
      });
      if (widget.type == CardType.multiReload) {
        Get.to(() => const SuccessScreen(
              orderId: "",
              type: CardType.multiReload,
            ));
      } else {
        tempPaytm(orderId: response.data['result']['orderId']);
      }
      // await _initiatePaytmTransaction(
      //     orderId: response.data['result']['orderId'],
      //     transactionToken: response.data['result']['transactionToken']);
    } on DioError catch (e) {
      Get.snackbar('Error!', 'Error occured. Please try again later');
      debugPrint('buy card: ${e.response}');
    } finally {
      isLoading.value = false;
    }
  }

  void tempPaytm({required String orderId}) {
    Get.to(() => TempPaytm(
          orderId: orderId,
          paymentType: widget.type,
          amount: amountController.text.toString(),
          type: widget.type == CardType.multiReload ||
                  widget.type == CardType.onceReload
              ? "card"
              : widget.type == CardType.multiReloadAddAmount
                  ? "reload"
                  : "kyc",
        ));
  }

  // ignore: unused_element
  Future<void> _initiatePaytmTransaction(
      {required String transactionToken, required String orderId}) async {
    var response = AllInOneSdk.startTransaction(
        'EARNES68317703946728',
        'PG$orderId',
        amountController.text.trim().toString(),
        transactionToken,
        '',
        true,
        true);
    response.then((value) {
      if (value!['STATUS'] == 'TXN_SUCCESS') {
        if (widget.type == CardType.multiReload ||
            widget.type == CardType.onceReload) {
          AnalyticsService.logBuyCard(
              amount: amountController.text.trim().toString());
        } else if (widget.type == CardType.multiReloadAddAmount) {
          AnalyticsService.logCardReload(
              amount: amountController.text.trim().toString());
        }
        Get.off(() => SuccessScreen(
              orderId: 'PG$orderId',
              type: widget.type,
            ));
      }
    }).catchError((onError) {
      debugPrint('paytm Error: $onError');
      Get.to(() => const FailScreen());
    });
  }
}
