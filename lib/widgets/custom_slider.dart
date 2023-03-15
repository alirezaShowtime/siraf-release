import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file_detail.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/mini_video.dart';
import 'slider.dart' as slider;
import 'package:flutter/material.dart' as m;
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
  EdgeInsets indicatorPosition;
  List<slider.Slider> sliders;
  BoxFit? imageFit;
  bool indicatorsCenterAlign;
  Function(s.Slider)? onImageTap;
  Function(int)? onPageChanged;

  CarouselSliderCustom(
      {required this.sliders,
      required this.height,
      required this.itemMargin,
      required this.indicatorPosition,
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
      this.viewportFraction,
      this.onPageChanged,
      Key? key})
      : super(key: key);

  @override
  State<CarouselSliderCustom> createState() => _CarouselSliderCustomState();
}

class _CarouselSliderCustomState extends State<CarouselSliderCustom> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: widget.height,
            viewportFraction: widget.viewportFraction ?? 0.8,
            initialPage: widget.initialPage,
            enableInfiniteScroll: widget.enableInfiniteScroll,
            reverse: widget.reverse,
            autoPlay: widget.autoPlay,
            scrollPhysics: widget.sliders.length > 1
                ? null
                : NeverScrollableScrollPhysics(),
            enlargeCenterPage: widget.enlargeCenterPage,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
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
                var sliders = widget.sliders
                    .where((element) => image.image == element.image);
                return GestureDetector(
                  onTap: sliders.isNotEmpty && sliders.first.link != null
                      ? () {}
                      : null,
                  child: CarouselSliderItemCustom(
                    image: image.image,
                    slide: image,
                    imageFit: widget.imageFit,
                    margin: widget.itemMargin,
                    borderRadius: widget.itemBorderRadius,
                    onImageTap: widget.onImageTap,
                    index: widget.sliders.indexOf(image),
                  ),
                );
              },
            );
          }).toList(),
        ),
        if (widget.sliders.length > 1)
          Positioned(
            bottom: widget.indicatorPosition.bottom,
            left: widget.indicatorPosition.left,
            right: widget.indicatorPosition.right,
            child: Row(
              mainAxisAlignment: widget.indicatorsCenterAlign
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.end,
              children: widget.sliders.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 6.0,
                    height: 6.0,
                    margin: EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == entry.key
                          ? widget.indicatorSelectedColor
                          : widget.indicatorColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
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

  CarouselSliderItemCustom(
      {required this.image,
      required this.margin,
      required this.borderRadius,
      required this.index,
      required this.slide,
      this.onImageTap,
      this.imageFit,
      Key? key})
      : super(key: key);

  @override
  State<CarouselSliderItemCustom> createState() =>
      _CarouselSliderItemCustomState();
}

class _CarouselSliderItemCustomState extends State<CarouselSliderItemCustom> {
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
      onTap: widget.onImageTap != null
          ? () {
              widget.onImageTap!(widget.slide);
            }
          : null,
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
                image: AssetImage(IMAGE_NOT_AVAILABLE),
                width: MediaQuery.of(context).size.width,
                fit: widget.imageFit ?? BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                color: Color(0x757f8c8d),
              );
            },
          ),
        ),
      ),
    );
  }

  _buildVideo() {
    return MiniVideo(thumbnail: widget.image, videoUrl: widget.slide.link!);
  }

  _buildTour() {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onImageTap != null
              ? () {
                  widget.onImageTap!(widget.slide);
                }
              : null,
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
                    image: AssetImage(IMAGE_NOT_AVAILABLE),
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
          onTap: widget.onImageTap != null
              ? () {
                  widget.onImageTap!(widget.slide);
                }
              : null,
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
                  style: TextStyle(fontSize: 13, color: Themes.textLight),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
