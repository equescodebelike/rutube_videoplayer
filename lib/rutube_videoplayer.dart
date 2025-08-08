import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'web_video_player_stub.dart' if (dart.library.html) 'web_video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Utility function to check if the URL is a direct video file
bool isDirectVideoUrl(String url) {
  return url.endsWith('.mp4') || url.endsWith('.m3u8') || url.endsWith('.webm');
}

/// Main video player widget that supports Rutube and VK video platforms
/// 
/// This widget automatically detects the platform and uses appropriate player:
/// - For web: Uses HTML5 video player
/// - For mobile: Uses WebView for embedded players or VideoPlayer for direct URLs
class RutubeVideoPlayer extends StatelessWidget {
  /// The video URL to play
  final String videoUrl;
  
  /// Aspect ratio for the video player (default: 16/9)
  final double aspectRatio;
  
  /// Whether to show loading indicator
  final bool showLoadingIndicator;
  
  /// Loading widget to display while video is loading
  final Widget? loadingWidget;
  
  /// Error widget to display when video fails to load
  final Widget? errorWidget;

  const RutubeVideoPlayer({
    required this.videoUrl,
    this.aspectRatio = 16 / 9,
    this.showLoadingIndicator = true,
    this.loadingWidget,
    this.errorWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return WebVideoPlayer(
        videoUrl: parseUrlForRutubeAndVKPlayers(videoUrl),
        aspectRatio: aspectRatio,
      );
    } else {
      if (isDirectVideoUrl(videoUrl)) {
        return VideoPlayerWidget(
          videoUrl: videoUrl,
          aspectRatio: aspectRatio,
          showLoadingIndicator: showLoadingIndicator,
          loadingWidget: loadingWidget,
          errorWidget: errorWidget,
        );
      } else if (videoUrl.contains('rutube.ru') || 
                 videoUrl.contains('vk.com') || 
                 videoUrl.contains('vkvideo.ru')) {
        final embedUrl = parseUrlForRutubeAndVKPlayers(videoUrl);
        return RutubeWebView(
          embedUrl: embedUrl,
          aspectRatio: aspectRatio,
          showLoadingIndicator: showLoadingIndicator,
          loadingWidget: loadingWidget,
          errorWidget: errorWidget,
        );
      } else {
        return errorWidget ?? 
               const Center(child: Text('Unsupported video format'));
      }
    }
  }
}

/// WebView-based player for Rutube and VK videos on mobile platforms
class RutubeWebView extends StatefulWidget {
  final String embedUrl;
  final double aspectRatio;
  final bool showLoadingIndicator;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const RutubeWebView({
    required this.embedUrl,
    this.aspectRatio = 16 / 9,
    this.showLoadingIndicator = true,
    this.loadingWidget,
    this.errorWidget,
    super.key,
  });

  @override
  State<RutubeWebView> createState() => _RutubeWebViewState();
}

class _RutubeWebViewState extends State<RutubeWebView> with WidgetsBindingObserver {
  late final WebViewController controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeController();
  }

  void _initializeController() {
    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            setState(() {
              _hasError = true;
              _isLoading = false;
            });
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            setState(() {
              _isLoading = false;
            });
            _initializePlayer();
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..loadRequest(Uri.parse('${widget.embedUrl}?skinColor=e53935&autoplay=1&app=1'));
  }

  void _initializePlayer() {
    controller.runJavaScript('''
      function initPlayer() {
        console.log('Initializing player...');
        window.addEventListener('message', function (event) {
          try {
            var message = JSON.parse(event.data);
            console.log('Player event:', message.type);
            switch (message.type) {
              case 'player:ready':
                console.log('Player ready:', JSON.stringify(message.data));
                var iframe = document.querySelector('iframe');
                if (iframe && iframe.contentWindow) {
                  iframe.contentWindow.postMessage(JSON.stringify({
                    type: 'player:play',
                    data: {}
                  }), '*');
                }
                break;
              case 'player:changeState':
                console.log('Player state:', message.data.state);
                break;
              case 'player:changeFullscreen':
                console.log('Fullscreen changed:', message.data.isFullscreen);
                break;
              case 'player:error':
                console.log('Player error:', JSON.stringify(message.data));
                setTimeout(function() {
                  var iframe = document.querySelector('iframe');
                  if (iframe && iframe.contentWindow) {
                    iframe.contentWindow.postMessage(JSON.stringify({
                      type: 'player:play',
                      data: {}
                    }), '*');
                  }
                }, 1000);
                break;
            }
          } catch (e) {
            console.log('Error parsing message:', e);
          }
        });

        var style = document.createElement('style');
        style.textContent = `
          body { margin: 0; background: black; }
          iframe { border: none; width: 100%; height: 100%; }
        `;
        document.head.appendChild(style);

        var checkPlayer = setInterval(function() {
          var iframe = document.querySelector('iframe');
          if (iframe) {
            console.log('Player iframe found');
            clearInterval(checkPlayer);
          } else {
            console.log('Waiting for player iframe...');
          }
        }, 1000);
      }

      initPlayer();
    ''');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.errorWidget ?? 
             const Center(child: Text('Failed to load video'));
    }

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoading && widget.showLoadingIndicator)
            Container(
              color: Colors.black,
              child: widget.loadingWidget ?? 
                     const Center(
                       child: CircularProgressIndicator(
                         color: Colors.white,
                       ),
                     ),
            ),
        ],
      ),
    );
  }
}

/// Video player widget for direct video URLs
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final double aspectRatio;
  final bool showLoadingIndicator;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const VideoPlayerWidget({
    required this.videoUrl,
    this.aspectRatio = 16 / 9,
    this.showLoadingIndicator = true,
    this.loadingWidget,
    this.errorWidget,
    super.key,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _initialized = true;
          });
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.errorWidget ?? 
             const Center(child: Text('Failed to load video'));
    }

    if (!_initialized) {
      return widget.showLoadingIndicator
          ? (widget.loadingWidget ?? 
             const Center(child: CircularProgressIndicator()))
          : const SizedBox.shrink();
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}

/// Utility function to parse Rutube and VK video URLs
/// 
/// Converts various Rutube and VK video URL formats to embed URLs
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
