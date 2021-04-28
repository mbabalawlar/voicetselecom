import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebsiteWidget extends StatefulWidget {
  @override
  _WebsiteWidgetState createState() => _WebsiteWidgetState();
}

class _WebsiteWidgetState extends State<WebsiteWidget> {
  bool isLoading;
  InAppWebViewController webView;

  @override
  void initState() {
    super.initState();
    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Website", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo[900],
        elevation: 0.0,
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Stack(
        children: <Widget>[
          Builder(builder: (BuildContext context) {
            return InAppWebView(
              initialUrl:
                  "https://www.elecastlesubng.com",
              initialHeaders: {},
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  debuggingEnabled: true,
                ),
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart: (InAppWebViewController controller, String url) {
                setState(() {
                  isLoading = true;
                });
              },
              onLoadStop:
                  (InAppWebViewController controller, String url) async {
                    // await controller.injectJavascriptFileFromAsset(assetFilePath: "assets/js/main.js");
                  // 30
                setState(() {
                  //this.url = url;
                  print('Page finished loading: $url');
                  setState(() {
                    isLoading = false;
                  });
                });
              },
              
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                    
                setState(() {
                  //this.progress = progress / 100;
                });
              },
            );
          }),
          isLoading ? Center(child: CircularProgressIndicator()) : Container(),
        ],
      ),
    );
  }
}
