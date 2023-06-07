import 'package:flutter/material.dart';

class KycWidget extends StatelessWidget {
  const KycWidget(
      {super.key,
      required this.cardText,
      required this.onClick,
      required this.buttonText});

  final String cardText;
  final VoidCallback onClick;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 240,
          width: double.infinity,
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                      child: Image.asset('assets/images/cardBackground.png')),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Text(
                    cardText,
                    style: const TextStyle(fontSize: 18),
                  ))
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff6E56FF),
                  Color(0xff3012E8),
                ],
              ),
            ),
            child: ElevatedButton(
                onPressed: onClick,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    disabledForegroundColor:
                        Colors.transparent.withOpacity(0.38),
                    disabledBackgroundColor:
                        Colors.transparent.withOpacity(0.12),
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40)),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                )),
          ),
        ),
      ],
    );
  }
}
