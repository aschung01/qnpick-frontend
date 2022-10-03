import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerContainer extends StatefulWidget {
  final VideoPlayerController controller;
  final double width;
  final double height;
  const VideoPlayerContainer({
    Key? key,
    required this.controller,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<VideoPlayerContainer> createState() => _VideoPlayerContainerState();
}

class _VideoPlayerContainerState extends State<VideoPlayerContainer> {
  bool ended = false;
  bool showControls = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_checkVideo);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_checkVideo);
    super.dispose();
  }

  void _checkVideo() {
    if (mounted) {
      if (widget.controller.value.position ==
          widget.controller.value.duration) {
        setState(() {
          ended = true;
          showControls = true;
        });
      } else {
        if (ended) {
          setState(() {
            ended = false;
          });
        }
      }
    }
  }

  void _onVideoTap() {
    if (widget.controller.value.isPlaying) {
      if (!showControls) {
        setState(() {
          showControls = true;
          timer?.cancel();
          timer = Timer(const Duration(seconds: 2), () {
            if (widget.controller.value.isPlaying) {
              setState(() {
                showControls = false;
              });
            }
          });
        });
      } else {
        setState(() {
          showControls = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: widget.width,
                height: widget.height - 5,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: GestureDetector(
                    onTap: _onVideoTap,
                    child: SizedBox(
                      height: widget.controller.value.size.height,
                      width: widget.controller.value.size.width,
                      child: AspectRatio(
                        aspectRatio: widget.controller.value.aspectRatio,
                        child: VideoPlayer(widget.controller),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: min(widget.width, widget.controller.value.size.width),
                height: 5,
                child: VideoProgressIndicator(
                  widget.controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                      backgroundColor: backgroundColor,
                      bufferedColor: brightSecondaryColor.withOpacity(0.3),
                      playedColor: brightSecondaryColor),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
        if (showControls)
          Theme(
            data: Theme.of(context).copyWith(
              highlightColor: brightPrimaryColor.withOpacity(0.2),
            ),
            child: FloatingActionButton(
              heroTag: widget.controller.value.duration,
              child: () {
                if (widget.controller.value.isPlaying) {
                  return const Icon(
                    Icons.pause_rounded,
                    color: brightPrimaryColor,
                  );
                } else {
                  if (ended) {
                    return const Icon(
                      Icons.replay_rounded,
                      color: brightPrimaryColor,
                    );
                  } else {
                    return const Icon(
                      Icons.play_arrow_rounded,
                      color: brightPrimaryColor,
                    );
                  }
                }
              }(),
              splashColor: brightPrimaryColor.withOpacity(0.2),
              onPressed: () {
                if (widget.controller.value.isPlaying) {
                  widget.controller.pause();
                  setState(() {});
                } else {
                  widget.controller.play();
                  setState(() {});
                  Future.delayed(const Duration(seconds: 2), () {
                    if (widget.controller.value.isPlaying) {
                      setState(() {
                        showControls = false;
                      });
                    }
                  });
                }
              },
            ),
          ),
      ],
    );
  }
}
