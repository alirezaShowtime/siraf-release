import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:siraf3/bloc/estate_profile/comment/send/estate_profile_comment_rate_bloc.dart';
import 'package:siraf3/bloc/estate_profile/profile/estate_profile_bloc.dart';
import 'package:siraf3/bloc/files_bloc.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/city.dart' as city;
import 'package:siraf3/models/consultant_info.dart';
import 'package:siraf3/models/estate_profile.dart' as estateProfileModel;
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/screens/filter_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_list_view.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_text_field.dart';
import 'package:siraf3/widgets/static_star.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';

import 'comment_item_widget.dart';

part 'add_comment_widget.dart';
part 'answer_item.dart';
part 'event_listeners.dart';
part 'profile.dart';
part 'profile_detail.dart';
part 'search_bar.dart';

class EstateProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EstateProfileScreen();

  int estateId;
  String? estateName;

  EstateProfileScreen({required this.estateId, this.estateName});
}

class _EstateProfileScreen extends State<EstateProfileScreen> with SingleTickerProviderStateMixin {
  bool showComment = false;

  bool moreDetail = false;

  bool showSearchBarWidget = false;
  bool showCommentWidget = false;

  late AnimationController collapseController;
  late Animation<double> collapseAnimation;

  late BuildContext scaffoldContext;

  String? comment;
  double? rate;
  String title = "در حال بارگذاری...";

  TextEditingController searchController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  EstateProfileBloc bloc = EstateProfileBloc();
  EstateProfileCommentRateBloc sendCommentRateBloc = EstateProfileCommentRateBloc();

  estateProfileModel.EstateProfile? estateProfile;

  FilesBloc filesBloc = FilesBloc();
  FilesBloc _moreFilesBloc = FilesBloc();
  late FilterData filterData;
  var nowState;

  FocusNode focusNode = FocusNode();

  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();

    collapseController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    collapseAnimation = CurvedAnimation(parent: collapseController, curve: Curves.fastOutSlowIn);

    collapseController.addListener(_collapseControllerListener);

    setState(() {
      title = widget.estateName ?? title;
    });

    setFilterData();

    sendCommentRateBloc.stream.listen((state) {
      if (state is EstateProfileCommentRateError) {
        notify(state.message ?? "خطایی در ثبت امتیاز/نظر پیش آمد.");
      }
      if (state is EstateProfileCommentRateSuccess) {
        rate = null;
        commentController.clear();
        focusNode.unfocus();
        if (state.comment != null) {
          List<Comment> list = comments;
          comments = [];
          comments.add(state.comment!);
          comments.addAll(list);
        }
        try {
          setState(() {});
        } catch (e) {}

        notify("نظر / امتیاز شما ثبت شد");
      }
    });
  }

  @override
  void dispose() {
    sendCommentRateBloc.close();
    filesBloc.close();
    bloc.close();
    collapseController.removeListener(_collapseControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => filesBloc),
        BlocProvider(create: (context) => sendCommentRateBloc),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: appBar(),
        body: BlocConsumer<EstateProfileBloc, EstateProfileState>(
          listener: (context, state) {
            if (state is EstateProfileSuccessState) {
              setState(() {
                title = state.estateProfile.name!;
                estateProfile = state.estateProfile;
              });
            }
          },
          bloc: bloc..add(EstateProfileLoadEvent(widget.estateId)),
          builder: (context, state) {
            scaffoldContext = context;
            if (state is EstateProfileInitial) return Center(child: Loading());
            if (state is EstateProfileErrorState) return retryWidget(context, state.message);
            if (state is EstateProfileSuccessState) {
              if (nowState == null) {
                nowState = state;
                comments = state.estateProfile.comments ?? [];
              }
              print("comments ${comments.length}");
              return profile(context, state.estateProfile);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget retryWidget(context, String? message) {
    return Center(
      child: TryAgain(onPressed: () => retry(context), message: message),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0.7,
      automaticallyImplyLeading: false,
      leading: MyBackButton(),
      titleSpacing: 0,
      title: AppBarTitle(title),
      actions: [
        IconButton(
          onPressed: share,
          icon: icon(Icons.share_rounded, size: 22),
        ),
        MyPopupMenuButton(
          onSelected: (v) => report(),
          itemBuilder: (_) => [
            popupMenuItem(title: "گزارش تخلف", value: "report"),
          ],
          iconData: Icons.more_vert,
        ),
      ],
    );
  }

  Widget card({required String title, required String value}) {
    return Expanded(
      child: Container(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: App.theme.textTheme.bodyLarge?.color,
                fontSize: 11,
              ),
            ),
            SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: App.theme.tooltipTheme.textStyle?.color,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget estateImageItem(estateProfileModel.Image image) {
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

  Widget consultantItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Container(
            margin: EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Avatar(size: 45, imagePath: "https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png"),
                SizedBox(height: 5),
                Text(
                  "عباس رحیمی",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: Themes.textGrey,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StaticStar(rating: 4.5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fileItem(File file) => FileHorizontalItem(file: file);

  void _collapseControllerListener() {
    if (collapseController.isDismissed && !showComment) {
      showSearchBarWidget = true;
    }
  }

  List<city.City> cities = [];

  void setFilterData() async {
    cities = await city.City.getList();

    filterData = FilterData(cityIds: cities.map<int>((e) => e.id!).toList(), estateId: widget.estateId);
    getFiles();
  }

  List<File> files = [];
}
