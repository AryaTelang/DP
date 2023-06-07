import 'package:bachat_cards/appbar/appbar.dart';
import 'package:bachat_cards/controllers/redeem_points_screen_controller.dart';
import 'package:bachat_cards/screens/rewards_screens/points_redeemption_status_screen.dart';
import 'package:bachat_cards/sevrices/firebase_analytics.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/home_screen_controller.dart';
import '../../sevrices/shared_prefs.dart';
import '../../theme/theme.dart';
import '../../wdigets/metadata_widget.dart';
import '../terms_conditions_screen.dart';

class RedeemPointsScreen extends StatefulWidget {
  const RedeemPointsScreen({super.key, required this.brandId});

  final String brandId;

  @override
  State<RedeemPointsScreen> createState() => _RedeemPointsScreenState();
}

class _RedeemPointsScreenState extends State<RedeemPointsScreen> {
  final redeemPointsScreenController = Get.put(RedeemPointsScreenController());
  final _formKey = GlobalKey<FormState>();
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  List<String> cardStrings = [
    'Online store',
    'Offline store',
    'Can club with offers',
    'Cannot club with offers',
    'Partial redemption is allowed',
    'Partial redemption is not allowed',
    'Mutliple giftcards can be applied',
    'Mutliple giftcards cannot be applied'
  ];

