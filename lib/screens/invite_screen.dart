import 'package:bachat_cards/appbar/appbar.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(),
        title: Text(
          'Invite Friends',
          style: poppinsSemiBold18.copyWith(color: Colors.black),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/invite_photo.png'),
              _spacer16(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fermentum rhoncus morbi sed eu consectetur sit ut. uisque diam commodo ut. Lorem ipsum.',
                  style: poppinsSemiBold14,
                  textAlign: TextAlign.center,
                ),
              ),
              _spacer16(),
              _spacer16(),
              _spacer16(),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffF2F4F6)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Share your code',
                        style: latoBold16,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: const [
                          Text(
                            'XXXXXXXXXXXX',
                            style: latoBold16,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.copy)
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SvgPicture.asset('assets/images/whatsapp.svg'),
                          SvgPicture.asset('assets/images/instagram.svg'),
                          SvgPicture.asset('assets/images/facebook.svg'),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor.withOpacity(0.20)),
                            child: const Icon(
                              Icons.share,
                              color: primaryColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
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
