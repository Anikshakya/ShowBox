// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';
import 'dart:developer';

class CustomWebView extends StatefulWidget {
  final String initialUrl;
  final bool showAppBar;
  final String? errorImageUrl;

  const CustomWebView({
    super.key,
    required this.initialUrl,
    this.showAppBar = false,
    this.errorImageUrl,
  });

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  String url = "";
  double progress = 0;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  bool isError = false;
  bool isLoading = true;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      supportZoom: false,
      transparentBackground: true,
      javaScriptEnabled: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      builtInZoomControls: false,
      mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      useWideViewPort: false,
      forceDark: AndroidForceDark.FORCE_DARK_AUTO,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Colors.deepPurple,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
            urlRequest: URLRequest(url: await webViewController?.getUrl()),
          );
        }
      },
    );
  }

  // Method to reload the WebView with the new URL
  void loadNewUrl(String newUrl) {
    if (webViewController != null) {
      webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(newUrl)));
    }
  }

  @override
  void didUpdateWidget(CustomWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the URL has changed and reload it
    if (widget.initialUrl != oldWidget.initialUrl) {
      loadNewUrl(widget.initialUrl);
    }
  }

    @override
    void dispose() {
      // Reset screen orientation to default when leaving the screen
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      super.dispose();
    }

  void reloadWebView() {
    setState(() {
      isError = false; // Reset the error state
      isLoading = true; // Set loading state to true when starting to reload
    });
    webViewController?.reload();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if (webViewController != null) {
        //   bool canGoBack = await webViewController!.canGoBack();
        //   if (canGoBack) {
        //     // Go back in WebView's history if possible
        //     await webViewController!.goBack();
        //     return false; // Prevent default back behavior
        //   } else {
        //     // Allow popping the current page if cannot go back further
        //     return true;
        //   }
        // }
        return true;
      },
      child: Scaffold(
        appBar: widget.showAppBar == true
            ? AppBar(
                title: const Text("Web View", style: TextStyle(color: Colors.black)),
              )
            : null, // Only show the app bar if showAppBar is true
        body: SizedBox(
          height: MediaQuery.of(context).size.height - kToolbarHeight - 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    if (isError)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Show error image if available, otherwise show error icon
                          widget.errorImageUrl != null
                              ? Image.network(widget.errorImageUrl!)
                              : const Icon(Icons.error_outline, color: Colors.red, size: 50),
                          const SizedBox(height: 10),
                          const Text('Failed to load the page', style: TextStyle(color: Colors.red)),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: reloadWebView,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
                            child: const Text("Reload", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      )
                    else
                      InAppWebView(
                        key: webViewKey,
                        initialUrlRequest: URLRequest(
                          url: WebUri.uri(Uri.parse(widget.initialUrl)),
                        ),
                        initialOptions: options,
                        pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) async {
                          setState(() {
                            this.url = url.toString();
                            isError = false; // Reset error state on page load
                            isLoading = true; // Set loading state to true when page starts loading
                          });
                        },
                        onLoadStop: (controller, url) async {
                          pullToRefreshController!.endRefreshing();
                          setState(() {
                            this.url = url.toString();
                            isLoading = false; // Set loading state to false when page finishes loading
                          });
                        },
                        onEnterFullscreen: (controller) {
                          // Rotate to landscape mode on fullscreen
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeRight,
                            DeviceOrientation.landscapeLeft,
                          ]);
                          debugPrint("Entered fullscreen mode");
                        },
                        onExitFullscreen: (controller) {
                          // Revert to portrait mode on exit fullscreen
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                            DeviceOrientation.portraitDown,
                          ]);
                          debugPrint("Exited fullscreen mode");
                        },
                        androidOnPermissionRequest: (controller, origin, resources) async {
                          return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT,
                          );
                        },
                        shouldOverrideUrlLoading: (controller, navigationAction) async {
                          return NavigationActionPolicy.CANCEL;
                        },
                        onLoadError: (controller, url, code, message) {
                          pullToRefreshController!.endRefreshing();
                          setState(() {
                            isError = true; // Set error state when load fails
                            isLoading = false; // Stop loading animation on error
                          });
                        },
                        onProgressChanged: (controller, progress) {
                          setState(() {
                            this.progress = progress / 100;
                          });
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          debugPrint(consoleMessage.toString());
                        },
                        onLoadResource: (controller, resource) {
                          final url = resource.url;
                          log(url.toString());
                        },
                      ),
                    // Purple loading screen
                    if (isLoading)
                      Stack(
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 42, 36, 53),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                           Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                                ],
                              ),
                            ),
                          ),
                        ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}