  List<String> iconPaths = [
    'assets/images/online_store.svg',
    'assets/images/club_offers.svg',
    'assets/images/partial_redeem.svg',
    'assets/images/multiple_cards.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SharedAppBar(
        appBar: AppBar(),
        title: Text(
          'Redeem Points',
          style: poppinsSemiBold18.copyWith(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: redeemPointsScreenController.getBrandById(widget.brandId, dio),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (redeemPointsScreenController.b['brand'] == null) {
            return const Center(
              child: Text('Sorry!! Brand not found'),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Some error occured'),
            );
          }
          if (snapshot.hasData) {
            assert(snapshot.data != null);
            Map<String, dynamic> m = snapshot.data!['brand'];
            Map<String, dynamic> metadata = snapshot.data!['metadata'];
            String logo = '';
            String brandImage = '';
            List<String> denominations = [];
            if (m['preferred'] == 'pine') {
              Map<String, dynamic> d = m['pineDenominations'];
              d.forEach((key, value) {
                denominations.add(key);
              });
            } else if (m['preferred'] == 'gyftr') {
              Map<String, dynamic> d = m['gyftrDenominations'];
              d.forEach((key, value) {
                denominations.add(key);
              });
            }
            if (m['brandImages'].isNotEmpty) {
              brandImage = m['brandImages'][0];
            }
            if (m['gyftrImage'] != '') {
              logo = m['gyftrImage'];
            } else if (m['pineImage'] != null) {
              logo = m['pineImage']['mobile'];
            }
            return SingleChildScrollView(
              child: Stack(children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: Image.network(
                      brandImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return SvgPicture.asset('assets/images/errorImage.svg');
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  logo != ''
                                      ? logo
                                      : 'https://gbdev.s3.amazonaws.com/uat/product/CNPIN/d/small_image/324_microsite.png',
                                  errorBuilder: (context, error, stackTrace) =>
                                      SvgPicture.asset(
                                          'assets/images/errorImage.svg'),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                Text(
                                  "Get ${m['discountOthers'] ?? 0.0}% Flat off",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: 2,
                              color: primaryColor,
                            ),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Text(
                                    'Your Balance: \u{20B9}${Get.find<HomeScreenController>().userBalance}',
                                    style: const TextStyle(
                                        color: accentColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                const Text(
                                  'Choose a denomination',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: primaryColor,
                                      fontSize: 16),
                                ),
                                Wrap(
                                  spacing: 8,
                                  children: List.generate(
                                      denominations.length,
                                      (index) => Obx(
                                            () => ChoiceChip(
                                              label: Text(denominations[index]),
                                              selectedColor: primaryColor,
                                              selected:
                                                  redeemPointsScreenController
                                                          .selectedChip.value ==
                                                      double.parse(
                                                          denominations[index]),
                                              labelStyle: TextStyle(
                                                  color:
                                                      redeemPointsScreenController
                                                                  .selectedChip
                                                                  .value !=
                                                              double.parse(
                                                                  denominations[
                                                                      index])
                                                          ? Colors.black
                                                          : Colors.white),
                                              onSelected:
                                                  Get.find<HomeScreenController>()
                                                              .userBalance >=
                                                          double.parse(
                                                              denominations[
                                                                  index])
                                                      ? (value) {
                                                          if (value) {
                                                            redeemPointsScreenController
                                                                .updateSelectedChip(
                                                                    int.parse(
                                                                        denominations[
                                                                            index]));
                                                            redeemPointsScreenController
                                                                    .pointsEditingControler
                                                                    .text =
                                                                denominations[
                                                                    index];
                                                            // redeemPointsScreenController
                                                            //     .getFinalAmount(
                                                            //         double.parse(
                                                            //             m['discountOthers']
                                                            //                 .toString()));
                                                          }
                                                        }
                                                      : null,
                                            ),
                                          )),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                if (m['dynamicDenomination'] != null &&
                                    m['dynamicDenomination'])
                                  const Text('Enter Amount'),
                                if (m['dynamicDenomination'] != null &&
                                    m['dynamicDenomination'])
                                  const SizedBox(
                                    height: 10,
                                  ),
                                if (m['dynamicDenomination'] != null &&
                                    m['dynamicDenomination'])
                                  Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      key: const Key('Reward amount'),
                                      validator: (value) {
                                        if(value!=null && (double.tryParse(value) ?? 0.0) > Get.find<HomeScreenController>().userBalance.value){
                                          return "You don't have enough points";
                                        }
                                        return null;
                                      },
                                      controller: redeemPointsScreenController
                                          .pointsEditingControler,
                                      onChanged: (value) {
                                        if (value.isNotEmpty && (double.tryParse(value) ?? 0.0) < Get.find<HomeScreenController>().userBalance.value) {
                                          redeemPointsScreenController
                                              .updateSelectedChip(
                                                  int.parse(value));
                                          // redeemPointsScreenController
                                          //     .getFinalAmount(double.parse(
                                          //         m['discountOthers']
                                          //             .toString()));
                                        }
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        fillColor: const Color(0xfff5f5f5),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color.fromARGB(11, 0, 0, 0),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: primaryColor.withOpacity(.2),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: FittedBox(
                                            child: Obx(
                                          () => Text(
                                            'You Pay: \u{20B9} ${redeemPointsScreenController.selectedChip.value}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: primaryColor),
                                          ),
                                        )),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (redeemPointsScreenController
                                                    .selectedChip.value ==
                                                0) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Please select a denomination')));
                                            } else {
                                              _showConfirmationDialog(context);
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        child: Text(
                                          'Checkout',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (metadata != {})
                        Wrap(direction: Axis.horizontal, spacing: 8, children: [
                          if (metadata['online'] != null && metadata['online']!)
                            MetadataWidget(
                                iconPath: iconPaths[0], text: cardStrings[0]),
                          if (metadata['offline'] != null &&
                              metadata['offline']!)
                            MetadataWidget(
                                iconPath: iconPaths[0], text: cardStrings[1]),
                          if (metadata['clubWithOffer'] != null &&
                              metadata['clubWithOffer']!)
                            MetadataWidget(
                                iconPath: iconPaths[1], text: cardStrings[2]),
                          if (metadata['cannotClubWithOffers'] != null &&
                              metadata['cannotClubWithOffers']!)
                            MetadataWidget(
                                iconPath: iconPaths[1], text: cardStrings[3]),
                          if (metadata['multipleAllowed'] != null &&
                              metadata['multipleAllowed']!)
                            MetadataWidget(
                                iconPath: iconPaths[2], text: cardStrings[4]),
                          if (metadata['notMultipleAllowed'] != null &&
                              metadata['notMultipleAllowed']!)
                            MetadataWidget(
                                iconPath: iconPaths[2], text: cardStrings[5]),
                          if (metadata['partialRedemption'] != null &&
                              metadata['partialRedemption']!)
                            MetadataWidget(
                                iconPath: iconPaths[3], text: cardStrings[6]),
                          if (metadata['notPartialRedemption'] != null &&
                              metadata['notPartialRedemption']!)
                            MetadataWidget(
                                iconPath: iconPaths[3], text: cardStrings[7])
                        ]),
                      const SizedBox(
                        height: 16,
                      ),
                      OutlinedButton(
                          onPressed: () {
                            Get.to(() => TermsConditionsScreen(
                                  terms: m['preferred'] == 'pine'
                                      ? m['pineTerms']['content']
                                      : m['gyftrTerms']['content'],
                                ));
                          },
                          child: const Text('Terms & Conditions'))
                    ],
                  ),
                )
              ]),
            );
          }
          return const Center(
            child: Text('None'),
          );
        },
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Purchase Confirmation'),
              content: const Text(
                'Are you sure to buy the giftcard?',
              ),
              actions: [
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () async {
                    String result =
                        await redeemPointsScreenController.redeemGiftCard(dio,
                            amount:
                                redeemPointsScreenController.selectedChip.value,
                            denomination: redeemPointsScreenController
                                .selectedChip.value
                                .toString(),
                            brandId: widget.brandId);
                    Get.find<HomeScreenController>().getUserBalance(dio);
                    if (result == 'success') {
                      Get.back();
                      Get.off(() => const PointsRedeemptionStatusScreen());
                      AnalyticsService.logVoucherRedeem(
                          amount: redeemPointsScreenController
                              .selectedChip.value
                              .toString(),
                          brandName: redeemPointsScreenController.b['brand']
                                  ['name'] ??
                              '',
                          denomination: redeemPointsScreenController
                              .selectedChip.value
                              .toString(),
                          itemCategory: redeemPointsScreenController.b['brand']
                              ['categories'][0]['category'],
                          brandId: redeemPointsScreenController.b['brand']
                              ['_id']);
                    } else {
                      Get.back();
                      Get.snackbar('Error',
                          'Some error occured while redeeming voucher');
                    }
                  },
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel'),
                )
              ],
            ));
  }
}
