import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:siraf3/bloc/post_bookmark_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/post.dart';
import 'package:siraf3/screens/image_view_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/custom_slider.dart';
import 'package:siraf3/widgets/slider.dart' as s;
import 'package:video_player/video_player.dart';

import 'package:siraf3/main.dart';

class PostItem extends StatefulWidget {
  Post post;
  Function(VideoPlayerController)? onStartVideo;

  PostItem({required this.post, this.onStartVideo, super.key});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<String> images = [];

  List<String> videos = [];

  String description = "";

  String summary = "";

  bool showSummary = true;

  PostBookmarkBloc postBookmarkBloc = PostBookmarkBloc();

  bool isBookmark = false;

  @override
  void initState() {
    super.initState();

    setData();

    postBookmarkBloc.stream.listen((event) {
      if (event is PostBookmarkLoadingState) {
        loadingDialog(context: context, showMessage: false);
      } else if (event is PostBookmarkErrorState) {
        dismissDialog(loadingDialogContext);

        var message = jDecode(event.response.body)['message'] as String?;

        errorDialog(context: context, message: message);
      } else if (event is PostBookmarkSuccessState) {
        dismissDialog(loadingDialogContext);

        setState(() {
          isBookmark = event.bookmark;
        });
      }
    });
  }

  setData() {
    setState(() {
      description = widget.post.description ?? "";

      summary = description.substring(0, description.length > 120 ? 120 : description.length);

      isBookmark = (widget.post.isBookmark ?? 0) == 1 ? true : false;

      images = widget.post.images?.where((e) => e.path != null).map<String>((e) => e.path!).toList() ?? [];
      videos = widget.post.videos?.where((e) => e.path != null).map<String>((e) => e.path!).toList() ?? [];
    });
  }

  double postItemHeight = 250;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.post.images.isNotNullOrEmpty() && !widget.post.videos.isNotNullOrEmpty())
            Container(
              padding: EdgeInsets.only(bottom: 15),
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: App.theme.backgroundColor,
                image: DecorationImage(image: AssetImage("assets/images/image_not_avialable.png"), alignment: Alignment.center),
              ),
            ),
          if (widget.post.images.isNotNullOrEmpty() || widget.post.videos.isNotNullOrEmpty())
            CarouselSliderCustom(
              sliders: images
                      .map<s.Slider>(
                        (e) => s.Slider(
                          image: NetworkImage(e),
                          type: s.SliderType.image,
                          link: e,
                        ),
                      )
                      .toList() +
                  videos
                      .map<s.Slider>(
                        (e) => s.Slider(
                          image: NetworkImage(e),
                          type: s.SliderType.video,
                          link: e,
                        ),
                      )
                      .toList(),
              height: postItemHeight,
              autoPlay: false,
              indicatorsCenterAlign: true,
              viewportFraction: 1.0,
              itemMargin: EdgeInsets.only(bottom: 5),
              float: true,
              indicatorMargin: EdgeInsets.only(left: 0, right: 0, bottom: 18),
              itemBorderRadius: BorderRadius.zero,
              imageFit: BoxFit.fitHeight,
              indicatorSelectedColor: App.theme.primaryColor,
              indicatorColor: Colors.grey,
              onStartVideo: widget.onStartVideo,
              onImageTap: (slide) {
                var urls = <String>[];
                if (widget.post.images.isFill()) {
                  urls = widget.post.images!.map((e) => e.path!).toList();
                }

                push(context, ImageViewScreen(imageUrls: urls, title: widget.post.title!,));
              },
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (isBookmark) {
                        postBookmarkBloc.add(PostBookmarkRemoveEvent(id: widget.post.id!));
                      } else {
                        postBookmarkBloc.add(PostBookmarkAddEvent(id: widget.post.id!));
                      }
                    },
                    icon: Icon(
                      isBookmark ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                      color: isBookmark ? App.theme.primaryColor : App.theme.iconTheme.color,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60 - 60,
                    child: Text(
                      widget.post.title ?? "",
                      style: TextStyle(
                        color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () async {
                  await FlutterShare.share(
                    title: 'اشتراک گذاری',
                    text: widget.post.title,
                    linkUrl: widget.post.shareLink,
                    chooserTitle: 'اشتراک گذاری در',
                  );
                },
                icon: Icon(
                  Icons.share_rounded,
                  color: App.theme.iconTheme.color,
                  size: 21,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: showSummary ? summary : description,
                    style: TextStyle(
                      color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'IranSans',
                    ),
                  ),
                  if (summary.length < description.length)
                    TextSpan(
                      text: showSummary ? ' بیشتر...' : ' کمتر',
                      style: TextStyle(
                        color: App.theme.primaryColor,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'IranSans',
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            showSummary = !showSummary;
                          });
                        },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
