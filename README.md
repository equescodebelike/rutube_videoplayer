# Rutube Video Player

A Flutter package for playing Rutube and VK videos with cross-platform support (web and mobile).

## Features

- 🎥 **Cross-platform support**: Works on both web and mobile platforms
- 🔗 **Multiple video sources**: Supports Rutube, VK, and direct video URLs
- 📱 **Mobile optimized**: Uses WebView for embedded players on mobile
- 🌐 **Web optimized**: Uses HTML5 video player for web
- ⚡ **Easy to use**: Simple API with minimal configuration
- 🎨 **Customizable**: Custom loading and error widgets

## Supported Platforms

- ✅ Web (HTML5 video player)
- ✅ Android (WebView + VideoPlayer)
- ✅ iOS (WebView + VideoPlayer)

## Supported Video Sources

- ✅ Rutube videos (`rutube.ru/video/...`)
- ✅ VK videos (`vkvideo.ru/video-...`)
- ✅ Direct video files (`.mp4`, `.m3u8`, `.webm`)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  rutube_videoplayer: ^1.0.0
```

## Usage

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:rutube_videoplayer/rutube_videoplayer.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RutubeVideoPlayer(
      videoUrl: 'https://rutube.ru/video/1234567890abcdef/',
    );
  }
}
```

### Advanced Usage

```dart
RutubeVideoPlayer(
  videoUrl: 'https://vkvideo.ru/video-123456_789012345',
  aspectRatio: 16 / 9,
  showLoadingIndicator: true,
  loadingWidget: const Center(
    child: CircularProgressIndicator(),
  ),
  errorWidget: const Center(
    child: Text('Failed to load video'),
  ),
)
```

## API Reference

### RutubeVideoPlayer

The main widget for playing videos.

#### Parameters

- `videoUrl` (required): The URL of the video to play
- `aspectRatio` (optional): Aspect ratio for the video player (default: 16/9)
- `showLoadingIndicator` (optional): Whether to show loading indicator (default: true)
- `loadingWidget` (optional): Custom loading widget
- `errorWidget` (optional): Custom error widget

### Supported URL Formats

#### Rutube URLs
- `https://rutube.ru/video/VIDEO_ID/`
- `https://rutube.ru/play/embed/VIDEO_ID/`

#### VK URLs
- `https://vkvideo.ru/video-OWNER_ID_VIDEO_ID`
- `https://vk.com/video_ext.php?oid=OWNER_ID&id=VIDEO_ID&hd=2`

#### Direct Video URLs
- `https://example.com/video.mp4`
- `https://example.com/video.m3u8`
- `https://example.com/video.webm`

## Examples

### Rutube Video

```dart
RutubeVideoPlayer(
  videoUrl: 'https://rutube.ru/video/1234567890abcdef/',
)
```

### VK Video

```dart
RutubeVideoPlayer(
  videoUrl: 'https://vkvideo.ru/video-123456_789012345',
)
```

### Direct Video File

```dart
RutubeVideoPlayer(
  videoUrl: 'https://example.com/video.mp4',
)
```

## Platform-Specific Behavior

### Web Platform
- Uses HTML5 video player
- Supports all modern browsers
- Automatic fallback for unsupported formats

### Mobile Platforms (Android/iOS)
- Uses WebView for Rutube and VK videos
- Uses VideoPlayer for direct video files
- Optimized for mobile performance

## Dependencies

This package depends on:
- `video_player: ^2.8.1` - For direct video file playback
- `webview_flutter: ^4.4.2` - For embedded video players
- `web: ^1.1.1` - For web video player (HTML5 iframe)

## Getting Started

1. Add the dependency to your `pubspec.yaml`
2. Import the package in your Dart file
3. Use the `RutubeVideoPlayer` widget with your video URL

```dart
import 'package:rutube_videoplayer/rutube_videoplayer.dart';

// In your widget
RutubeVideoPlayer(
  videoUrl: 'your_video_url_here',
)
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Issues

If you encounter any issues, please report them on the [GitHub repository](https://github.com/yourusername/rutube_videoplayer/issues).
