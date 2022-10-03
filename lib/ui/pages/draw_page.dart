import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:qnpick/constants/constants.dart';
import 'package:qnpick/core/controllers/community_write_controller.dart';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:qnpick/ui/widgets/buttons.dart';

// class DrawPage extends StatelessWidget {
//   const DrawPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final c = CommunityWriteController.to;

//     return PainterContent(
//       onCompletePressed: (f) {},
//     );
//   }
// }

class DrawPage extends StatefulWidget {
  final Function(File) onCompletePressed;
  const DrawPage({
    Key? key,
    required this.onCompletePressed,
  }) : super(key: key);

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  FocusNode textFocusNode = FocusNode();
  late PainterController controller;
  ui.Image? backgroundImage;
  Color textPickerColor = darkPrimaryColor;
  Color linePickerColor = brightSecondaryColor;
  double eraserStrokeWidth = 5;
  double lineStrokeWidth = 5;
  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = brightSecondaryColor
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void initState() {
    super.initState();
    controller = PainterController(
      settings: PainterSettings(
        text: TextSettings(
          focusNode: textFocusNode,
          textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: darkPrimaryColor,
              fontSize: 18),
        ),
        freeStyle: const FreeStyleSettings(
          color: brightSecondaryColor,
          strokeWidth: 5,
        ),
        shape: ShapeSettings(
          paint: shapePaint,
        ),
        scale: const ScaleSettings(
          enabled: true,
          minScale: 1,
          maxScale: 5,
        ),
      ),
    );
    // Listen to focus events of the text field
    textFocusNode.addListener(onFocus);
    // Initialize background
    initBackground();
  }

  /// Fetches image from an [ImageProvider] (in this example, [NetworkImage])
  /// to use it as a background
  void initBackground() async {
    setState(() {
      controller.background = Colors.white.backgroundDrawable;
    });
  }

  /// Updates UI when the focus changes
  void onFocus() {
    setState(() {});
  }

  Widget buildDefault(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: ValueListenableBuilder<PainterControllerValue>(
              valueListenable: controller,
              builder: (context, _, child) {
                return AppBar(
                  leadingWidth: 70,
                  backgroundColor: backgroundColor,
                  leading: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Get.back(),
                      child: Row(
                        children: const [
                          Icon(Icons.arrow_back_ios_new_rounded,
                              color: darkPrimaryColor),
                          Text(
                            '뒤로',
                            style: TextStyle(
                              fontSize: 14,
                              color: darkPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  elevation: 0,
                  centerTitle: true,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          PhosphorIcons.trash,
                          color: controller.selectedObjectDrawable != null
                              ? darkPrimaryColor
                              : lightGrayColor,
                        ),
                        splashRadius: 25,
                        onPressed: controller.selectedObjectDrawable == null
                            ? null
                            : removeSelectedDrawable,
                      ),
                      // Redo action
                      IconButton(
                        icon: Icon(
                          PhosphorIcons.arrowClockwise,
                          color: controller.canRedo
                              ? darkPrimaryColor
                              : lightGrayColor,
                        ),
                        splashRadius: 25,
                        onPressed: controller.canRedo ? redo : null,
                      ),
                      // Undo action
                      IconButton(
                        icon: Icon(
                          PhosphorIcons.arrowCounterClockwise,
                          color: controller.canUndo
                              ? darkPrimaryColor
                              : lightGrayColor,
                        ),
                        splashRadius: 25,
                        onPressed: controller.canUndo ? undo : null,
                      ),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 8, 6),
                      child: TextActionButton(
                        buttonText: '완료',
                        onPressed: () async {
                          final file = await renderAndReturnImage();
                          widget.onCompletePressed(file);
                          Get.back();
                        },
                        textColor: brightPrimaryColor,
                        fontWeight: FontWeight.bold,
                        activated: controller.drawables.isBlank != true,
                        isUnderlined: false,
                      ),
                    ),
                  ],
                );
              }),
        ),
        // Generate image
        body: SafeArea(
          child: Stack(
            children: [
              backgroundImage != null
                  ?
                  // Enforces constraints
                  Positioned.fill(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio:
                              backgroundImage!.width / backgroundImage!.height,
                          child: FlutterPainter(
                            controller: controller,
                          ),
                        ),
                      ),
                    )
                  : Positioned.fill(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: FlutterPainter(
                            controller: controller,
                          ),
                        ),
                      ),
                    ),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, _, __) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 400,
                          ),
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                            color: backgroundColor.withOpacity(0.5),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (controller.freeStyleMode !=
                                  FreeStyleMode.none) ...[
                                if (controller.freeStyleMode ==
                                    FreeStyleMode.erase) ...[
                                  const Text(
                                    "지우개 설정",
                                    style: TextStyle(
                                      color: darkPrimaryColor,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "선 굵기",
                                            style: TextStyle(
                                              color: darkPrimaryColor,
                                            ),
                                          )),
                                      Expanded(
                                        flex: 3,
                                        child: Slider.adaptive(
                                            min: 2,
                                            max: 25,
                                            value: eraserStrokeWidth,
                                            onChanged: (v) {
                                              setState(() {
                                                eraserStrokeWidth = v;
                                              });
                                              setFreeStyleStrokeWidth(v);
                                            }),
                                      ),
                                    ],
                                  ),
                                  TextActionButton(
                                      buttonText: '모두 지우기',
                                      onPressed: toggleEraseAll),
                                ],
                                if (controller.freeStyleMode ==
                                    FreeStyleMode.draw) ...[
                                  const Text(
                                    "그리기 설정",
                                    style: TextStyle(
                                      color: darkPrimaryColor,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                          flex: 1,
                                          child: Text(
                                            "선 굵기",
                                            style: TextStyle(
                                              color: darkPrimaryColor,
                                            ),
                                          )),
                                      Expanded(
                                        flex: 3,
                                        child: Slider.adaptive(
                                            min: 2,
                                            max: 25,
                                            value: lineStrokeWidth,
                                            onChanged: (v) {
                                              setState(() {
                                                lineStrokeWidth = v;
                                              });
                                              setFreeStyleStrokeWidth(v);
                                            }),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "색상",
                                        style: TextStyle(
                                          color: darkPrimaryColor,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 70, right: 10),
                                        child: InkWell(
                                          onTap: () {
                                            Get.dialog(
                                              AlertDialog(
                                                content: SingleChildScrollView(
                                                  child: ColorPicker(
                                                      pickerColor:
                                                          linePickerColor,
                                                      onColorChanged: (c) {
                                                        setState(() {
                                                          linePickerColor = c;
                                                        });
                                                      }),
                                                ),
                                                actions: <Widget>[
                                                  TextActionButton(
                                                    buttonText: '취소',
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    isUnderlined: false,
                                                  ),
                                                  ElevatedButton(
                                                    child: Text('완료'),
                                                    onPressed: () {
                                                      setFreeStyleColor(
                                                          linePickerColor);
                                                      Get.back();
                                                    },
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 80,
                                            height: 24,
                                            color: controller.freeStyleColor,
                                          ),
                                        ),
                                      ),
                                      Text('< 눌러서 변경하기'),
                                      // Control free style color hue
                                    ],
                                  ),
                                ],
                              ],
                              if (textFocusNode.hasFocus) ...[
                                const Divider(),
                                const Text(
                                  "텍스트 설정",
                                  style: TextStyle(
                                    color: darkPrimaryColor,
                                  ),
                                ),
                                // Control text font size
                                Row(
                                  children: [
                                    const Expanded(
                                        flex: 1,
                                        child: Text(
                                          "글자 크기",
                                          style: TextStyle(
                                            color: darkPrimaryColor,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Slider.adaptive(
                                          min: 8,
                                          max: 96,
                                          value:
                                              controller.textStyle.fontSize ??
                                                  14,
                                          onChanged: setTextFontSize),
                                    ),
                                  ],
                                ),

                                // Control text color hue
                                Row(
                                  children: [
                                    const Text(
                                      "색상",
                                      style: TextStyle(
                                        color: darkPrimaryColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 70, right: 10),
                                      child: InkWell(
                                        onTap: () {
                                          Get.dialog(
                                            AlertDialog(
                                              content: SingleChildScrollView(
                                                child: ColorPicker(
                                                    pickerColor:
                                                        textPickerColor,
                                                    onColorChanged: (c) {
                                                      setState(() {
                                                        textPickerColor = c;
                                                      });
                                                    }),
                                              ),
                                              actions: <Widget>[
                                                TextActionButton(
                                                  buttonText: '취소',
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  isUnderlined: false,
                                                ),
                                                ElevatedButton(
                                                  child: Text('완료'),
                                                  onPressed: () {
                                                    setTextColor(
                                                        textPickerColor);
                                                    Get.back();
                                                  },
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 80,
                                          height: 24,
                                          color: controller.textStyle.color ??
                                              darkPrimaryColor,
                                        ),
                                      ),
                                    ),
                                    Text('< 눌러서 변경하기'),
                                  ],
                                ),
                              ],
                              if (controller.shapeFactory != null) ...[
                                const Divider(),
                                const Text(
                                  "도형 설정",
                                  style: TextStyle(
                                    color: darkPrimaryColor,
                                  ),
                                ),

                                // Control text color hue
                                Row(
                                  children: [
                                    const Expanded(
                                        flex: 1,
                                        child: Text(
                                          "선 굵기",
                                          style: TextStyle(
                                            color: darkPrimaryColor,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Slider.adaptive(
                                          min: 2,
                                          max: 25,
                                          value: controller
                                                  .shapePaint?.strokeWidth ??
                                              shapePaint.strokeWidth,
                                          onChanged: (value) =>
                                              setShapeFactoryPaint(
                                                  (controller.shapePaint ??
                                                          shapePaint)
                                                      .copyWith(
                                                strokeWidth: value,
                                              ))),
                                    ),
                                  ],
                                ),

                                // Control shape color hue
                                Row(
                                  children: [
                                    const Expanded(
                                        flex: 1,
                                        child: Text(
                                          "색상",
                                          style: TextStyle(
                                            color: darkPrimaryColor,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Slider.adaptive(
                                        min: 0,
                                        max: 359.99,
                                        value: HSVColor.fromColor(
                                                (controller.shapePaint ??
                                                        shapePaint)
                                                    .color)
                                            .hue,
                                        activeColor: (controller.shapePaint ??
                                                shapePaint)
                                            .color,
                                        onChanged: (hue) =>
                                            setShapeFactoryPaint(
                                          (controller.shapePaint ?? shapePaint)
                                              .copyWith(
                                            color:
                                                HSVColor.fromAHSV(1, hue, 1, 1)
                                                    .toColor(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    const Expanded(
                                        flex: 1,
                                        child: Text(
                                          "도형 채우기",
                                          style: TextStyle(
                                            color: darkPrimaryColor,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Switch(
                                            value: (controller.shapePaint ??
                                                        shapePaint)
                                                    .style ==
                                                PaintingStyle.fill,
                                            onChanged: (value) =>
                                                setShapeFactoryPaint(
                                                    (controller.shapePaint ??
                                                            shapePaint)
                                                        .copyWith(
                                                  style: value
                                                      ? PaintingStyle.fill
                                                      : PaintingStyle.stroke,
                                                ))),
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),
          child: ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, _, __) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Free-style eraser
                IconButton(
                  icon: Icon(
                    PhosphorIcons.eraser,
                    color: controller.freeStyleMode == FreeStyleMode.erase
                        ? brightSecondaryColor
                        : null,
                  ),
                  onPressed: toggleFreeStyleErase,
                ),
                // Free-style drawing
                IconButton(
                  icon: Icon(
                    PhosphorIcons.scribbleLoop,
                    color: controller.freeStyleMode == FreeStyleMode.draw
                        ? brightSecondaryColor
                        : null,
                  ),
                  onPressed: toggleFreeStyleDraw,
                ),
                // Add text
                IconButton(
                  icon: Icon(
                    PhosphorIcons.textT,
                    color: textFocusNode.hasFocus ? brightSecondaryColor : null,
                  ),
                  onPressed: () {
                    if (!textFocusNode.hasFocus) {
                      addText();
                    } else {
                      textFocusNode.unfocus();
                    }
                  },
                ),
                // Add sticker image
                // Add shapes
                if (controller.shapeFactory == null)
                  PopupMenuButton<ShapeFactory?>(
                    tooltip: "도형 추가",
                    itemBuilder: (context) => <ShapeFactory, String>{
                      LineFactory(): "선",
                      ArrowFactory(): "화살표",
                      DoubleArrowFactory(): "양방향 화살표",
                      RectangleFactory(): "직사각형",
                      OvalFactory(): "타원",
                    }
                        .entries
                        .map((e) => PopupMenuItem(
                            value: e.key,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  getShapeIcon(e.key),
                                  color: Colors.black,
                                ),
                                Text(" ${e.value}")
                              ],
                            )))
                        .toList(),
                    onSelected: selectShape,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        getShapeIcon(controller.shapeFactory),
                        color: controller.shapeFactory != null
                            ? Theme.of(context).colorScheme.secondary
                            : null,
                      ),
                    ),
                  )
                else
                  IconButton(
                    icon: Icon(
                      getShapeIcon(controller.shapeFactory),
                      color: brightSecondaryColor,
                    ),
                    onPressed: () => selectShape(null),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildDefault(context);
  }

  static IconData getShapeIcon(ShapeFactory? shapeFactory) {
    if (shapeFactory is LineFactory) return PhosphorIcons.lineSegment;
    if (shapeFactory is ArrowFactory) return PhosphorIcons.arrowUpRight;
    if (shapeFactory is DoubleArrowFactory) {
      return PhosphorIcons.arrowsHorizontal;
    }
    if (shapeFactory is RectangleFactory) return PhosphorIcons.rectangle;
    if (shapeFactory is OvalFactory) return PhosphorIcons.circle;
    return PhosphorIcons.polygon;
  }

  void undo() {
    controller.undo();
  }

  void redo() {
    controller.redo();
  }

  void toggleFreeStyleDraw() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.draw
        ? FreeStyleMode.draw
        : FreeStyleMode.none;
    setFreeStyleStrokeWidth(lineStrokeWidth);
  }

  void toggleFreeStyleErase() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.erase
        ? FreeStyleMode.erase
        : FreeStyleMode.none;
    setFreeStyleStrokeWidth(eraserStrokeWidth);
  }

  void toggleEraseAll() {
    controller.clearDrawables();
  }

  void addText() {
    if (controller.freeStyleMode != FreeStyleMode.none) {
      controller.freeStyleMode = FreeStyleMode.none;
    }
    controller.addText();
  }

  void setFreeStyleStrokeWidth(double value) {
    controller.freeStyleStrokeWidth = value;
  }

  void setFreeStyleColor(Color c) {
    controller.freeStyleColor = c;
  }

  void setTextFontSize(double size) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.textSettings = controller.textSettings.copyWith(
          textStyle:
              controller.textSettings.textStyle.copyWith(fontSize: size));
    });
  }

  void setShapeFactoryPaint(Paint paint) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.shapePaint = paint;
    });
  }

  void setTextColor(Color color) {
    controller.textStyle = controller.textStyle.copyWith(color: color);
  }

  void selectShape(ShapeFactory? factory) {
    controller.shapeFactory = factory;
  }

  void renderAndDisplayImage() {
    // if (backgroundImage == null) return;

    final imageSize = (backgroundImage == null)
        ? Size(context.width, context.height)
        : Size(backgroundImage!.width.toDouble(),
            backgroundImage!.height.toDouble());

    // Render the image
    // Returns a [ui.Image] object, convert to to byte data and then to Uint8List
    final imageFuture = controller
        .renderImage(imageSize)
        .then<Uint8List?>((ui.Image image) => image.pngBytes);

    // From here, you can write the PNG image data a file or do whatever you want with it
    // For example:
    // ```dart
    // final file = File('${(await getTemporaryDirectory()).path}/img.png');
    // await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    // ```
    // I am going to display it using Image.memory

    // Show a dialog with the image
    showDialog(
        context: context,
        builder: (context) => RenderedImageDialog(imageFuture: imageFuture));
  }

  Future<File> renderAndReturnImage() async {
    final imageSize = (backgroundImage == null)
        ? Size(context.width, context.width)
        : Size(backgroundImage!.width.toDouble(),
            backgroundImage!.height.toDouble());
    // Render the image
    // Returns a [ui.Image] object, convert to to byte data and then to Uint8List
    final imageFuture = await controller
        .renderImage(imageSize)
        .then<Uint8List?>((ui.Image image) => image.pngBytes);

    final tempDir = await getTemporaryDirectory();
    File file = await File(
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png')
        .create();
    file.writeAsBytesSync(imageFuture!);

    return file;
  }

  void removeSelectedDrawable() {
    final selectedDrawable = controller.selectedObjectDrawable;
    if (selectedDrawable != null) controller.removeDrawable(selectedDrawable);
  }

  void flipSelectedImageDrawable() {
    final imageDrawable = controller.selectedObjectDrawable;
    if (imageDrawable is! ImageDrawable) return;

    controller.replaceDrawable(
        imageDrawable, imageDrawable.copyWith(flipped: !imageDrawable.flipped));
  }
}

class RenderedImageDialog extends StatelessWidget {
  final Future<Uint8List?> imageFuture;

  const RenderedImageDialog({Key? key, required this.imageFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("이미지"),
      backgroundColor: backgroundColor,
      content: FutureBuilder<Uint8List?>(
        future: imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }
          return InteractiveViewer(
              maxScale: 10, child: Image.memory(snapshot.data!));
        },
      ),
    );
  }
}
