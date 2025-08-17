# Rutube Video Player

A Flutter package for playing Rutube and VK videos with cross-platform support

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

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Issues

If you encounter any issues, please report them on the [GitHub repository](https://github.com/equescodebelike/rutube_videoplayer/issues).
