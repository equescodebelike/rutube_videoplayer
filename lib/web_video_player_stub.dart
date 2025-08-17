import 'package:flutter/widgets.dart';

/// Web video player stub for non-web platforms
class WebVideoPlayer extends StatelessWidget {
  const WebVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.aspectRatio,
  });

  final String videoUrl;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Utility function to parse Rutube and VK video URLs
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
