import 'package:flutter/material.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../themes.dart';

class WebViewScreen extends StatefulWidget {
  String title;
  String url;
  bool centerTitle;

  WebViewScreen(
      {required this.title,
      required this.url,
      this.centerTitle = false,
      Key? key})
      : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool _isLoading = false;
  int _progress = 0;
  late WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await webViewController.canGoBack()) {
          webViewController.goBack();
          return false;
        }

        return true;
      },
      child: Scaffold(
        appBar: widget.title.isNotEmpty
            ? AppBar(
                title: Text(
                  widget.title.trim(),
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
                elevation: 0,
                backgroundColor: Themes.primary,
                centerTitle: widget.centerTitle,
                titleSpacing: 0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: MyBackButton(
                    color: Themes.iconLight,
                  ),
                ),
              )
            : null,
        body: SafeArea(
          child: Column(
            children: [
              if (_isLoading)
                LinearProgressIndicator(
                  color: Themes.secondary,
                  minHeight: 3,
                  value: _progress.toDouble() / 100,
                ),
              Expanded(
                child: WebView(
                  onPageStarted: (url) {
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  onPageFinished: (url) {
                    setState(() {
                      _isLoading = false;
                    });

                    webViewController.evaluateJavascript("function toMobile(){"
                        "var meta = document.createElement('meta'); "
                        "meta.setAttribute('name', 'viewport');"
                        " meta.setAttribute('content', 'width=device-width, initial-scale=1'); "
                        "var head= document.getElementsByTagName('head')[0];"
                        "head.appendChild(meta); "
                        "}"
                        "toMobile()");
                  },
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onProgress: (progress) => setState(() {
                    _progress = progress;
                  }),
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
