# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

### Added
- Initial release of Rutube Video Player package
- Cross-platform support for web and mobile platforms
- Support for Rutube video URLs (`rutube.ru/video/...`)
- Support for VK video URLs (`vkvideo.ru/video-...`)
- Support for direct video files (`.mp4`, `.m3u8`, `.webm`)
- WebView-based player for mobile platforms
- HTML5 video player for web platform
- Customizable loading and error widgets
- Automatic URL parsing and conversion
- Aspect ratio customization
- Loading indicator support

### Features
- **RutubeVideoPlayer**: Main widget for playing videos
- **RutubeWebView**: WebView-based player for embedded videos
- **VideoPlayerWidget**: Player for direct video files
- **WebVideoPlayer**: HTML5 iframe player for web (using package:web)
- **parseUrlForRutubeAndVKPlayers**: Utility function for URL parsing

### Supported Platforms
- ✅ Web (HTML5 video player)
- ✅ Android (WebView + VideoPlayer)
- ✅ iOS (WebView + VideoPlayer)

### Dependencies
- `video_player: ^2.8.1` - For direct video file playback
- `webview_flutter: ^4.4.2` - For embedded video players

### Examples
- Complete example application in `/examples` folder
- Multiple video source examples
- Custom widget examples
