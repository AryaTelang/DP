import 'package:bachat_cards/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RewardsItem extends StatelessWidget {
  const RewardsItem(
      {super.key,
      required this.imageLink,
      required this.brandName,
      required this.discountPercentage,
      required this.brandLogoLink});

  final String imageLink;
  final String brandName;
  final double discountPercentage;
  final String brandLogoLink;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        child: Banner(
          message: "$discountPercentage% off",
          location: BannerLocation.topStart,
          color: Colors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) {
                        return SvgPicture.asset('assets/images/errorImage.svg');
                      },
                      key: UniqueKey(),
                      imageUrl: imageLink,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.height / 2,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 0,
                    child: Container(
                      color: Colors.white,
                      width: 50,
                      height: 40,
                      child: CachedNetworkImage(
                        imageUrl: brandLogoLink,
                        errorWidget: (context, error, stackTrace) {
                          return SvgPicture.asset(
                              'assets/images/errorImage.svg');
                        },
                      ),
                    ),
                  )
                ],
              )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Text(
                  brandName,
                  overflow: TextOverflow.ellipsis,
                  style: latoBold16.copyWith(fontWeight: FontWeight.w700,fontSize: 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
