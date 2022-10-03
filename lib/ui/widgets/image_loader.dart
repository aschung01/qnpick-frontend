import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/services/amplify_service.dart';
import 'package:qnpick/ui/widgets/loading_blocks.dart';
import 'package:qnpick/ui/widgets/video_player_container.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

enum ImageType { preview, miniPreview, whole }

class ImageLoader extends StatefulWidget {
  final String mediaKey;
  final int mediaType;
  final ImageType imageType;
  final Color background;
  final double? height;
  final double? width;
  final BoxFit fit;
  const ImageLoader({
    Key? key,
    required this.mediaKey,
    required this.mediaType,
    this.imageType = ImageType.miniPreview,
    this.background = Colors.transparent,
    this.height = 200,
    this.width,
    this.fit = BoxFit.scaleDown,
  }) : super(key: key);

  @override
  State<ImageLoader> createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  bool loading = true;
  String url = '';
  int retryNum = 0;
  VideoPlayerController? videoPlayerController;

  Future<void> _getImageUrl() async {
    String _url = await AmplifyService.getFileUrl(widget.mediaKey);

    if (mounted) {
      setState(() {
        loading = false;
        url = _url;
        if (widget.mediaType == 1) {
          videoPlayerController = VideoPlayerController.network(_url);
        }
      });
      if (widget.mediaType == 1) {
        await videoPlayerController!.initialize();
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (url == '') {
      if (mounted) {
        _getImageUrl();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    // videoPlayerController?.removeListener(_pauseVideoIfNotCurrent);
    videoPlayerController?.pause();
    videoPlayerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: () {
        if (widget.imageType == ImageType.miniPreview) {
          return BorderRadius.circular(5);
        } else if (widget.imageType == ImageType.preview) {
          return BorderRadius.circular(20);
        } else {
          if (widget.mediaType == 0) {
            return BorderRadius.circular(20);
          } else {
            return BorderRadius.zero;
          }
        }
      }(),
      child: loading ||
              (widget.mediaType == 1 &&
                  !videoPlayerController!.value.isInitialized)
          ? Shimmer.fromColors(
              baseColor: deepGrayColor.withOpacity(0.2),
              highlightColor: Colors.white.withOpacity(0.1),
              child: DecoratedBox(
                decoration: const BoxDecoration(color: deepGrayColor),
                child: SizedBox(
                  height: widget.height ?? 200,
                  width: widget.width ?? context.width - 60,
                ),
              ),
            )
          : DecoratedBox(
              decoration: BoxDecoration(
                color: widget.background,
                borderRadius: () {
                  if (widget.imageType == ImageType.miniPreview) {
                    return const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    );
                  } else if (widget.imageType == ImageType.preview) {
                    return BorderRadius.circular(20);
                  } else {
                    if (widget.mediaType == 0) {
                      return BorderRadius.circular(20);
                    } else {
                      return BorderRadius.zero;
                    }
                  }
                }(),
              ),
              child: widget.mediaType == 0
                  ? CachedNetworkImage(
                      imageUrl: url,
                      cacheKey: url,
                      fit: widget.fit,
                      height: widget.height ?? 200,
                      width: widget.width ?? context.width - 60,
                      fadeInDuration: const Duration(milliseconds: 200),
                      placeholder: ((context, url) => LoadingBlock(
                            height: widget.height ?? 200,
                            width: widget.width ?? context.width - 60,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          )),
                      errorWidget: (context, url, error) {
                        if (retryNum < 3) {
                          _getImageUrl();
                          if (mounted) {
                            setState(() {
                              retryNum++;
                              loading = false;
                            });
                          }
                        }
                        print(error);
                        return GestureDetector(
                          onTap: _getImageUrl,
                          child: Column(
                            children: const [
                              Icon(Icons.error_rounded),
                              Text('오류가 발생했습니다.\n잠시 후 다시 시도해 주세요'),
                            ],
                          ),
                        );
                      })
                  : SizedBox(
                      height: widget.height ?? 200,
                      width: widget.width ?? context.width - 60,
                      child: widget.imageType == ImageType.whole
                          ? VideoPlayerContainer(
                              width: widget.width ?? context.width - 60,
                              height: widget.height ?? 200,
                              controller: videoPlayerController!,
                            )
                          : AspectRatio(
                              aspectRatio:
                                  videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(
                                videoPlayerController!,
                              ),
                            ),
                    ),
            ),
    );
  }
}
