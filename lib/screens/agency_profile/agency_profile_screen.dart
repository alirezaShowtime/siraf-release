import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:siraf3/bloc/agency_profile/agency_profile_bloc.dart';
import 'package:siraf3/bloc/agency_profile_comment/agency_profile_comment_rate_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/consultant_info.dart';
import 'package:siraf3/models/estate_profile.dart' as estateProfileModel;
import 'package:siraf3/models/file.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/my_text_icon_button.dart';
import 'package:siraf3/widgets/static_star.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';

part 'add_comment_widget.dart';

part 'answer_item.dart';

part 'comment_item.dart';

part 'event_listeners.dart';

part 'profile.dart';

part 'profile_detail.dart';

part 'search_bar.dart';

class AgencyProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AgencyProfileScreen();

  int estateId;

  AgencyProfileScreen({this.estateId = 6});
}

class _AgencyProfileScreen extends State<AgencyProfileScreen> with SingleTickerProviderStateMixin {
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

  bool showComment = false;

  bool moreDetail = false;

  bool showSearchBarWidget = false;
  bool showCommentWidget = false;

  late AnimationController collopsController;
  late Animation<double> collopsAnimation;

  late BuildContext scaffoldContext;

  String? comment;
  double? rate;
  String title = "در حال بارگذاری...";

  TextEditingController searchController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  AgencyProfileBloc bloc = AgencyProfileBloc();
  AgencyProfileCommentRateBloc commentRateBloc = AgencyProfileCommentRateBloc();

  estateProfileModel.EstateProfile? estateProfile;

  @override
  void initState() {
    super.initState();

    collopsController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    collopsAnimation = CurvedAnimation(parent: collopsController, curve: Curves.fastOutSlowIn);

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
      body: BlocConsumer<AgencyProfileBloc, AgencyProfileState>(
        listener: (context, state) {
          if (state is AgencyProfileSuccessState) {
            setState(() {
              title = state.estateProfile.name!;
              estateProfile = state.estateProfile;
            });
          }
        },
        bloc: bloc..add(AgencyProfileLoadEvent(widget.estateId)),
        builder: (context, state) {
          scaffoldContext = context;
          if (state is AgencyProfileInitial) return Center(child: Loading());
          if (state is AgencyProfileErrorState) return retryWidget(context, state.message);
          if (state is AgencyProfileSuccessState) return profile(context, state.estateProfile);
          return Container();
        },
      ),
    );
  }

  Widget retryWidget(context, String message) {
    return Center(
      child: TryAgain(onPressed: () => retry(context), message: message),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Themes.appBar,
      elevation: 0.7,
      automaticallyImplyLeading: false,
      leading: MyBackButton(),
      titleSpacing: 0,
      title: AppBarTitle(title),
      actions: [
        IconButton(onPressed: share, icon: icon(Icons.share_rounded)),
        MyPopupMenuButton(
          itemBuilder: (_) => [
            popupMenuItemWithIcon(title: "گزارش تخلف", onTap: report),
          ],
        ),
      ],
    );
  }

  Widget card({required String title, required String value, void Function()? onTap}) {
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

  Widget agencyImageItem(estateProfileModel.Image image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          image: NetworkImage(image.path ?? ""),
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

  Widget agentItem(estateProfileModel.Consultants consultant) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Avatar(size: 45, imagePath: consultant.avatar),
          SizedBox(height: 5),
          Text(
            consultant.name!,
            style: TextStyle(
              color: Themes.textGrey,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          StaticStar(rating: consultant.rate!),
        ],
      ),
    );
  }

  Widget fileItem(File file) => FileHorizontalItem(file: file);

  void _collopsControllerListener() {
    if (collopsController.isDismissed && !showComment) {
      showSearchBarWidget = true;
    }
  }
}
