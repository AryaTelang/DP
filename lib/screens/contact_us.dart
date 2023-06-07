import 'package:bachat_cards/appbar/appbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  late TapGestureRecognizer helpRecognizer;
  late TapGestureRecognizer phoneRecognizer;
  late TapGestureRecognizer infoRecognizer;

  @override
  void initState() {
    helpRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        const url = "mailto:help@meribachat.in";
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          Clipboard.setData(const ClipboardData(text: 'help@meribachat.in'))
              .then((_) {
            Get.snackbar('Info', "E-mail copied to clipboard");
          });
        }
      };
    phoneRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        const url = "tel:8700181782";
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          Clipboard.setData(const ClipboardData(text: '8700181782')).then((_) {
            Get.snackbar("Info", "Phone number copied to clipboard");
          });
        }
      };
    infoRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        const url = "mailto:info@meribachat.in";
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          Clipboard.setData(const ClipboardData(text: 'info@meribachat.in'))
              .then((_) {
            Get.snackbar('Info', "E-mail copied to clipboard");
          });
        }
      };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SharedAppBar(appBar: AppBar()),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Get in Touch',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 8,
              ),
              RichText(
                text: TextSpan(
                    text: 'For support, send email to ',
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: 'help@meribachat.in',
                        recognizer: helpRecognizer,
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color.fromARGB(255, 22, 80, 255),
                            fontWeight: FontWeight.w500),
                      ),
                      const TextSpan(
                        text:
                            '\nPlease mention your mobile number in the email for quick response.',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
              ),
              const SizedBox(
                height: 16,
              ),
              RichText(
                text: TextSpan(
                    text: 'Or contact using ',
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: '+91-8700181782',
                        recognizer: phoneRecognizer,
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color.fromARGB(255, 22, 80, 255),
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
              ),
              const SizedBox(
                height: 16,
              ),
              RichText(
                text: TextSpan(
                    text: 'For sales enquiries, send email to ',
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                        text: 'info@meribachat.in',
                        recognizer: infoRecognizer,
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color.fromARGB(255, 22, 80, 255),
                            fontWeight: FontWeight.w500),
                      ),
                    ]),
              ),
            ],
          ),
        ));
  }
}
