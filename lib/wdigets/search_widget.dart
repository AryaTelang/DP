import 'package:flutter/material.dart';

import '../theme/theme.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0x85FFFFFF),
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.white),
              const VerticalDivider(
                thickness: 1,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Search',
                style: latoRegular16.copyWith(color: Colors.white),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
