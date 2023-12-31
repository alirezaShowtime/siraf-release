part of 'estate_profile_screen.dart';

class AnswerItemWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnswerItemWidget();

  ReplyComment comment;

  AnswerItemWidget(this.comment);
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
                    imagePath: widget.comment.avatar ?? "",
                    errorImage: AssetImage("assets/images/profile.jpg"),
                    loadingImage: AssetImage("assets/images/profile.jpg"),
                  ),
                  SizedBox(width: 5),
                  Text(
                    widget.comment.name ?? "ناشناس",
                    style: TextStyle(
                      color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Text(
                widget.comment.createDate ?? "",
                style: TextStyle(
                  color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            widget.comment.comment ?? "",
            style: TextStyle(
              fontSize: 11,
              color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
