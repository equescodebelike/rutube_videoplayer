import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'web_video_player_stub.dart' if (dart.library.js_interop) 'web_video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

bool isDirectVideoUrl(String url) {
  return url.endsWith('.mp4') || url.endsWith('.m3u8') || url.endsWith('.webm');
}

class RutubeVideoPlayer extends StatelessWidget {
  const RutubeVideoPlayer({
    required this.videoUrl,
    this.aspectRatio = 16 / 9,
    super.key,
  });

  final String videoUrl;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return WebVideoPlayer(
        videoUrl: parseUrlForRutubeAndVKPlayers(videoUrl),
        aspectRatio: aspectRatio,
      );
    } else {
      if (isDirectVideoUrl(videoUrl)) {
        return VideoPlayerWidget(videoUrl: videoUrl);
      } else if (videoUrl.contains('rutube.ru') || videoUrl.contains('vk.com') || videoUrl.contains('vkvideo.ru')) {
        final embedUrl = parseUrlForRutubeAndVKPlayers(videoUrl);
        return _RutubeWebView(
          embedUrl: embedUrl,
          aspectRatio: aspectRatio,
        );
      } else {
        return const Center(
          child: Text(
            'Unsupported video type',
          ),
        );
      }
    }
  }
}

class _RutubeWebView extends StatefulWidget {
  const _RutubeWebView({
    required this.embedUrl,
    required this.aspectRatio,
  });

  final String embedUrl;
  final double aspectRatio;

  @override
  State<_RutubeWebView> createState() => _RutubeWebViewState();
}

class _RutubeWebViewState extends State<_RutubeWebView> with WidgetsBindingObserver {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: \\${error.description}');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: \\$url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: \\$url');
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
                        if (message.data.state === 'playing') {
                          console.log('Video started playing');
                        }
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
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..loadRequest(Uri.parse('${widget.embedUrl}?skinColor=e53935&autoplay=1&app=1'));
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
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: WebViewWidget(
        controller: controller,
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    required this.videoUrl,
    super.key,
  });

  final String videoUrl;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
