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
      extendBodyBehindAppBar: true,
      appBar: SharedAppBar(
        appBar: AppBar(),
        title: Text(
        widget.type == CardType.onceReload
            ? 'Buy once loadable card'
            : widget.type == CardType.multiReload
            ? 'Buy multi loadable card'
            : 'Reload your card',
        style: poppinsSemiBold18.copyWith(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF7C64FF), Color(0xFF130078)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 250), //TODO: Use MediaQuery
              child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                    ),
                child: Padding(
                  padding: EdgeInsets.only(top: 200),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: [
                          Form(
                            key: _formKey,
                            child: Wrap(runSpacing: 16, children: [
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
                                    hintText: 'Name',
                                    controller: nameController, validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Please enter a name';
                                      }
                                      return null;
                                    },
                                    icon: Icon(Icons.person_outline),
                                    helper: ""),
                              if (widget.type != CardType.multiReload)
                                _textFields(const Key('Amount'),
                                  hintText: 'Enter Amount',
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
                                  },
                                  icon: Icon(Icons.circle_outlined),
                                  helper: "Max amount is Rs 10000",),
                              SizedBox(height: 100,), // TODO: Use Spacer
                              Obx(
                                    () => Center(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            maximumSize: Size(
                                                MediaQuery.of(context).size.width / 1.2,
                                                64),
                                            minimumSize: Size(
                                                MediaQuery.of(context).size.width / 1.2,
                                                64),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30))),
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
                                            ? 'Proceed to Pay'
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
                    );
                  }),
                ),
                  ),
            ),
          ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: AspectRatio(
                    aspectRatio: 10.5 / 16,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
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
        ],
      ),
    );
  }

  _textFields(Key key,
      {required String hintText,
      required TextEditingController controller,
      required String? Function(String?) validator,
      required Icon icon,
      required String? helper}) {
    return Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
          child: TextFormField(
            key: key,
            controller: controller,
            validator: validator,
            decoration: InputDecoration(
              prefixIcon: icon,
              hintText: hintText,
              helperText: helper,
            ),
            keyboardType: controller == amountController
                ? TextInputType.number
                : TextInputType.name,
          ),
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
