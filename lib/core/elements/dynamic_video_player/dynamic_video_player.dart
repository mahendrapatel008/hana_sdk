import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dynamic_video_player_model.dart'; // Adjust the import based on your file structure

class DynamicVideoPlayer extends StatefulWidget {
  final DynamicVideoPlayerModel model;
  final FormController formController;

  const DynamicVideoPlayer({
    super.key,
    required this.model,
    required this.formController,
  });

  @override
  State<DynamicVideoPlayer> createState() => _DynamicVideoPlayerState();
}

class _DynamicVideoPlayerState extends State<DynamicVideoPlayer> {
  late VideoPlayerController _videoController;
  late YoutubePlayerController _youtubeController;
  bool _isInitialized = false;
  bool _isYouTubeVideo = false;

  @override
  void initState() {
    super.initState();
  }

  void _initStata(String videoUrl) {
    _isYouTubeVideo = isYouTubeVideoUrl(videoUrl);

    if (_isYouTubeVideo) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(videoUrl)!,
        flags: YoutubePlayerFlags(
          autoPlay: widget.model.autoPlay ?? false,
          loop: widget.model.looping ?? false,
        ),
      );
    } else {
      _videoController = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          setState(() => _isInitialized = true);
          if (widget.model.autoPlay ?? false) {
            _videoController.play();
          }
          _videoController.setLooping(widget.model.looping ?? false);
        });
    }
  }

  bool isYouTubeVideoUrl(String url) {
    return url.contains("youtube.com") || url.contains("youtu.be");
  }

  @override
  void dispose() {
    if (_isYouTubeVideo) {
      _youtubeController.dispose();
    } else {
      _videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: resolveDynamicValue(
            widget.model.dataKey, widget.model.videoUrl, widget.formController),
        builder: (context, snapshot) {
          final resolvedText = snapshot.data ?? widget.model.videoUrl ?? '...';

          _initStata(resolvedText);
          return Center(
            child: _isYouTubeVideo
                ? YoutubePlayer(
                    controller: _youtubeController,
                    showVideoProgressIndicator: true,
                  )
                : _isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      )
                    : const CircularProgressIndicator(),
          );
        });
  }
}
