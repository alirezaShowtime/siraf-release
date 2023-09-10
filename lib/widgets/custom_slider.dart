import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/mini_video.dart';
import 'package:video_player/video_player.dart';

import 'my_image.dart';
import 'slider.dart' as slider;
import 'slider.dart' as s;

class CarouselSliderCustom extends StatefulWidget {
  double height;
  EdgeInsets itemMargin;
  bool autoPlay;
  bool reverse;
  bool enableInfiniteScroll;
  int initialPage;
  bool enlargeCenterPage;
  BorderRadius itemBorderRadius;
  double? viewportFraction;
  Color indicatorSelectedColor;
  Color indicatorColor;
  List<slider.Slider> sliders;
  BoxFit? imageFit;
  bool indicatorsCenterAlign;
  Function(s.Slider)? onImageTap;
  Function(int)? onPageChanged;
  void Function(VideoPlayerController p1)? onStartVideo;
  bool directPlay;
  bool float;

  EdgeInsets indicatorMargin;

  Alignment indicatorAlignment;

  CarouselSliderCustom({
    Key? key,
    required this.sliders,
    required this.height,
    required this.itemMargin,
    required this.itemBorderRadius,
    this.indicatorsCenterAlign = false,
    this.onImageTap,
    this.autoPlay = true,
    this.reverse = false,
    this.imageFit,
    this.indicatorColor = Colors.black,
    this.indicatorSelectedColor = Colors.white,
    this.enableInfiniteScroll = true,
    this.initialPage = 0,
    this.enlargeCenterPage = false,
    this.directPlay = false,
    this.viewportFraction,
    this.onPageChanged,
    this.indicatorAlignment = Alignment.bottomCenter,
    this.indicatorMargin = EdgeInsets.zero,
    this.float = false,
    this.onStartVideo,
  }) : super(key: key);

  @override
  State<CarouselSliderCustom> createState() => _CarouselSliderCustomState();
}

