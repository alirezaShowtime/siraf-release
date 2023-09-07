import 'package:flutter/material.dart';
import 'package:siraf3/extensions/string_extension.dart';

class MyImage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyImage();

  final ImageProvider image;
  final ImageFrameBuilder? frameBuilder;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final double? width;
  final double? height;
  final Color? color;
  final Animation<double>? opacity;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final Alignment alignment;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final bool isAntiAlias;
  final FilterQuality filterQuality;
  final ImageProvider? errorImage;
  final ImageProvider? loadingImage;
  final Widget? errorWidget;
  final Widget? loadingWidget;
  final BorderRadius? borderRadius;
  final Color background;
  final BoxBorder? border;
  final bool withSaveState;

  MyImage({
    super.key,
    required this.image,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low,
    this.errorImage,
    this.loadingImage,
    this.errorWidget,
    this.loadingWidget,
    this.borderRadius = BorderRadius.zero,
    this.border,
    this.background = Colors.transparent,
    this.withSaveState = false,
  });

  static Widget defaultLoadingImageWidget([double? height, double? width, String? text]) {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: !text.isFill()
          ? null
          : Text(
              text!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontFamily: "IranSansBold",
                fontSize: 11,
              ),
            ),
    );
  }

  static Widget defaultErrorImageWidget([double? height, double? width, String? text]) {
    return Container(
      height: height,
      width: width,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: !text.isFill()
          ? null
          : Text(
              text!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade400,
                fontFamily: "IranSansBold",
                fontSize: 11,
              ),
            ),
    );
  }
}

class _MyImage extends State<MyImage> with AutomaticKeepAliveClientMixin {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.background,
        borderRadius: widget.borderRadius,
        border: widget.border,
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadius,
        child: Image(
          image: widget.image,
          frameBuilder: widget.frameBuilder,
          semanticLabel: widget.semanticLabel,
          excludeFromSemantics: widget.excludeFromSemantics,
          width: widget.width,
          height: widget.height,
          color: widget.color,
          opacity: widget.opacity,
          colorBlendMode: widget.colorBlendMode,
          fit: widget.fit,
          alignment: widget.alignment,
          repeat: widget.repeat,
          centerSlice: widget.centerSlice,
          matchTextDirection: widget.matchTextDirection,
          gaplessPlayback: widget.gaplessPlayback,
          isAntiAlias: widget.isAntiAlias,
          filterQuality: widget.filterQuality,
          errorBuilder: _errorBuilder(),
          loadingBuilder: _loadingBuilder(),
        ),
      ),
    );
  }

  ImageErrorWidgetBuilder? _errorBuilder() {
    if (widget.errorBuilder != null) {
      return widget.errorBuilder!;
    }

    if (widget.errorWidget != null) {
      return (context, object, stackTrace) => widget.errorWidget!;
    }

    if (widget.errorImage != null) {
      return (context, object, stackTrace) => Image(
            image: widget.errorImage!,
            height: widget.height,
            width: widget.width,
          );
    }
    return null;
  }

  ImageLoadingBuilder? _loadingBuilder() {
    if (widget.loadingBuilder != null) {
      return widget.loadingBuilder!;
    }

    if (widget.loadingWidget != null) {
      return (context, child, progressEvent) {
        if (progressEvent == null) return child;
        return widget.loadingWidget!;
      };
    }

    if (widget.loadingImage != null) {
      return (context, child, progressEvent) {
        if (progressEvent == null) return child;
        return Image(
          image: widget.loadingImage!,
          height: widget.height,
          width: widget.width,
        );
      };
    }
    return null;
  }
  
  @override
  bool get wantKeepAlive => widget.withSaveState;
}
