// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

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
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;

  bool isError = false;
  bool isLoading = true;
  bool lockNavigation = false; // 🔥 lock after first interaction

  late String mainHost;

  @override
  void initState() {
    super.initState();

    // If iOS, auto-launch Safari and close this view
    if (Platform.isIOS) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _launchInSafari(widget.initialUrl);
        Navigator.of(context).pop();
      });
    }


    mainHost = Uri.parse(widget.initialUrl).host;

    options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        javaScriptEnabled: true,
        mediaPlaybackRequiresUserGesture: false,
        useShouldOverrideUrlLoading: true,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        mixedContentMode:
            AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ),
    );

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: Colors.deepPurple),
      onRefresh: () async {
        webViewController?.reload();
      },
    );
  }

  Future<void> _launchInSafari(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  late InAppWebViewGroupOptions options;

  bool _isMainDomain(Uri uri) {
    return uri.host == mainHost;
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) return const SizedBox.shrink();

    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest:
                URLRequest(url: WebUri(widget.initialUrl)),
            initialOptions: options,
            pullToRefreshController: pullToRefreshController,

            onWebViewCreated: (controller) {
              webViewController = controller;
            },

            shouldOverrideUrlLoading:
                (controller, navigationAction) async {
              final uri = navigationAction.request.url;
              if (uri == null) {
                return NavigationActionPolicy.CANCEL;
              }

              // Block external schemes
              if (uri.scheme != "http" &&
                  uri.scheme != "https") {
                return NavigationActionPolicy.CANCEL;
              }

              // 🔥 If locked → only allow same domain
              if (lockNavigation) {
                if (_isMainDomain(uri)) {
                  return NavigationActionPolicy.ALLOW;
                } else {
                  return NavigationActionPolicy.CANCEL;
                }
              }

              return NavigationActionPolicy.ALLOW;
            },

            // 🔥 Block popup windows
            onCreateWindow:
                (controller, createWindowRequest) async {
              return false;
            },

            onLoadStart: (controller, url) {
              setState(() {
                isLoading = true;
                isError = false;
              });
            },

            onLoadStop: (controller, url) async {
              pullToRefreshController?.endRefreshing();
              setState(() {
                isLoading = false;
              });

              // 🔥 After first full load, lock navigation
              if (!lockNavigation) {
                lockNavigation = true;
              }
            },

            onLoadError:
                (controller, url, code, message) {
              pullToRefreshController?.endRefreshing();
              setState(() {
                isError = true;
                isLoading = false;
              });
            },

            androidOnPermissionRequest:
                (controller, origin, resources) async {
              return PermissionRequestResponse(
                resources: resources,
                action:
                    PermissionRequestResponseAction.GRANT,
              );
            },
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(
                    color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}