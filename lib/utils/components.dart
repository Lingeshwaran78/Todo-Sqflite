import 'package:flutter/material.dart';

class Components {
  static final Components _components = Components._internal();

  factory Components() {
    return _components;
  }

  Components._internal();
  static logger(dynamic text) {
    debugPrint(text.toString());
  }

  static loggerStackTrace(dynamic e, StackTrace stackTrace) {
    debugPrint('Error: $e ::: stackTrace: $stackTrace');
  }

  static InputDecoration textFieldDecoration({
    String? hintText,
  }) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      hintText: hintText,
    );
  }

  static SizedBox sizedBoxHeight(double height) {
    return SizedBox(height: height);
  }

  static SizedBox sizedBoxWidth(double width) {
    return SizedBox(width: width);
  }
}

class ShrinkingButton extends StatefulWidget {
  final String? text;
  final VoidCallback? onTap;
  final Color buttonColor;
  final Color textColor;
  final double textSize;
  final FontWeight fontWeight;
  final double buttonHeight;
  final double borderWidth;
  final Widget? child;
  final double borderRadiusCircular;
  final double horizontalPaddingForText;
  final double verticalPaddingForText;
  final Color buttonBorderColor;
  final bool needBoxShadow;
  final bool? progress;
  final Color? progressColor;
  const ShrinkingButton({
    super.key,
    this.buttonColor = const Color(0xFF37003C),
    this.text,
    this.textColor = Colors.white,
    this.textSize = 14,
    this.fontWeight = FontWeight.w700,
    this.buttonHeight = 45,
    this.borderWidth = 0.1,
    this.child,
    this.borderRadiusCircular = 8,
    this.horizontalPaddingForText = 0,
    this.verticalPaddingForText = 0,
    this.buttonBorderColor = Colors.transparent,
    this.onTap,
    this.needBoxShadow = false,
    this.progress = false,
    this.progressColor = const Color(0xFF000000),
  });

  @override
  _ShrinkingButtonState createState() => _ShrinkingButtonState();
}

class _ShrinkingButtonState extends State<ShrinkingButton>
    with SingleTickerProviderStateMixin {
  static const clickAnimationDurationMillis = 100;

  double _scaleTransformValue = 1;

  // needed for the "click" tap effect
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: clickAnimationDurationMillis),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() {
        setState(() => _scaleTransformValue = 1 - animationController.value);
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _shrinkButtonSize() {
    animationController.forward();
  }

  void _restoreButtonSize() {
    Future.delayed(
      const Duration(milliseconds: clickAnimationDurationMillis),
      () => animationController.reverse(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        _shrinkButtonSize();
        _restoreButtonSize();
      },
      onTapDown: (_) => _shrinkButtonSize(),
      onTapCancel: _restoreButtonSize,
      child: Transform.scale(
        scale: _scaleTransformValue,
        child: Container(
          height: widget.buttonHeight,
          decoration: BoxDecoration(
            color: widget.buttonColor,
            borderRadius: BorderRadius.circular(widget.borderRadiusCircular),
            border: Border.all(
                width: widget.borderWidth, color: widget.buttonBorderColor),
            boxShadow: widget.needBoxShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: widget.progress! == true
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CircularProgressIndicator(
                        color: widget.progressColor,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: widget.child ??
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: widget.horizontalPaddingForText,
                          vertical: widget.verticalPaddingForText,
                        ),
                        child: Text(
                          widget.text ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: widget.textSize,
                            fontWeight: widget.fontWeight,
                          ),
                        ),
                      ),
                ),
        ),
      ),

      // Transform.scale(
      //   scale: _scaleTransformValue,
      //   child: Container(
      //     height: widget.buttonHeight,
      //     decoration: BoxDecoration(
      //         color: widget.buttonColor,
      //         borderRadius: BorderRadius.circular(widget.borderRadiusCircular),
      //         border: Border.all(color: widget.buttonBorderColor)),
      //     child: Center(
      //       child: widget.child ??
      //           Padding(
      //             padding: EdgeInsets.symmetric(
      //                 horizontal: widget.horizontalPaddingForText,
      //                 vertical: widget.verticalPaddingForText),
      //             child: Text(
      //               widget.text ?? "",
      //               style: TextStyle(
      //                 color: widget.textColor,
      //                 fontSize: widget.textSize,
      //                 fontWeight: widget.fontWeight,
      //               ),
      //             ),
      //           ),
      //     ),
      //   ),
      // ),
    );
  }
}
