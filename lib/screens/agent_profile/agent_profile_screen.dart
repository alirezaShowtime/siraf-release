import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:siraf3/bloc/agent_profile_comment/agent_profile_comment_rate_bloc.dart';
import 'package:siraf3/bloc/files_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/consultant_info.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/screens/filter_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/my_text_icon_button.dart';
import 'package:siraf3/widgets/static_star.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:siraf3/models/city.dart' as city;

import '../../bloc/agent_profile/agent_profile_bloc.dart';
import '../../widgets/file_horizontal_item.dart';

part 'add_comment_widget.dart';

part 'answer_item.dart';

part 'appbar.dart';

part 'comment_item.dart';

part 'event_listeners.dart';

part 'my_card.dart';

part 'profile.dart';

part 'profile_detail.dart';

part 'search_bar.dart';

part 'widgets.dart';

class AgentProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AgentProfileScreen();

  int consultantId;
  String? name;

  //todo: important , remove default value of consultantId variable and required
  AgentProfileScreen({required this.consultantId, required this.name});
}

class _AgentProfileScreen extends State<AgentProfileScreen>
    with SingleTickerProviderStateMixin {
  List<File> files = [];

  bool showComment = false;

  bool moreDetail = false;

  bool showSearchBarWidget = true;
  bool showCommentWidget = false;

  late AnimationController collopsController;
  late Animation<double> collopsAnimation;

  late BuildContext scaffoldContext;

  TextEditingController searchController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  AgentProfileBloc bloc = AgentProfileBloc();
  AgentProfileCommentRateBloc commentRateBloc = AgentProfileCommentRateBloc();
  FilesBloc filesBloc = FilesBloc();
  FilterData filterData = FilterData();

  ConsultantInfo? consultantInfo;

  String? comment;
  String title = "در حال بارگذاری...";
  double? rating;

  @override
  void initState() {
    super.initState();

    collopsController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    collopsAnimation =
        CurvedAnimation(parent: collopsController, curve: Curves.fastOutSlowIn);

    collopsController.addListener(_collopsControllerListener);

    bloc.add(AgentProfileLoad(widget.consultantId));
  }

  @override
  void dispose() {
    super.dispose();
    collopsController.removeListener(_collopsControllerListener);
  }


  void setFilterData(ConsultantInfo consultantInfo) async {
    filterData = FilterData(
        cityIds: [consultantInfo.cityId ?? -1],
        consultantId: widget.consultantId);
    getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => filesBloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: appBar(),
        body: BlocConsumer<AgentProfileBloc, AgentProfileState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is AgentProfileSuccessState) {
              setState(() {
                consultantInfo = state.consultantInfo;
                title = state.consultantInfo.name!;
              });
            }
          },
          builder: (context, state) {
            scaffoldContext = context;

            if (state is AgentProfileInitState) return Center(child: Loading());

            if (state is AgentProfileErrorState)
              return retryWidget(context, state.message);

            if (state is AgentProfileSuccessState) {
              setFilterData(state.consultantInfo);
              return profile(state.consultantInfo);
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _collopsControllerListener() {
    if (collopsController.isDismissed && !showComment) {
      showSearchBarWidget = true;
    }
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
}
