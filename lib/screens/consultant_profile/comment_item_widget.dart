import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:siraf3/bloc/consultant_profile/comment/like_and_dislike/consultant_like_comment_bloc.dart';
import 'package:siraf3/bloc/consultant_profile/comment/send/consultant_profile_comment_rate_bloc.dart';
import 'package:siraf3/enums/comment_action.dart';
import 'package:siraf3/extensions/int_extension.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/consultant_info.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/my_text_field.dart';
import 'package:siraf3/widgets/my_text_icon_button.dart';
import 'package:siraf3/main.dart';
import 'consultant_profile_screen.dart';

class CommentItemWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CommentItemWidget();

  Comment comment;
  int consultantId;

  CommentItemWidget({required this.comment, required this.consultantId});
}

class _CommentItemWidget extends State<CommentItemWidget> {
  ConsultantLikeCommentBloc likeCommentBloc = ConsultantLikeCommentBloc();

  TextEditingController replyFieldController = TextEditingController();
  bool showReplyField = false;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    likeCommentBloc.stream.listen((state) {
      if (state is ConsultantLikeCommentLoading) {
        notify("در حال ثبت...");
      }
    });

    BlocProvider.of<ConsultantProfileCommentRateBloc>(context).stream.listen((state) {
      if (state is ConsultantProfileCommentRateSuccess && state.comment != null && state.isReply && widget.comment.id == state.comment!.id) {
        widget.comment.replies = state.comment!.replies ?? [];
        showReplyField = false;
        replyFieldController.clear();
        try {
          setState(() {});
        } catch (e) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Avatar(
                    size: 40,
                    imagePath: widget.comment.userId?.avatar ?? "",
                    errorImage: AssetImage("assets/images/profile.jpg"),
                    loadingImage: AssetImage("assets/images/profile.jpg"),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.comment.userId?.name ?? "ناشناس",
                    style: TextStyle(color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey, fontSize: 11),
                  ),
                ],
              ),
              Column(
                children: [
                  RatingBarIndicator(
                    // initialRating: widget.comment.rate,
                    // minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    // allowHalfRating: true,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.25),
                    itemBuilder: (context, _) => icon(Icons.star, color: Colors.amber),
                    itemSize: 10,
                    // onRatingUpdate: (double value) {},
                    // updateOnDrag: false,
                    // ignoreGestures: true,
                    rating: widget.comment.rate,
                    unratedColor: Colors.grey.shade300,
                  ),
                  Text(
                    //todo:
                    widget.comment.createDate ?? "",
                    style: TextStyle(color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey, fontSize: 9),
                  ),
                ],
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.only(right: 5, top: 10, bottom: 10),
            child: Text(
              widget.comment.comment ?? "",
              style: TextStyle(color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey, fontSize: 11),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocConsumer(
                bloc: likeCommentBloc,
                listener: (context, state) {
                  if (state is ConsultantLikeCommentSuccess) {
                    widget.comment.likeCount = state.action == CommentAction.Like ? widget.comment.previousLike + 1 : widget.comment.previousLike;
                    widget.comment.dislikeCount = state.action == CommentAction.Dislike ? widget.comment.previousDislike + 1 : widget.comment.previousDislike;
                  }
                },
                builder: (context, state) {
                  return Row(
                    children: [
                      MyTextIconButton(
                        onPressed: onClickLike,
                        icon: icon(Icons.thumb_up_alt_outlined, size: 15),
                        text: widget.comment.likeCount.emptable(),
                        rippleColor: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                      ),
                      MyTextIconButton(
                        onPressed: onClickDislike,
                        icon: icon(Icons.thumb_down_alt_outlined, size: 15),
                        text: widget.comment.dislikeCount.emptable(),
                        rippleColor: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                      ),
                    ],
                  );
                },
              ),
              if (!showReplyField)
                MyTextButton(
                  rippleColor: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() => showReplyField = !showReplyField);
                  },
                  child: Text(
                    "پاسخ",
                    style: TextStyle(
                      color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                      fontSize: 10,
                      fontFamily: "IranSansBold",
                    ),
                  ),
                ),
            ],
          ),
          if (showReplyField) replyFieldWidget(),
          if (widget.comment.replies.isFill()) Column(children: widget.comment.replies!.map<Widget>((answer) => AnswerItemWidget(answer)).toList()),
        ],
      ),
    );
  }

  void onClickLike() {
    likeCommentBloc.add(ConsultantLikeCommentRequestEvent(widget.comment.id!, CommentAction.Like));
  }

  void onClickDislike() {
    likeCommentBloc.add(ConsultantLikeCommentRequestEvent(widget.comment.id!, CommentAction.Dislike));
  }

  void answer() {
    var text = replyFieldController.value.text;

    if (!text.isFill()) {
      notify("متن پاسخ وارد نشده است");
      return;
    }
    BlocProvider.of<ConsultantProfileCommentRateBloc>(context).add(ConsultantProfileCommentRateSendCommentEvent(
      widget.consultantId,
      text,
      commentId: widget.comment.id!,
    ));
    focusNode.unfocus();
  }

  Widget replyFieldWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        MyTextField(
          focusNode: focusNode,
          controller: replyFieldController,
          maxLines: 1,
          maxLength: 500,
          decoration: InputDecoration(hintText: "پاسخ..."),
        ),
        Row(
          children: [
            BlocBuilder(
              bloc: BlocProvider.of<ConsultantProfileCommentRateBloc>(context),
              builder: (context, state) {
                return MyTextButton(
                  text: "ارسال",
                  color: App.theme.primaryColor,
                  textColor: Colors.white,
                  fontSize: 10,
                  minimumSize: Size(50, 15),
                  disable: state is ConsultantProfileCommentRateSending,
                  onPressed: answer,
                );
              },
            ),
            SizedBox(width: 5),
            MyTextButton(
              fontSize: 10,
              text: "صرف نظر",
              border: false,
              rippleColor: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
              minimumSize: Size(50, 15),
              onPressed: () {
                setState(() => showReplyField = !showReplyField);
              },
            ),
          ],
        ),
      ],
    );
  }
}
