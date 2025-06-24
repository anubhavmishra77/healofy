import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SimpleVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final double? height;
  final double? width;
  final bool isCircular;
  final bool shouldPlay;
  final VoidCallback? onVisibilityChanged;

  const SimpleVideoPlayer({
    Key? key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.height,
    this.width,
    this.isCircular = false,
    this.shouldPlay = true,
    this.onVisibilityChanged,
  }) : super(key: key);

  @override
  State<SimpleVideoPlayer> createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideo();
    });
  }

  @override
  void didUpdateWidget(SimpleVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.shouldPlay != widget.shouldPlay) {
      _handlePlaybackControl();
    }
  }

  void _handlePlaybackControl() {
    if (_controller != null && _controller!.value.isInitialized) {
      if (widget.shouldPlay && !_controller!.value.isPlaying) {
        _controller!.play();
      } else if (!widget.shouldPlay && _controller!.value.isPlaying) {
        _controller!.pause();
      }
    }
  }

  int _retryAttempt = 0;
  final int _maxRetries = 3;

  void _initializeVideo() async {
    try {
      if (_retryAttempt == 0) {
        _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
        );
      } else if (_retryAttempt == 1) {
        _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
          httpHeaders: {
            'User-Agent':
                'Mozilla/5.0 (Linux; Android 10; SM-G973F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
            'Accept': 'video/mp4,video/webm,video/*,*/*;q=0.9',
            'Accept-Encoding': 'identity',
            'Connection': 'keep-alive',
            'Cache-Control': 'no-cache',
          },
        );
      } else {
        _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.videoUrl),
          formatHint: VideoFormat.other,
          httpHeaders: {
            'User-Agent': 'VideoPlayer/1.0',
            'Accept': '*/*',
          },
        );
      }

      _controller!.addListener(() {
        if (mounted) {
          if (_controller!.value.isInitialized &&
              !_controller!.value.isPlaying &&
              !_controller!.value.hasError &&
              _controller!.value.position == Duration.zero) {
            _controller!.play();
          }

          setState(() {});
        }
      });

      await _controller!.initialize();

      if (mounted && _controller!.value.isInitialized) {
        _controller!.setLooping(true);
        _controller!.setVolume(0.0);

        if (widget.shouldPlay) {
          await _controller!.play();
        }

        setState(() {
          _isInitialized = true;
          _isLoading = false;
          _hasError = false;
          _retryAttempt = 0;
        });
      } else {
        throw Exception('Video controller not initialized');
      }
    } catch (error) {
      if (_retryAttempt < _maxRetries - 1) {
        _retryAttempt++;
        await Future.delayed(const Duration(seconds: 1));
        _initializeVideo();
      } else {
        if (mounted) {
          setState(() {
            _hasError = true;
            _isLoading = false;
            _errorMessage = 'Failed to load video: ${error.toString()}';
          });
        }
      }
    }
  }

  void _ensureVideoPlaying() {
    if (_controller != null &&
        _controller!.value.isInitialized &&
        !_controller!.value.isPlaying &&
        !_controller!.value.hasError) {
      _controller!.play();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final containerHeight = widget.height ?? 300.0;
    final containerWidth = widget.width ?? double.infinity;

    return Container(
      height: containerHeight,
      width: containerWidth,
      decoration: widget.isCircular
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
      child: ClipRRect(
        borderRadius: widget.isCircular
            ? BorderRadius.circular(containerHeight / 2)
            : BorderRadius.circular(12),
        child: GestureDetector(
          onTap: () {
            _ensureVideoPlaying();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isInitialized && _controller != null && !_hasError)
                AspectRatio(
                  aspectRatio:
                      widget.isCircular ? 1.0 : _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
              else if (_hasError)
                _buildErrorWidget()
              else if (_isLoading)
                _buildLoadingWidget()
              else
                _buildPlaceholder(),
              if (_hasError || (!_isInitialized && !_isLoading))
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _hasError = false;
                      _isLoading = true;
                      _isInitialized = false;
                      _retryAttempt = 0;
                    });
                    _initializeVideo();
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _hasError ? Icons.refresh : Icons.play_arrow,
                      color: Colors.black87,
                      size: 30,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    if (widget.thumbnailUrl != null) {
      return Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.thumbnailUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.video_library, size: 50),
            ),
          ),
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      );
    } else {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[400],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 50,
          ),
          const SizedBox(height: 8),
          const Text(
            'Video Error',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _errorMessage,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    if (widget.thumbnailUrl != null) {
      return CachedNetworkImage(
        imageUrl: widget.thumbnailUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: const Icon(Icons.video_library, size: 50),
        ),
      );
    } else {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.video_library, size: 50),
        ),
      );
    }
  }
}