class _CarouselSliderCustomState extends State<CarouselSliderCustom> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _current = 0;
  final CarouselController _controller = CarouselController();

  List<StreamController<bool>> pageChangeStreams = [];

  @override
  Widget build(BuildContext context) {
    pageChangeStreams = widget.sliders.map<StreamController<bool>>((e) => StreamController<bool>.broadcast()).toList();

    if (widget.float)
      return Stack(
        children: [
          _content(),
          if (widget.sliders.length > 1)
            // Align(
            //   alignment: widget.indicatorAlignment,
            //   child: Padding(
            //     padding: widget.indicatorMargin,
            //     child: _indicator(),
            //   ),
            // ),
          Positioned(
            child: _indicator(),
            left: 0,
            right: 0,
            bottom: widget.indicatorMargin.bottom,
          ),
        ],
      );

    return Column(
      children: [
        _content(),
        if (widget.sliders.length > 1) _indicator(),
      ],
    );
  }

  Widget _content() {
    return ColoredBox(
      color: App.theme.backgroundColor,
      child: CarouselSlider(
        options: CarouselOptions(
          height: widget.height,
          viewportFraction: widget.viewportFraction ?? 0.8,
          initialPage: widget.initialPage,
          enableInfiniteScroll: widget.enableInfiniteScroll,
          reverse: widget.reverse,
          autoPlay: widget.autoPlay,
          scrollPhysics: widget.sliders.length > 1 ? null : NeverScrollableScrollPhysics(),
          enlargeCenterPage: widget.enlargeCenterPage,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
              pageChangeStreams.forEach((element) {
                element.add(true);
              });
            });
            if (widget.onPageChanged != null) {
              widget.onPageChanged!(index);
            }
          },
        ),
        carouselController: _controller,
        items: widget.sliders.map((image) {
          return Builder(
            builder: (BuildContext context) {
              var sliders = widget.sliders.where((element) => image.image == element.image);
              return GestureDetector(
                onTap: () => widget.onImageTap?.call(image),
                child: CarouselSliderItemCustom(
                  pageChangeStream: pageChangeStreams[widget.sliders.indexOf(image)],
                  image: image.image,
                  slide: image,
                  imageFit: widget.imageFit,
                  margin: widget.itemMargin,
                  borderRadius: widget.itemBorderRadius,
                  onImageTap: widget.onImageTap,
                  index: widget.sliders.indexOf(image),
                  directPlay: widget.directPlay,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _indicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: widget.indicatorsCenterAlign ? MainAxisAlignment.center : MainAxisAlignment.end,
        children: widget.sliders.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 6.0,
              height: 6.0,
              margin: EdgeInsets.symmetric(horizontal: 2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == entry.key ? widget.indicatorSelectedColor : widget.indicatorColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CarouselSliderItemCustom extends StatefulWidget {
  ImageProvider<Object> image;
  EdgeInsets margin;
  BorderRadius borderRadius;
  Function(s.Slider)? onImageTap;
  BoxFit? imageFit;
  int index;
  s.Slider slide;
  StreamController<bool> pageChangeStream;
  Function(VideoPlayerController)? onStartVideo;
  bool directPlay;

  CarouselSliderItemCustom({
    required this.image,
    required this.margin,
    required this.borderRadius,
    required this.index,
    required this.slide,
    required this.pageChangeStream,
    this.onImageTap,
    this.onStartVideo,
    this.imageFit,
    this.directPlay = false,
    Key? key,
  }) : super(key: key);

  @override
  State<CarouselSliderItemCustom> createState() => _CarouselSliderItemCustomState();
}

class _CarouselSliderItemCustomState extends State<CarouselSliderItemCustom> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    super.initState();

    widget.pageChangeStream.stream.listen((bool event) {
      if (event) videoKey.currentState?.getVideoController().pause();
    });
  }

  final videoKey = new GlobalKey<MiniVideoState>();

  @override
  Widget build(BuildContext context) {
    if (widget.slide.type == s.SliderType.image) {
      return _buildImage();
    }
    if (widget.slide.type == s.SliderType.video) {
      return _buildVideo();
    }
    if (widget.slide.type == s.SliderType.virtual_tour) {
      return _buildTour();
    }

    return Container();
  }

  _buildImage() {
    return GestureDetector(
      onTap: widget.onImageTap != null ? () => widget.onImageTap!(widget.slide) : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: widget.margin,
        child: MyImage(
          image: widget.image,
          borderRadius: widget.borderRadius,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: widget.imageFit ?? BoxFit.cover,
          loadingWidget: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: App.theme.backgroundColor,
            alignment: Alignment.center,
            child: Text(
              "درحال بارگذاری",
              style: TextStyle(
                fontSize: 11,
                fontFamily: "IranSansBold",
                color: App.theme.tooltipTheme.textStyle?.color,
              ),
            ),
          ),
          errorWidget: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.shade50,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 35, color: App.theme.tooltipTheme.textStyle?.color),
                Text(
                  "خطا!!",
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: "IranSansBold",
                    color: App.theme.tooltipTheme.textStyle?.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildVideo() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: widget.margin,
      alignment: Alignment.center,
      child: MiniVideo(
        thumbnail: widget.image,
        videoUrl: widget.slide.link!,
        key: videoKey,
        onStartVideo: widget.onStartVideo,
        directPlay: widget.directPlay,
      ),
    );
  }

  _buildTour() {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onImageTap != null ? () => widget.onImageTap!(widget.slide) : null,
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: widget.margin,
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: m.Image(
                image: widget.image,
                width: MediaQuery.of(context).size.width,
                fit: widget.imageFit ?? BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                errorBuilder: (_, _1, _2) {
                  return m.Image(
                    image: AssetImage("assets/images/image_not_avialable.png"),
                    width: MediaQuery.of(context).size.width,
                    fit: widget.imageFit ?? BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    color: Color(0x757f8c8d),
                  );
                },
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: widget.onImageTap != null ? () => widget.onImageTap!(widget.slide) : null,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                m.Image(
                  image: AssetImage("assets/images/virtual_tour.png"),
                  color: Colors.white,
                  width: 80,
                  height: 80,
                ),
                Text(
                  "جهت نمایش تور مجازی کلیک کنید",
                  style: TextStyle(fontSize: 13, color: App.theme.canvasColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
