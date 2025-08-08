import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rutube_videoplayer/rutube_videoplayer.dart';

void main() {
  group('RutubeVideoPlayer Tests', () {
    testWidgets('RutubeVideoPlayer displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RutubeVideoPlayer(
              videoUrl: 'https://example.com/video.mp4',
            ),
          ),
        ),
      );

      expect(find.byType(RutubeVideoPlayer), findsOneWidget);
    });

    testWidgets('RutubeVideoPlayer with custom aspect ratio', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RutubeVideoPlayer(
              videoUrl: 'https://example.com/video.mp4',
              aspectRatio: 4 / 3,
            ),
          ),
        ),
      );

      expect(find.byType(RutubeVideoPlayer), findsOneWidget);
    });

    testWidgets('RutubeVideoPlayer with custom loading widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RutubeVideoPlayer(
              videoUrl: 'https://example.com/video.mp4',
              loadingWidget: Center(
                child: Text('Loading...'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(RutubeVideoPlayer), findsOneWidget);
    });

    testWidgets('RutubeVideoPlayer with custom error widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RutubeVideoPlayer(
              videoUrl: 'https://invalid-url.com/video.mp4',
              errorWidget: Center(
                child: Text('Error loading video'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(RutubeVideoPlayer), findsOneWidget);
    });
  });

  group('URL Parsing Tests', () {
    test('parseUrlForRutubeAndVKPlayers - Rutube video URL', () {
      const url = 'https://rutube.ru/video/1234567890abcdef/';
      final result = parseUrlForRutubeAndVKPlayers(url);
      expect(result, 'https://rutube.ru/play/embed/1234567890abcdef/');
    });

    test('parseUrlForRutubeAndVKPlayers - VK video URL', () {
      const url = 'https://vkvideo.ru/video-123456_789012345';
      final result = parseUrlForRutubeAndVKPlayers(url);
      expect(result, 'https://vkvideo.ru/video_ext.php?oid=-123456&id=789012345&hd=2');
    });

    test('parseUrlForRutubeAndVKPlayers - Already embedded Rutube URL', () {
      const url = 'https://rutube.ru/play/embed/1234567890abcdef/';
      final result = parseUrlForRutubeAndVKPlayers(url);
      expect(result, url);
    });

    test('parseUrlForRutubeAndVKPlayers - Already embedded VK URL', () {
      const url = 'https://vk.com/video_ext.php?oid=123456&id=789012345&hd=2';
      final result = parseUrlForRutubeAndVKPlayers(url);
      expect(result, url);
    });

    test('parseUrlForRutubeAndVKPlayers - Invalid URL', () {
      const url = 'https://example.com/video.mp4';
      final result = parseUrlForRutubeAndVKPlayers(url);
      expect(result, '');
    });
  });

  group('Direct Video URL Tests', () {
    test('isDirectVideoUrl - MP4 file', () {
      const url = 'https://example.com/video.mp4';
      final result = isDirectVideoUrl(url);
      expect(result, true);
    });

    test('isDirectVideoUrl - M3U8 file', () {
      const url = 'https://example.com/video.m3u8';
      final result = isDirectVideoUrl(url);
      expect(result, true);
    });

    test('isDirectVideoUrl - WebM file', () {
      const url = 'https://example.com/video.webm';
      final result = isDirectVideoUrl(url);
      expect(result, true);
    });

    test('isDirectVideoUrl - Non-video URL', () {
      const url = 'https://example.com/video.html';
      final result = isDirectVideoUrl(url);
      expect(result, false);
    });
  });
}
