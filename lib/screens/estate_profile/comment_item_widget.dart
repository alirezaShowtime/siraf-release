import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:siraf3/bloc/estate_profile/comment/like_and_dislike/estate_profile_like_comment_bloc.dart';
import 'package:siraf3/bloc/estate_profile/comment/send/estate_profile_comment_rate_bloc.dart';
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

import 'estate_profile_screen.dart';

class CommentItemWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CommentItemWidget();

  Comment comment;
  int estateId;

  CommentItemWidget({required this.comment, required this.estateId});
}

class _CommentItemWidget extends State<CommentItemWidget> {
  EstateProfileLikeCommentBloc likeCommentBloc = EstateProfileLikeCommentBloc();

  TextEditingController replyFieldController = TextEditingController();

  bool showReplyField = false;

  List<ReplyComment> replyComments = [];

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    replyComments = widget.comment.replies ?? [];

    likeCommentBloc.stream.listen((state) {
      if (state is EstateProfileLikeCommentLoading) {
        notify("در حال ثبت...");
      }
    });

    BlocProvider.of<EstateProfileCommentRateBloc>(context).stream.listen((state) {
      if (state is EstateProfileCommentRateSuccess && state.isReply) {
        replyComments == state.comment.replies;
        replyFieldController.clear();
        showReplyField = false;
        focusNode.unfocus();
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
                    imagePath: widget.comment.userId!.avatar,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.comment.userId?.name ?? "ناشناس",
                    style: TextStyle(color: Themes.textGrey, fontSize: 11),
                  ),
                ],
              ),
              Column(
                children: [
                  RatingBar.builder(
                    initialRating: widget.comment.rate,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.25),
                    itemBuilder: (context, _) => icon(Icons.star, color: Colors.amber),
                    itemSize: 10,
                    onRatingUpdate: (double value) {},
                    updateOnDrag: false,
                    ignoreGestures: true,
                    unratedColor: Colors.grey.shade300,
                  ),
                  Text(
                    widget.comment.createDate ?? "",
                    style: TextStyle(color: Themes.textGrey, fontSize: 9),
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
              style: TextStyle(color: Themes.textGrey, fontSize: 11),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder(
                bloc: likeCommentBloc,
                builder: (context, state) {
                  int like = widget.comment.likeCount ?? 0;
                  int dislike = widget.comment.dislikeCount ?? 0;

                  if (state is EstateProfileLikeCommentSuccess) {
                    like = state.action == CommentAction.Like ? like + 1 : like;
                    dislike = state.action == CommentAction.Dislike ? dislike + 1 : dislike;
                  }

                  return Row(
                    children: [
                      MyTextIconButton(
                        onPressed: onClickLike,
                        icon: icon(Icons.thumb_up_alt_outlined, size: 15),
                        text: like.emptable(),
                        rippleColor: Themes.text,
                      ),
                      MyTextIconButton(
                        onPressed: onClickDislike,
                        icon: icon(Icons.thumb_up_alt_outlined, size: 15),
                        text: dislike.emptable(),
                        rippleColor: Themes.text,
                      ),
                    ],
                  );
                },
              ),
              if (!showReplyField)
                MyTextButton(
                  rippleColor: Themes.text,
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    setState(() => showReplyField = !showReplyField);
                  },
                  child: Text(
                    "پاسخ",
                    style: TextStyle(
                      color: Themes.text,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (showReplyField) replyFieldWidget(),
          if (widget.comment.replies.isFill()) Column(children: replyComments.map<Widget>((answer) => AnswerItemWidget(answer)).toList()),
        ],
      ),
    );
  }

  void onClickLike() {
    likeCommentBloc.add(EstateProfileLikeCommentRequestEvent(widget.comment.id!, CommentAction.Like));
  }

  void onClickDislike() {
    likeCommentBloc.add(EstateProfileLikeCommentRequestEvent(widget.comment.id!, CommentAction.Dislike));
  }

  void answer() {
    var text = replyFieldController.value.text;

    if (!text.isFill()) {
      notify("متن پاسخ وارد نشده است");
      return;
    }
    BlocProvider.of<EstateProfileCommentRateBloc>(context).add(EstateProfileCommentRateSendCommentEvent(widget.estateId, text, commentId: widget.comment.id!));
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
              bloc: BlocProvider.of<EstateProfileCommentRateBloc>(context),
              builder: (context, state) {
                return MyTextButton(
                  text: "ارسال",
                  color: Themes.primary,
                  textColor: Colors.white,
                  fontSize: 10,
                  minimumSize: Size(50, 15),
                  disable: state is EstateProfileCommentRateSending,
                  onPressed: answer,
                );
              },
            ),
            SizedBox(width: 5),
            MyTextButton(
              fontSize: 10,
              text: "صرف نظر",
              border: false,
              rippleColor: Themes.text,
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
