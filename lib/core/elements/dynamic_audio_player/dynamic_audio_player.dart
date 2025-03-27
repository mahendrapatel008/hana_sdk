import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hana_sdk/core/controllers/form_controller.dart';
import 'package:hana_sdk/core/elements/dynamic_audio_player/dynamic_audio_player_model.dart';
import 'package:hana_sdk/core/utils/utils_data.dart';

class DynamicAudioPlayer extends StatefulWidget {
  final DynamicAudioPlayerModel controller;
  final FormController formController;

  const DynamicAudioPlayer({
    super.key,
    required this.controller,
    required this.formController,
  });

  @override
  State<DynamicAudioPlayer> createState() => _DynamicAudioPlayerState();
}

class _DynamicAudioPlayerState extends State<DynamicAudioPlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isAudioCompleted = false;
  Duration _audioDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  String _errorMessage = '';

  @override
  void initState() {
    widget.formController.saveFieldName(widget.controller.name);
    super.initState();
  }

  void _initState() {
    // Set listeners for audio completion and duration/position changes
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isAudioCompleted = true;
        setState(() {
          _isPlaying = false;
        });
        // widget.controller.setIsAudioOver(isPlayed: true);
        _errorMessage = ''; // Clear any error message if the audio completes
      });
      // widget.changeListener(); // Notify that the prerequisite condition is met
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _audioDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  void _togglePlayPause(String audioUrl) {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource(audioUrl));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: resolveDynamicValue(widget.controller.dataKey,
            widget.controller.audioUrl, widget.formController),
        builder: (context, snapshot) {
          final resolvedText = snapshot.data ?? widget.controller.audioUrl;
          _initState();
          // Clamp the current position between min (0.0) and max (audio duration)
          double sliderValue = _currentPosition.inSeconds.toDouble().clamp(
              0.0, _audioDuration.inSeconds.toDouble()); // Ensure valid range

          return FormField<bool>(
            validator: (value) {
              if (widget.controller.required && !_isAudioCompleted) {
                return 'Audio should be played before proceeding.';
              }
              return null;
            },
            builder: (field) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: resolvedText != null && resolvedText.isNotEmpty
                          ? () => _togglePlayPause(resolvedText)
                          : null, // Disable button if the URL is invalid
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          inactiveTrackColor:
                              widget.controller.inactiveTrackColor ??
                                  Colors.grey[300],
                          activeTrackColor:
                              widget.controller.activeTrackColor ??
                                  Colors.black,
                          thumbColor:
                              widget.controller.thumbColor ?? Colors.black,
                          trackHeight: widget.controller.trackHeight ?? 4.0,
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius:
                                  widget.controller.enabledThumbRadius ?? 10.0),
                        ),
                        child: Slider(
                          value: sliderValue,
                          min: 0.0,
                          max: _audioDuration.inSeconds.toDouble(),
                          onChanged: widget.controller.canScrub
                              ? (value) {
                                  final newPosition =
                                      Duration(seconds: value.toInt());
                                  _audioPlayer.seek(newPosition);
                                }
                              : null, // Disable scrubbing if canScrub is false
                        ),
                      ),
                    ),
                  ],
                ),

                // Validation error message (if any)
                if (_errorMessage.isNotEmpty || field.errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      field.errorText ?? _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                // Remaining time
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _formatDuration(_audioDuration - _currentPosition),
                      style: TextStyle(
                          color: Colors
                              .grey[500]), // Light grey for remaining time
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
