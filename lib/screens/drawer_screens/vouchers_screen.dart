import 'package:bachat_cards/appbar/appbar.dart';
import 'package:bachat_cards/controllers/vouchers_controller.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/voucher.dart';
import '../../sevrices/shared_prefs.dart';
import '../../wdigets/voucher_item.dart';

class VouchersScreen extends StatelessWidget {
  VouchersScreen({super.key});

  final vouchersController = Get.put(VouchersController());
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(

        ),
      ),
      body: RefreshIndicator(onRefresh: () {
        return vouchersController.getVouchers(dio);
      }, child: Obx(() {
        if (vouchersController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!vouchersController.isLoading.value &&
            vouchersController.vouchers.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: vouchersController.vouchers.length,
                  itemBuilder: (context, index) {
                    Voucher v = vouchersController.vouchers[index];
                    return VoucherItem(
                      brandName: v.brand!.name ?? '',
                      amount: v.denomination ?? '',
                      code: v.vouchers!.cardNumber ?? '',
                      expiryDate: v.vouchers!.validity ?? '',
                      logo:
                          v.brand!.brandLogo == '' ? null : v.brand!.brandLogo,
                      pin: v.vouchers!.cardPin ?? '',
                      purchaseDate: v.vouchers!.purchasedDate ?? '',
                    );
                  },
                );
              } else {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16),
                    itemCount: vouchersController.vouchers.length,
                    itemBuilder: (context, index) {
                      Voucher v = vouchersController.vouchers[index];
                      return VoucherItem(
                        brandName: v.brand!.name ?? '',
                        amount: v.denomination ?? '',
                        code: v.vouchers!.cardNumber ?? '',
                        expiryDate: v.vouchers!.validity ?? '',
                        logo: v.brand!.brandLogo == ''
                            ? null
                            : v.brand!.brandLogo,
                        pin: v.vouchers!.cardPin ?? '',
                        purchaseDate: v.vouchers!.purchasedDate ?? '',
                      );
                    });
              }
            }),
          );
        }
        if (!vouchersController.isLoading.value &&
            vouchersController.vouchers.isEmpty) {
          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth),
                child: const Center(
                  child: Text('You don\'t have any vouchers'),
                ),
              ),
            ),
          );
        }
        return const Center(
          child: Text('None'),
        );
      })),
    );
  }
}
