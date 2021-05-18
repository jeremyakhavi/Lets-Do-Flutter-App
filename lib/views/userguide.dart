import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/*
The WebViewWidget is used to display the user guide of the app using web technologies,
the source code (index.html) and images are in the assets folder
*/

class WebViewWidget extends StatefulWidget {
  @override
  WebViewWidgetState createState() => WebViewWidgetState();
}

class WebViewWidgetState extends State<WebViewWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // initialise WebView widget to view index.html file in webview and enable javascript
      child: WebView(
        initialUrl: "file:///android_asset/flutter_assets/assets/index.html",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  // function used to load html from the local assets folder and encode correctly
  Future<void> loadHtmlFromAssets(String filename, controller) async {
    String fileText = await rootBundle.loadString(filename);
    controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
