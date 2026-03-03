import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  @override
  void onOpened() => debugPrint("Safari Browser: Opened");
  @override
  void onClosed() => debugPrint("Safari Browser: Closed");
}

class CustomWebView extends StatefulWidget {
  final String initialUrl;
  final bool showAppBar;

  const CustomWebView({
    super.key,
    required this.initialUrl,
    this.showAppBar = false,
  });

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  InAppWebViewController? webViewController;
  final MyChromeSafariBrowser safariBrowser = MyChromeSafariBrowser();

  bool isLoading = true;
  late String mainHost;

  @override
  void didUpdateWidget(covariant CustomWebView oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Extra safety reload (not strictly needed because we use ValueKey)
    if (oldWidget.initialUrl != widget.initialUrl) {
      _isPlayerUrl(WebUri(widget.initialUrl));
    }
  }

  @override
  void initState() {
    super.initState();
    mainHost = Uri.parse(widget.initialUrl).host;
  }

  // Detects if the URL is a video file or an embed page like vsembed
  bool _isPlayerUrl(WebUri? uri) {
    if (uri == null) return false;
    final String urlString = uri.toString().toLowerCase();
    
    return urlString.contains("vsembed.ru") || 
           urlString.contains("/embed/") ||
           urlString.endsWith(".mp4") || 
           urlString.endsWith(".m3u8");
  }

  Future<void> _launchSafari(WebUri uri) async {
    if (!safariBrowser.isOpened()) {
      await safariBrowser.open(
        url: uri,
        settings: ChromeSafariBrowserSettings(
          presentationStyle: ModalPresentationStyle.FULL_SCREEN,
          // shareable: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? AppBar(title: const Text("Video Player")) : null,
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.initialUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useShouldOverrideUrlLoading: true,
              // Required for iOS video handling
              allowsInlineMediaPlayback: true, 
              // Setting a real Safari User Agent helps with sites like vsembed
              userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1",
            ),
            
            onWebViewCreated: (controller) {
              webViewController = controller;
              
              // This bridge allows JS to talk to Flutter
              controller.addJavaScriptHandler(handlerName: 'onVideoDetected', callback: (args) {
                final String videoUrl = args[0];
                _launchSafari(WebUri(videoUrl));
              });
            },

            // Intercept direct clicks/navigations
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final uri = navigationAction.request.url;
              
              if (Platform.isIOS && _isPlayerUrl(uri)) {
                await _launchSafari(uri!);
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },

            // Injects JS to find the hidden video source when someone hits play
            onLoadStop: (controller, url) async {
              setState(() => isLoading = false);
              
              await controller.evaluateJavascript(source: """
                (function() {
                  const observer = new MutationObserver((mutations) => {
                    const video = document.querySelector('video');
                    if (video && video.src) {
                      window.flutter_inappwebview.callHandler('onVideoDetected', video.src);
                      observer.disconnect();
                    }
                  });
                  observer.observe(document.body, { childList: true, subtree: true });
                })();
              """);
            },

            onLoadStart: (controller, url) => setState(() => isLoading = true),
          ),

          if (isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
        ],
      ),
    );
  }
}