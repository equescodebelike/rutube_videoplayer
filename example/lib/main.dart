import 'package:flutter/material.dart';
import 'package:rutube_videoplayer/rutube_videoplayer.dart';

void main() {
  runApp(const MyApp());
}

/// Link Examples
/// 'https://vkvideo.ru/video_ext.php?oid=-110135406&id=456243606&hd=2'
/// Parse from 'https://vkvideo.ru/video-110135406_456243606'
/// 'https://rutube.ru/play/embed/9345f034c87f70acf921f5f22a7506ac/'
/// Parse from 'https://rutube.ru/video/9345f034c87f70acf921f5f22a7506ac/?r=wd'

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Rutube Video Player')),
        body: ListView(
          padding: EdgeInsets.all(50),
          children: [
            RutubeVideoPlayer(
              videoUrl:
                  'https://rutube.ru/video/9345f034c87f70acf921f5f22a7506ac/?&utm_source=embed&utm_medium=referral&utm_campaign=logo&utm_content=9345f034c87f70acf921f5f22a7506ac&utm_term=yastatic.net%2F&referrer=appmetrica_tracking_id%3D1037600761300671389%26ym_tracking_id%3D6783795416800935868',
            ),
            SizedBox(
              height: 50,
            ),
            RutubeVideoPlayer(
              videoUrl: 'https://vkvideo.ru/video-110135406_456243606',
            ),
          ],
        ),
      ),
    );
  }
}
