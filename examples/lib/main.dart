import 'package:flutter/material.dart';
import 'package:rutube_videoplayer/rutube_videoplayer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutube Video Player Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const VideoPlayerExample(),
    );
  }
}

class VideoPlayerExample extends StatefulWidget {
  const VideoPlayerExample({super.key});

  @override
  State<VideoPlayerExample> createState() => _VideoPlayerExampleState();
}

class _VideoPlayerExampleState extends State<VideoPlayerExample> {
  final List<VideoExample> _videoExamples = [
    VideoExample(
      title: 'Rutube Video',
      url: 'https://rutube.ru/video/9345f034c87f70acf921f5f22a7506ac/?&utm_source=embed&utm_medium=referral&utm_campaign=logo&utm_content=9345f034c87f70acf921f5f22a7506ac&utm_term=yastatic.net%2F&referrer=appmetrica_tracking_id%3D1037600761300671389%26ym_tracking_id%3D6783795416800935868',
      description: 'Real Rutube video example',
    ),
    VideoExample(
      title: 'VK Video',
      url: 'https://vkvideo.ru/video-110135406_456243606',
      description: 'Real VK video example',
    ),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Rutube Video Player Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Video Player
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: RutubeVideoPlayer(
                    videoUrl: _videoExamples[_selectedIndex].url,
                    showLoadingIndicator: true,
                    loadingWidget: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: const Center(
                      child: Text('Failed to load video'),
                    ),
                  ),
                ),
              ),
            ),
            
            // Video Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _videoExamples[_selectedIndex].title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _videoExamples[_selectedIndex].description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'URL: ${_videoExamples[_selectedIndex].url}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Video Selection
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: _videoExamples.length,
              itemBuilder: (context, index) {
                final example = _videoExamples[index];
                return Card(
                  child: ListTile(
                    title: Text(example.title),
                    subtitle: Text(example.description),
                    trailing: _selectedIndex == index
                        ? const Icon(Icons.play_arrow, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VideoExample {
  final String title;
  final String url;
  final String description;

  VideoExample({
    required this.title,
    required this.url,
    required this.description,
  });
} 