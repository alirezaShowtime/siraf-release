import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:siraf3/bloc/consultant_profile/comment/send/consultant_profile_comment_rate_bloc.dart';
import 'package:siraf3/bloc/consultant_profile/profile/consultant_profile_bloc.dart';
import 'package:siraf3/bloc/files_bloc.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/consultant_info.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/screens/estate_profile_without_comment/estate_profile_screen.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/screens/filter_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/file_horizontal_item_2.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_list_view.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';
import 'package:siraf3/widgets/static_star.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';

import 'consultant_share_screen.dart';

part 'add_comment_widget.dart';
part 'appbar.dart';
part 'event_listeners.dart';
part 'my_card.dart';
part 'profile.dart';
part 'search_bar.dart';

class ConsultantProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConsultantProfileScreen();

  int consultantId;
  String? consultantName;

  ConsultantProfileScreen({required this.consultantId, required this.consultantName});
}

class _ConsultantProfileScreen extends State<ConsultantProfileScreen> {
  List<File> files = [];
  List<Comment> comments = [];

  bool showComment = false;
  bool moreDetail = false;
  bool showSearchBarWidget = true;
  bool showCommentWidget = false;

  late BuildContext scaffoldContext;

  TextEditingController searchController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  ConsultantProfileBloc bloc = ConsultantProfileBloc();
  ConsultantProfileCommentRateBloc sendCommentRateBloc = ConsultantProfileCommentRateBloc();
  FilesBloc filesBloc = FilesBloc();

  FilterData filterData = FilterData();

  ConsultantInfo? consultantInfo;

  String? comment;
  String title = "در حال بارگذاری...";
  double? rate;

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.consultantName != null) {
      setState(() => title = widget.consultantName!);
    }

    bloc.add(ConsultantProfileRequestEvent(widget.consultantId));

    sendCommentRateBloc.stream.listen((state) {
      if (state is ConsultantProfileCommentRateError) {
        notify(state.message ?? "خطایی در ثبت امتیاز/نظر پیش آمد.");
      }

      if (state is ConsultantProfileCommentRateSuccess && state.comment == null && !state.isReply) {
        notify("امتیاز شما ثبت شد");
      }
      if (state is ConsultantProfileCommentRateSuccess && state.comment != null && !state.isReply) {
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
    bloc.close();
    sendCommentRateBloc.close();
    filesBloc.close();
    super.dispose();
  }

  void setFilterData(ConsultantInfo consultantInfo) async {
    filterData = FilterData(cityIds: [consultantInfo.cityId ?? -1], consultantId: widget.consultantId);
    getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => filesBloc),
        BlocProvider(create: (_) => sendCommentRateBloc),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: appBar(),
        body: BlocConsumer<ConsultantProfileBloc, ConsultantProfileState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is ConsultantProfileSuccessState) {
              setState(() {
                consultantInfo = state.consultantInfo;
                title = state.consultantInfo.name!;
                comments = state.consultantInfo.comments ?? [];
              });
            }
          },
          builder: (context, state) {
            scaffoldContext = context;

            if (state is ConsultantProfileInitState) return Center(child: Loading());

            if (state is ConsultantProfileErrorState) return retryWidget(context, state.message);

            if (state is ConsultantProfileSuccessState) {
              setFilterData(state.consultantInfo);

              return profile(state.consultantInfo);
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _profileWidget() {
    return Container(
      color: Color(0xfffafbfd),
      width: 80,
      height: 80,
      alignment: Alignment.center,
      child: Icon(CupertinoIcons.person, color: Themes.primary, size: 34),
    );
  }

  Widget retryWidget(context, String message) {
    return Center(child: TryAgain(onPressed: () => retry(context), message: message));
  }
}
