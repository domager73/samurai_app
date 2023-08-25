import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:webview_flutter/webview_flutter.dart';

// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

// #enddocregion platform_imports
import '../components/anim_button.dart';
import '../data/music_manager.dart';

class ViewWebPage extends StatefulWidget {
  const ViewWebPage({required this.url, super.key});

  final String url;

  @override
  State<ViewWebPage> createState() => _ViewWebPageState();
}

class _ViewWebPageState extends State<ViewWebPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(),
      )
      ..loadRequest(Uri.parse(widget.url));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;

    GetIt.I<MusicManager>().screenChangePlayer.play().then((value) async {
      await GetIt.I<MusicManager>()
          .screenChangePlayer
          .seek(Duration(seconds: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            body: Stack(children: [
      SizedBox(
          width: width,
          height: height,
          child: WebViewWidget(controller: _controller)),
      Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0C133D),
            shape: BoxShape.circle,
          ),
          margin: EdgeInsets.only(top: width * 0.00, left: width * 0.02),
          child: PresButton(
            onTap: () => Navigator.of(context).pop(),
            params: {'width': width},
            child: backBtn,
            player: GetIt.I<MusicManager>().keyBackSignCloseX,
          ))
    ])));
  }
}
