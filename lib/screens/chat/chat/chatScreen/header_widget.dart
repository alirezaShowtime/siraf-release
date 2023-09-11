part of 'chat_screen.dart';

extension HeaderWidget on _ChatScreen {
  Widget defaultFileImage(double size) {
    return Container(
      padding: EdgeInsets.all(7),
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: App.theme.primaryColor.withOpacity(0.1),
      ),
      child: Icon(Icons.home, color: App.theme.primaryColor),
    );
  }

  Widget headerChatWidget() {
    return Container(
      height: 55,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: App.theme.dialogBackgroundColor,
        border: Border(
          bottom: BorderSide(color: App.theme.shadowColor, width: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, -3),
            spreadRadius: 3,
            blurRadius: 1,
            color: App.theme.shadowColor,
          ),
        ],
      ),
      child: Row(
        children: [
          MyImage(
            borderRadius: BorderRadius.circular(5),
            image: NetworkImage(widget.fileImage ?? ""),
            errorWidget: defaultFileImage(40),
            loadingWidget: defaultFileImage(40),
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.fileTitle ?? "نامشخص",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, fontFamily: "IranSansBold"),
                ),
                SizedBox(height: 4),
                Text(
                  widget.fileAddress ?? "نامشخص",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 9, fontFamily: "IranSansMedium"),
                ),
              ],
            ),
          ),
          MyTextButton(
            onPressed: () {
              if (widget.fileId != null) {
                push(context, FileScreen(id: widget.fileId!));
              }
            },
            fontSize: 10,
            child: Text(
              "نمایش",
              style: TextStyle(
                fontFamily: "IranSansBold",
                fontSize: 10,
                color: App.theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
