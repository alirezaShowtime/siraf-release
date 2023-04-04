part of 'package:siraf3/screens/agency_profile/agency_profile_screen.dart';

extension CommentItem on _AgencyProfileScreen {
  Widget commentItem(Comment comment) {
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
                    imagePath: comment.userId!.avatar,
                  ),
                  SizedBox(width: 10),
                  Text(
                    comment.userId?.name ?? "ناشناس",
                    style: TextStyle(color: Themes.textGrey, fontSize: 11),
                  ),
                ],
              ),
              Column(
                children: [
                  RatingBar.builder(
                    initialRating: comment.rate ?? 0,
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
                    comment.createDate ?? "",
                    style: TextStyle(
                      color: Themes.textGrey,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: 40,
            ),
            padding: const EdgeInsets.only(right: 5, top: 10, bottom: 10),
            child: Text(
              comment.comment ?? "",
              style: TextStyle(color: Themes.textGrey, fontSize: 11),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MyTextIconButton(
                    onPressed: () => like(comment),
                    icon: icon(Icons.thumb_up_alt_outlined, size: 15),
                    text: (comment.likeCount ?? 0).toString(),
                    rippleColor: Themes.text,
                  ),
                  MyTextIconButton(
                    onPressed: () => dislike(comment),
                    icon: icon(Icons.thumb_down_alt_outlined, size: 15),
                    text: (comment.countDisLike ?? 0).toString(),
                    rippleColor: Themes.text,
                  ),
                ],
              ),
              MyTextButton(
                rippleColor: Themes.text,
                padding: EdgeInsets.zero,
                onPressed: () => answer(comment),
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
}
