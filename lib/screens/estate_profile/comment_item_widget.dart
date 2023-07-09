import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:siraf3/bloc/estate_profile/comment/like_and_dislike/estate_profile_like_comment_bloc.dart';
import 'package:siraf3/enums/comment_action.dart';
import 'package:siraf3/extensions/int_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/consultant_info.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/my_text_icon_button.dart';

class CommentItemWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CommentItemWidget();

  Comment comment;

  CommentItemWidget({required this.comment});
}

class _CommentItemWidget extends State<CommentItemWidget> {
  EstateProfileLikeCommentBloc likeCommentBloc = EstateProfileLikeCommentBloc();

  @override
  void initState() {
    super.initState();

    likeCommentBloc.stream.listen((state) {
      if (state is EstateProfileLikeCommentLoading) {
        notify("در حال ثبت...");
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
                    initialRating: widget.comment.rate ?? 0,
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
                        onPressed: () => onClickLike(widget.comment),
                        icon: icon(Icons.thumb_up_alt_outlined, size: 15),
                        text: like.emptable(),
                        rippleColor: Themes.text,
                      ),
                      MyTextIconButton(
                        onPressed: () => onClickDislike(widget.comment),
                        icon: icon(Icons.thumb_up_alt_outlined, size: 15),
                        text: dislike.emptable(),
                        rippleColor: Themes.text,
                      ),
                    ],
                  );
                },
              ),
              MyTextButton(
                rippleColor: Themes.text,
                padding: EdgeInsets.zero,
                onPressed: () => answer(widget.comment),
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
          //todo: answer feature do not implement yet
          // if (comment["answers"] != null && (comment["answers"] as List).length > 0) Column(children: (comment["answers"] as List).map((answer) => answerItem(answer)).toList()),
        ],
      ),
    );
  }

  void onClickLike(Comment comment) {
    likeCommentBloc.add(EstateProfileLikeCommentRequestEvent(comment.id!, CommentAction.Like));
  }

  void onClickDislike(Comment comment) {
    likeCommentBloc.add(EstateProfileLikeCommentRequestEvent(comment.id!, CommentAction.Dislike));
  }

  void answer(Comment comment) {
    //todo: implement event listener
  }
}
