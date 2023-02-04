import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/my_back_button.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 10,
        leading: MyBackButton(),
        backgroundColor: Themes.primary,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: NetworkImage("https://www.seiu1000.org/sites/main/files/imagecache/hero/main-images/camera_lense_0.jpeg"),
                  width: 40,
                  height: 40,
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Image.asset(
                      "assets/images/profile.png",
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                      alignment: Alignment.center,
                    );
                  },
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  "پشتیبانی",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "آنلاین",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade200,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}
