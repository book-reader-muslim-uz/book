import 'dart:async';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  YoutubePlayerController? _controller;
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _retryTimer;
  int _retryCount = 0;
  static const int maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<bool> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult[0] != ConnectivityResult.none;
  }

  String? _extractVideoId(String url) {
    return YoutubePlayer.convertUrlToId(url);
  }

  Future<void> _initializePlayer() async {
    if (_retryCount >= maxRetries) {
      setState(() {
        _errorMessage =
            'Failed to load video after several attempts. Please check your connection and try again.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Check connectivity first
    if (!await _checkConnectivity()) {
      setState(() {
        _errorMessage =
            'No internet connection. Please check your connection and try again.';
        _isLoading = false;
      });
      return;
    }

    try {
      // Extract video ID from URL
      final videoId = _extractVideoId(widget.videoUrl);
      if (videoId == null) {
        throw Exception('Invalid YouTube URL');
      }

      // Dispose previous controller if exists
      _controller?.dispose();

      // Initialize new controller
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          useHybridComposition: true,
          enableCaption: true,
          forceHD: false,
        ),
      );

      // Add listener for errors
      _controller!.addListener(() {
        if (_controller!.value.hasError) {
          _handlePlayerError();
        }
      });

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _retryCount = 0; // Reset retry count on successful initialization
      });
    } catch (error) {
      _handlePlayerError();
    }
  }

  void _handlePlayerError() {
    if (!mounted) return;

    _retryCount++;

    // Cancel any existing retry timer
    _retryTimer?.cancel();

    if (_retryCount < maxRetries) {
      // Exponential backoff for retries
      final backoffDuration = Duration(seconds: _retryCount * 2);

      setState(() {
        _errorMessage =
            'Loading failed. Retrying in ${backoffDuration.inSeconds} seconds...';
        _isLoading = true;
      });

      _retryTimer = Timer(backoffDuration, _retryInitialization);
    } else {
      setState(() {
        _errorMessage = 'Unable to load video. Please try again later.';
        _isLoading = false;
      });
    }
  }

  Future<void> _retryInitialization() async {
    _retryTimer?.cancel();
    await _initializePlayer();
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 16,
      left: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: _buildContent(),
            ),
            _buildBackButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Colors.white,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ],
      );
    }

    if (_errorMessage != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _retryInitialization,
            child: const Text('Try Again'),
          ),
        ],
      );
    }

    if (_controller != null) {
      return YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
        onReady: () {},
        onEnded: (YoutubeMetaData metaData) {},
      );
    }

    return const Text(
      'Something went wrong',
      style: TextStyle(color: Colors.white),
    );
  }
}
