import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;
import 'dart:ui_web' as ui_web;

/// Web video player for HTML5 video playback using iframe
class WebVideoPlayer extends StatefulWidget {
  const WebVideoPlayer({
    super.key,
    required this.videoUrl,
    this.aspectRatio = 16 / 9,
  });

  final String videoUrl;
  final double aspectRatio;

  @override
  State<WebVideoPlayer> createState() => _WebVideoPlayerState();
}

class _WebVideoPlayerState extends State<WebVideoPlayer> {
  late String viewType;

  @override
  void initState() {
    super.initState();
    _registerIframe();
  }

  @override
  void didUpdateWidget(covariant WebVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _registerIframe();
    }
  }

  void _registerIframe() {
    viewType = 'iframeElement_${DateTime.now().millisecondsSinceEpoch}';

    if (kIsWeb) {
      ui_web.platformViewRegistry.registerViewFactory(
        viewType,
        (int viewId) {
          final iframe = web.HTMLIFrameElement()
            ..src = widget.videoUrl
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%'
            ..allowFullscreen = true;
          return iframe;
        },
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: HtmlElementView(viewType: viewType),
    );
  }
}

/// Utility function to parse Rutube and VK video URLs for web
String parseUrlForRutubeAndVKPlayers(String url) {
  if (url.contains('vkvideo.ru/video-')) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments.first.split('-');
    if (segments.length > 1) {
      final ids = segments[1].split('_');
      if (ids.length == 2) {
        return 'https://vkvideo.ru/video_ext.php?oid=-${ids[0]}&id=${ids[1]}&hd=2';
      }
    }
  } else if (url.contains('rutube.ru/video/')) {
    final uri = Uri.parse(url);
    final videoId = uri.pathSegments[1];
    return 'https://rutube.ru/play/embed/$videoId/';
  } else if (url.contains('https://rutube.ru/play/embed/')) {
    return url;
  } else if (url.contains('https://vk.com/video_ext.php')) {
    return url;
  }
  return '';
}
