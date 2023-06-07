import 'package:bachat_cards/screens/rewards_screens/redeem_points_screen.dart';
import 'package:bachat_cards/sevrices/firebase_analytics.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../appbar/appbar.dart';
import '../../controllers/search_controller.dart';
import '../../sevrices/shared_prefs.dart';
import '../../theme/theme.dart';

class SearchRewardsScreen extends StatefulWidget {
  const SearchRewardsScreen({super.key});

  @override
  State<SearchRewardsScreen> createState() => _SearchRewardsScreenState();
}

class _SearchRewardsScreenState extends State<SearchRewardsScreen> {
  final searchController = Get.put(SearchController());
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));
  final TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(),
        title: Text(
          'Search Rewards',
          style: poppinsSemiBold18.copyWith(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(
            key: const Key('search'),
            controller: searchTextController,
            decoration: InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(
                borderSide: const BorderSide(),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                searchController.handleSearch(value, dio);
              } else {
                searchController.searchedList.clear();
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(child: Obx(() {
            if (searchController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!searchController.isLoading.value &&
                searchController.searchedList.isEmpty) {
              return const Center(
                child: Text('No vouchers found!!!'),
              );
            }
            if (!searchController.isLoading.value &&
                searchController.searchedList.isNotEmpty) {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: searchController.searchedList.length,
                itemBuilder: ((context, index) {
                  final brand = searchController.searchedList[index];
                  String brandImage = '';
                  if (brand.gyftrImage != '') {
                    brandImage = brand.gyftrImage!;
                  } else {
                    brandImage = brand.pineImage!.mobile!;
                  }
                  return GestureDetector(
                    key: const Key('Gesture'),
                    onTap: () {
                      AnalyticsService.logVoucherSearch(
                          voucherName:
                              searchController.searchedList[index].name ?? '');
                      Get.to(() => RedeemPointsScreen(
                            brandId:
                                searchController.searchedList[index].sId ?? '',
                          ));
                    },
                    child: SizedBox(
                      child: Row(children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child: CachedNetworkImage(
                            imageUrl: brandImage,
                            errorWidget: (context, error, stackTrace) {
                              return Image.asset('assets/images/logo.png');
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            searchController.searchedList[index].name ?? '',
                            softWrap: true,
                          ),
                        )
                      ]),
                    ),
                  );
                }),
              );
            }
            return const Center(
              child: Text('None'),
            );
          }))
        ]),
      ),
    );
  }
}
