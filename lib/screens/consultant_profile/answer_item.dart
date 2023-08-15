part of 'consultant_profile_screen.dart';

class AnswerItemWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnswerItemWidget();

  ReplyComment replyComment;

  AnswerItemWidget(this.replyComment);
}

class _AnswerItemWidget extends State<AnswerItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 4, left: 12, right: 12),
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
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
                    size: 25,
                    imagePath: widget.replyComment.avatar ?? "",
                    errorImage: AssetImage("assets/images/profile.jpg"),
                    loadingImage: AssetImage("assets/images/profile.jpg"),
                  ),
                  SizedBox(width: 5),
                  Text(
                    widget.replyComment.name ?? "ناشناس",
                    style: TextStyle(
                      color: Themes.textGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Text(
                widget.replyComment.createDate ?? "",
                style: TextStyle(
                  color: Themes.textGrey,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            widget.replyComment.comment ?? "",
            style: TextStyle(
              fontSize: 11,
              color: Themes.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
