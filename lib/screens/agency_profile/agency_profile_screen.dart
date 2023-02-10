import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/screens/agency_profile/add_comment_widget.dart';
import 'package:siraf3/screens/agency_profile/comment_item.dart';
import 'package:siraf3/screens/agency_profile/event_listeners.dart';
import 'package:siraf3/screens/agency_profile/profile_detail.dart';
import 'package:siraf3/screens/agency_profile/search_bar.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/static_star.dart';

class AgencyProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AgencyProfileScreenState();
}

class AgencyProfileScreenState extends State<AgencyProfileScreen>
    with SingleTickerProviderStateMixin {
  List<File> list = [
    File(
      id: 342,
      name: "hello owlrs",
      description: "fdslfdsfkp[dk dsolpfdjs fiod",
      city: "تهران",
      publishedAgo: "یک هفته پیش",
      propertys: [
        Property(
          name: "heloweds",
          value: "fkds",
          weightList: 1,
          list: true,
        ),
        Property(
          name: "heloweds",
          value: "fkds",
          weightList: 2,
          list: true,
        ),
        Property(
          name: "heloweds",
          value: "fkds",
          weightList: 3,
          list: true,
        ),
      ],
      fullCategory: FullCategory(
        fullCategory: "fdskofk ",
        name: "dfsofijdsf ",
        id: 1,
        image: "fdjspofkdspofk dsf",
      ),
      favorite: true,
      // images: [
      //   Images(
      //       idm : "",
      //       createDatem : "",
      //       pathm : "",
      //       statusm : "",
      //       weightm : "",
      //       namem : "",
      //       fileIdm : "",
      //   ),
      // ],
    ),
  ];

  List<Map<String, dynamic>> comments = [
    {
      "comment": "hello world",
      "star": 3.5,
      "date": "1401/05/19",
      "likes": 12,
      "dislike": 2,
      "user": {
        "username": "alireza",
        "profileImage": "kdiofksdpofkds jfoidkf fd",
      },
      "answers": [
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
      ],
    },
    {
      "comment": "hello world",
      "star": 3.5,
      "date": "1401/05/19",
      "likes": 12,
      "dislike": 2,
      "user": {
        "username": "alireza",
        "profileImage": "kdiofksdpofkds jfoidkf fd",
      },
      "answers": [
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
      ],
    },
    {
      "comment": "hello world",
      "star": 3.5,
      "date": "1401/05/19",
      "likes": 12,
      "dislike": 2,
      "user": {
        "username": "alireza",
        "profileImage": "kdiofksdpofkds jfoidkf fd",
      },
      "answers": [
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
      ],
    },
    {
      "comment": "hello world",
      "star": 3.5,
      "date": "1401/05/19",
      "likes": 12,
      "dislike": 2,
      "user": {
        "username": "alireza",
        "profileImage": "kdiofksdpofkds jfoidkf fd",
      },
      "answers": [
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
        {
          "comment": "hello world",
          "star": 3.5,
          "date": "1401/05/19",
          "likes": 12,
          "dislike": 2,
          "user": {
            "username": "alireza",
            "profileImage": "kdiofksdpofkds jfoidkf fd",
          },
        },
      ],
    },
  ];

  bool showComment = false;

  bool moreDetail = false;

  bool showSearchBarWidget = false;
  bool showCommentWidget = false;

  late AnimationController collopsController;
  late Animation<double> collopsAnimation;

  late BuildContext scaffoldContext;

  String? comment;
  double? rating;

  TextEditingController searchController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    collopsController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    collopsAnimation =
        CurvedAnimation(parent: collopsController, curve: Curves.fastOutSlowIn);

    collopsController.addListener(_collopsControllerListener);
  }

  @override
  void dispose() {
    super.dispose();
    collopsController.removeListener(_collopsControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar(),
      body: Builder(builder: (context) {
        scaffoldContext = context;
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Container(
                height: 170,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Avatar(
                            size: 80,
                            imagePath:
                                "https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png"),
                        Container(
                          padding: const EdgeInsets.only(left: 2),
                          decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.grey.shade200, width: 1))),
                          child: Column(
                            children: [
                              Text(
                                "املاک برج",
                                style: TextStyle(
                                  color: Themes.text,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "93405355345",
                                style: TextStyle(
                                  color: Themes.text,
                                  fontSize: 11,
                                ),
                              ),
                              StaticStar(rating: 4.5),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  card(
                                      title: "فروشی",
                                      value: "10",
                                      onTap: () {}),
                                  card(
                                      title: "اجاره ای",
                                      value: "75",
                                      onTap: () {}),
                                  card(
                                      title: "ساخت و ساز",
                                      value: "23",
                                      onTap: () {}),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "ds;ofdskj dolspfk dkdofdks oidmnsfk dnf dosmjfoidns d[sk fldpofdspofmks dpolfkdms dms,fp[doskjf ods,fkdpsnf dpsfdms fdskmofds",
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Themes.textGrey, fontSize: 11),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: viewMoreDetail,
                                      child: Text(
                                        moreDetail ? "کمتر" : "بیشتر...",
                                        style: TextStyle(
                                          color: Themes.text,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        final bool previousValueOfMoreDetail =
                                            moreDetail;
                                        showComment = !showComment;

                                        viewMoreDetail(force: false);

                                        if (!previousValueOfMoreDetail &&
                                            !showComment) {
                                          showSearchBarWidget = true;
                                        }

                                        if (!previousValueOfMoreDetail &&
                                            showComment) {
                                          showSearchBarWidget = false;
                                        }
                                      }),
                                      child: Text(
                                        !showComment
                                            ? "نمایش نظرات (${comments.length})"
                                            : "فایل های دفتر املاک",
                                        style: TextStyle(
                                          color: Themes.text,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizeTransition(
                sizeFactor: collopsAnimation,
                axis: Axis.vertical,
                child: profileDetail(),
              ),
              if (showSearchBarWidget) searchBar(),
              if (showComment)
                Expanded(
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, i) {
                      if (i == 0) return addCommentWidget();

                      return commentItem(comments[i - 0]);
                    },
                  ),
                ),
              if (!showComment)
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) => fileItem(list[i]),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Themes.appBar,
      elevation: 0.7,
      automaticallyImplyLeading: false,
      leading: MyBackButton(),
      titleSpacing: 0,
      title: AppBarTitle("املاک برج"),
      actions: [
        IconButton(onPressed: share, icon: icon(Icons.share_rounded)),
        MyPopupMenuButton(items: []),
      ],
    );
  }

  Widget card(
      {required String title, required String value, void Function()? onTap}) {
    return Expanded(
      child: MyTextButton(
        onPressed: () {},
        rippleColor: Colors.grey,
        child: Container(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Themes.text,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: Themes.textGrey,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget agencyImageItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          image: NetworkImage(
              "https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png"),
          height: 50,
          width: 70,
          fit: BoxFit.fill,
          loadingBuilder: (context, child, progressEvent) {
            if (progressEvent == null) return child;
            return Container(
              height: 50,
              width: 70,
              color: Colors.grey.shade200,
            );
          },
        ),
      ),
    );
  }

  Widget agentItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Avatar(
              size: 45,
              imagePath:
                  "https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png"),
          SizedBox(height: 5),
          Text(
            "عباس رحیمی",
            style: TextStyle(
              color: Themes.textGrey,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          StaticStar(rating: 4.5),
        ],
      ),
    );
  }

  Widget fileItem(File file) => FileHorizontalItem(file: file);

  void _collopsControllerListener() {
    if (collopsController.isDismissed && !showComment) {
      showSearchBarWidget = true;
    }

    setState(() {});
  }
}
