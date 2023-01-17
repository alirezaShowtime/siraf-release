import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'slider.dart' as slider;

class CarouselSliderCustom extends StatefulWidget {
  List<String> images;
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
  List<slider.Slider>? sliders;
  BoxFit? imageFit;
  bool indicatorsCenterAlign;
  Function(int)? onImageTap;
  Function(int)? onPageChanged;

  CarouselSliderCustom(
      {required this.images,
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
      this.sliders,
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
          items: widget.images.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                var sliders = widget.sliders
                        ?.where((element) => element.image == imageUrl) ??
                    [];
                return GestureDetector(
                  onTap: sliders.isNotEmpty && sliders.first.link != null
                      ? () {}
                      : null,
                  child: CarouselSliderItemCustom(
                    imageUrl: imageUrl,
                    imageFit: widget.imageFit,
                    margin: widget.itemMargin,
                    borderRadius: widget.itemBorderRadius,
                    onImageTap: widget.onImageTap,
                    index: widget.images.indexOf(imageUrl),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: widget.indicatorPosition.bottom,
          left: widget.indicatorPosition.left,
          right: widget.indicatorPosition.right,
          child: Row(
            mainAxisAlignment: widget.indicatorsCenterAlign
                ? MainAxisAlignment.center
                : MainAxisAlignment.end,
            children: widget.images.asMap().entries.map((entry) {
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
  String imageUrl;
  EdgeInsets margin;
  BorderRadius borderRadius;
  Function(int)? onImageTap;
  BoxFit? imageFit;
  int index;

  CarouselSliderItemCustom(
      {required this.imageUrl,
      required this.margin,
      required this.borderRadius,
      required this.index,
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
    return widget.onImageTap == null
        ? Container(
            width: MediaQuery.of(context).size.width,
            margin: widget.margin,
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: Image(
                image: NetworkImage(
                  widget.imageUrl,
                ),
                width: MediaQuery.of(context).size.width,
                fit: widget.imageFit ?? BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                errorBuilder: (_, _1, _2) {
                  return Image(
                    image: AssetImage("assets/images/image_not_avialable.png"),
                    width: MediaQuery.of(context).size.width,
                    fit: widget.imageFit ?? BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    color: Color(0x757f8c8d),
                  );
                },
              ),
            ),
          )
        : GestureDetector(
            onTap: () => widget.onImageTap!(widget.index),
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: widget.margin,
              child: ClipRRect(
                borderRadius: widget.borderRadius,
                child: Image(
                  image: NetworkImage(
                    widget.imageUrl,
                  ),
                  width: MediaQuery.of(context).size.width,
                  fit: widget.imageFit ?? BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ),
          );
  }
}
