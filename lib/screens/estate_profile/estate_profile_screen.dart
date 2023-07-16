import 'dart:typed_data';

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
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/city.dart' as city;
import 'package:siraf3/models/consultant_info.dart';
import 'package:siraf3/models/estate_profile.dart' as estateProfileModel;
import 'package:siraf3/models/estate_profile.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/screens/consultant_profile/consultant_profile_screen.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/screens/filter_screen.dart';
import 'package:siraf3/screens/image_view_screen.dart';
import 'package:siraf3/screens/video_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_image.dart';
import 'package:siraf3/widgets/my_list_view.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_text_field.dart';
import 'package:siraf3/widgets/static_star.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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

class _EstateProfileScreen extends State<EstateProfileScreen> {
  List<city.City> cities = [];
  List<File> files = [];
  List<Comment> comments = [];

  var nowState;

  bool showComment = false;
  bool moreDetail = false;
  bool showSearchBarWidget = false;
  bool showCommentWidget = false;

  late BuildContext scaffoldContext;
  late FilterData filterData;

  String? comment;
  double? rate;
  estateProfileModel.EstateProfile? estateProfile;

  String title = "در حال بارگذاری...";

  TextEditingController searchController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  FilesBloc filesBloc = FilesBloc();
  FilesBloc _moreFilesBloc = FilesBloc();
  EstateProfileBloc bloc = EstateProfileBloc();
  EstateProfileCommentRateBloc sendCommentRateBloc = EstateProfileCommentRateBloc();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    bloc.add(EstateProfileRequestEvent(widget.estateId));

    if (widget.estateName != null) {
      setState(() => title = widget.estateName!);
    }

    setFilterData();

    sendCommentRateBloc.stream.listen((state) {
      if (state is EstateProfileCommentRateError) {
        notify(state.message ?? "خطایی در ثبت امتیاز/نظر پیش آمد.");
      }
      if (state is EstateProfileCommentRateSuccess && state.comment != null && !state.isReply) {
        commentController.clear();
        List<Comment> list = comments;
        comments = [];
        comments.add(state.comment!);
        comments.addAll(list);
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
          bloc: bloc,
          listener: (context, state) {
            if (state is EstateProfileSuccessState) {
              setState(() {
                title = state.estateProfile.name!;
                estateProfile = state.estateProfile;
                comments = state.estateProfile.comments ?? [];
              });
            }
          },
          builder: (context, state) {
            scaffoldContext = context;
            if (state is EstateProfileLoading || state is EstateProfileInitial) return Center(child: Loading());
            if (state is EstateProfileErrorState) return retryWidget(context, state.message);
            if (state is EstateProfileSuccessState) return profile(context, state.estateProfile);
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
                fontFamily: "IranSansBold",
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

  Widget estateImageItem(estateProfileModel.Images image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GestureDetector(
        onTap: () {
          push(context, ImageViewScreen(imageUrl: image.image,));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: MyImage(
            image: NetworkImage(image.image ?? ""),
            height: 50,
            width: 70,
            fit: BoxFit.fill,
            errorWidget: MyImage.defaultErrorImageWidget(50, 70, "خطا!"),
            loadingWidget: MyImage.defaultErrorImageWidget(50, 70, "درحال بارگزاری.."),
          ),
        ),
      ),
    );
  }

  Widget consultantItem(Consultants consultant) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => push(
            context,
            ConsultantProfileScreen(
              consultantId: consultant.id!,
              consultantName: consultant.name,
            ),
          ),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            margin: EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Avatar(
                  size: 45,
                  imagePath: consultant.avatar,
                  errorImage: AssetImage("assets/images/profile.png"),
                  loadingImage: AssetImage("assets/images/profile.png"),
                ),
                SizedBox(height: 5),
                Text(
                  consultant.name ?? "",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: Themes.textGrey,
                    fontSize: 9,
                    fontFamily: "IranSansBold",
                  ),
                ),
                StaticStar(rating: consultant.rate ?? 0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fileItem(File file) => FileHorizontalItem(file: file);

  void setFilterData() async {
    cities = await city.City.getList();

    filterData = FilterData(cityIds: cities.map<int>((e) => e.id!).toList(), estateId: widget.estateId);
    getFiles();
  }
}
