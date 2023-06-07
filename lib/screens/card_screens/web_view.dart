import 'package:bachat_cards/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebView extends StatelessWidget {
  const WebView({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(appBar: AppBar()),
      body: FutureBuilder(builder: (context, snapshot) {
        return SafeArea(
            child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(url)),
        ));
      }),
    );
  }
}
