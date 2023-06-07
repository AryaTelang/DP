import 'package:bachat_cards/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class GiftCardItem extends StatelessWidget {
  GiftCardItem(
      {super.key,
      this.brandLogoLink,
      this.brandName,
      this.brandImage,
      this.expiry,
      this.description,
      this.onClick});

  String? brandImage;
  String? brandLogoLink;
  String? brandName;
  String? expiry;
  String? description;
  VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xfff6f6f6)),
      child: Row(children: [
        Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xffd9d9d9)),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: double.infinity,
                      child: brandImage == '' || brandImage == null
                          ? Container()
                          : CachedNetworkImage(
                              imageUrl: brandImage ?? '',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (brandLogoLink != null && brandLogoLink != '')
                          Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  border: Border.all(color: textColor),
                                  shape: BoxShape.circle,
                                  color: Colors.white),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl: brandLogoLink ?? '',
                                  errorWidget: (context, url, error) =>
                                      SvgPicture.asset(
                                          'assets/images/errorImage.svg'),
                                ),
                              )),
                        const Spacer(),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(16)),
                            child: Text(
                              brandName?.trim() ?? '',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: textColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
        Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: Html(data: description ?? '')),
                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff6655C0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minimumSize: const Size.fromHeight(40)),
                      onPressed: onClick,
                      child: const Text('Redeem'),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  )
                ],
              ),
            ))
      ]),
    );
  }
}
