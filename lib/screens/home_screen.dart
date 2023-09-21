import 'dart:async';
import 'dart:convert';

import 'package:badges/badges.dart' as badges;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/bloc/home_screen_bloc.dart';
import 'package:siraf3/firebase_listener.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/main.dart';
import 'package:siraf3/models/city.dart' as city;
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/filter_data.dart';
import 'package:siraf3/models/home_item.dart';
import 'package:siraf3/models/post.dart';
import 'package:siraf3/models/request.dart';
import 'package:siraf3/models/ticket.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/rabbit_mq_consum.dart';
import 'package:siraf3/rabbit_mq_data.dart';
import 'package:siraf3/screens/chat/chat/chatScreen/chat_screen.dart';
import 'package:siraf3/screens/consultant_profile_without_comment/consultant_profile_screen.dart';
import 'package:siraf3/screens/estate_profile_without_comment/estate_profile_screen.dart';
import 'package:siraf3/screens/file_screen.dart';
import 'package:siraf3/screens/filter_screen.dart';
import 'package:siraf3/screens/learn_screen.dart';
import 'package:siraf3/screens/menu_screen.dart';
import 'package:siraf3/screens/my_file_screen.dart';
import 'package:siraf3/screens/post_item.dart';
import 'package:siraf3/screens/request_file/request_file_show_screen.dart';
import 'package:siraf3/screens/search_screen.dart';
import 'package:siraf3/screens/select_city_screen.dart';
import 'package:siraf3/screens/ticket/ticket_chat/ticket_chat_screen.dart';
import 'package:siraf3/settings.dart';
import 'package:siraf3/widgets/empty.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/file_slide_item.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:uni_links/uni_links.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  MaterialPageRoute? nextScreen;

  HomeScreen({this.nextScreen, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  bool get wantKeepAlive => true;

  FilterData filterData = FilterData();

  @override
  void initState() {
    super.initState();

    checkInitialLink();
    listenLink();

    homeScreenBloc = BlocProvider.of<HSBloc>(context);

    checkScreen();

    getViewType();

    scrollController.addListener(pagination);
    scrollController.addListener(postVideosListener);

    homeScreenBloc.stream.listen((event) {
      try {
        setState(() => currentBlocState = event);

        if (event is HSLoadedState) {
          setState(() {
            lastId = event.lastId;
            contentLastId = event.contentLastId;
            currentBlocState = event;
            items = event.homeItems;
          });
        }
      } catch (e) {}
    });

    _moreBloc.stream.listen(_loadMoreEvent);

    listenNotification();

    consumRabbitMq();
    listenRabbitData();

    scrollController.addListener(() {
      if (playingVideoController == null || !playingVideoController!.value.isPlaying) {
        return;
      }

      var screen_height = MediaQuery.of(context).size.height - 70;

      int space = 0;

      var newList = items.sublist(0, playingPostIndex + 1)
        ..forEach((element) {
          space += element.type == Type.File ? 122 : 340;
        });

      if (space - 340 > scrollController.position.pixels + screen_height || space < scrollController.position.pixels) {
        playingVideoController!.pause();
        playingVideoController = null;
        playingPostIndex = -1;
      }
    });

    addDevice();

    listenNotification(onSelectNotification: onSelectNotification);

    checkNotificationClicked();

    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
        resumeCallBack: () async => setState(() {
              checkNotificationClicked();
            })));

    if (widget.nextScreen != null) {
      Future.delayed(Duration.zero, () {
        Navigator.push(context, widget.nextScreen!);
      });
    }
  }

  var notifications_handled = [];

  checkNotificationClicked() async {
    var initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      if (notifications_handled.contains(initialMessage.messageId)) return;

      notifications_handled.add(initialMessage.messageId);
      onSelectNotification(jsonEncode(initialMessage.data));
    }
  }

  Future onSelectNotification(String? pStr) async {
    if (pStr == null) return;
    var payload = jsonDecode(pStr) as Map<String, dynamic>;
    if (!payload.containsKey("type")) return;

    copy("___________PAYLOAD____________");
    copy(jsonEncode(payload));

    switch (payload['type']) {
      case 'ticket':
        var data = jsonDecode(jsonEncode(payload['ticket_id']));
        data = data is String ? jsonDecode(data) : data;

        var ticket = Ticket.fromJson(data);

        push(
          context,
          TicketChatScreen(
            ticket: ticket,
          ),
        );
        break;
      case 'chat':
        push(
          context,
          ChatScreen(
            chatId: int.parse(
              payload['chat_id'].toString(),
            ),
          ),
        );
        break;
      case 'my_file':
        var data = jsonDecode(jsonEncode(payload['file_id']));
        data = data is String ? jsonDecode(data) : data;

        push(
          context,
          MyFileScreen(
            id: data['id'],
            progress: data['progress'],
          ),
        );
        break;
      case 'my_request':
        var data = jsonDecode(jsonEncode(payload['request_id']));
        data = data is String ? jsonDecode(data) : data;

        var request = Request.fromJson(data);

        push(
          context,
          RequestFileShowScreen(
            request: request,
          ),
        );
        break;
    }
  }

  int playingPostIndex = -1;
  VideoPlayerController? playingVideoController;

  HSBloc _moreBloc = HSBloc();

  int? lastId;
  int? contentLastId;

  bool _isLoadingMore = false;

  List<HomeItem> items = [];

  bool _canLoadMore() {
    return (scrollController.position.pixels == scrollController.position.maxScrollExtent) && lastId != null && !_isLoadingMore;
  }

  void pagination() async {
    if (_canLoadMore()) {
      if (_moreBloc.isClosed) {
        _moreBloc = HSBloc();
      }
      _moreBloc.add(HSLoadEvent(filterData: filterData, lastId: lastId!, contentLastId: contentLastId));
    }
  }

  void _loadMoreEvent(HSState event) {
    setState(() {
      _isLoadingMore = event is HSLoadingState;
    });

    if (event is HSLoadedState) {
      setState(() {
        items.addAll(event.homeItems);

        lastId = event.lastId;
        contentLastId = event.contentLastId;
      });
    } else if (event is HSErrorState) {
      notify("خطا در بارگزاری ادامه فایل ها رخ داد لطفا مجدد تلاش کنید");
    }
  }

  ScrollController scrollController = ScrollController();

  List<city.City> cities = [];

  late HSBloc homeScreenBloc;

  checkScreen() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getBool("isFirstOpen") ?? true) {
      await sharedPreferences.setBool("isFirstOpen", false);
      goSelectCity();
      return;
    }

    var mCities = await city.City.getList();
    setState(() {
      cities = mCities;

      filterData = filterData..cityIds = cities.map<int>((e) => e.id!).toList();
    });
    getFiles();
  }

  ViewType viewType = ViewType.List;

  getViewType() async {
    var sh = await SharedPreferences.getInstance();

    setState(() {
      viewType = sh.getString("FILE_VIEW_TYPE") != null
          ? sh.getString("FILE_VIEW_TYPE") == "list"
              ? ViewType.List
              : ViewType.Slide
          : ViewType.List;
    });
  }

  changeViewType() async {
    var sh = await SharedPreferences.getInstance();
    sh.setString("FILE_VIEW_TYPE", viewType == ViewType.List ? "slide" : "list");

    await getViewType();

    getFiles();
  }

  goSelectCity({showSelected = false}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => SelectCityScreen(
                  showSelected: showSelected,
                  force: true,
                )));
  }

  openMenu() async {
    closeRabbit();
    await Navigator.push(context, MaterialPageRoute(builder: (_) => MenuScreen()));

    setState(() {});

    Future.delayed(Duration(milliseconds: 200), () {
      consumRabbitMq();
      listenRabbitData();
    });
  }

  @override
  void dispose() {
    closeRabbit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: App.getSystemUiOverlay(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.7,
          title: GestureDetector(
            onTap: () => goSelectCity(showSelected: true),
            child: Text(
              getTitle(cities),
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: openMenu,
              icon: badges.Badge(
                badgeContent: Text(''),
                showBadge: hasNewMessage,
                position: badges.BadgePosition.custom(top: -17, start: -4),
                badgeStyle: badges.BadgeStyle(badgeColor: App.theme.primaryColor),
                child: Icon(
                  Icons.menu_rounded,
                  color: App.theme.iconTheme.color,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FilterScreen(
                      originalFilterData: FilterData(cityIds: cities.map<int>((e) => e.id!).toList()),
                      filterData: filterData,
                      total_url: getFileUrl('file/files/').toString(),
                    ),
                  ),
                );

                if (result != null && result is FilterData) {
                  setState(() {
                    filterData = result;
                  });

                  getFiles();
                }
              },
              icon: badges.Badge(
                badgeContent: Text(''),
                showBadge: filterData.hasFilter(),
                position: badges.BadgePosition.custom(top: -15, start: -10),
                badgeStyle: badges.BadgeStyle(badgeColor: App.theme.primaryColor),
                child: FaIcon(
                  OctIcons.sliders_16,
                  size: 20,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                var originalFilterData = this.filterData;
                var filterData = this.filterData;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchScreen(
                      originalFilterData: originalFilterData,
                      filterData: filterData,
                    ),
                  ),
                );
              },
              icon: FaIcon(
                CupertinoIcons.search,
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentBlocState is HSInitState || currentBlocState is HSLoadingState)
              Center(
                child: Loading(),
              ),
            if (currentBlocState is HSErrorState)
              Center(
                child: TryAgain(
                  onPressed: getFiles,
                  message: (currentBlocState as HSErrorState).response != null ? jDecode((currentBlocState as HSErrorState).response!.body)['message'] : null,
                ),
              ),
            if (currentBlocState is HSLoadedState && (currentBlocState as HSLoadedState).homeItems.isEmpty) Center(child: Empty(message: "موردی یافت نشد")),
            if (currentBlocState is HSLoadedState && (currentBlocState as HSLoadedState).homeItems.isNotEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    filterData.search = null;
                    getFiles();
                  },
                  color: App.theme.primaryColor,
                  child: ListView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    children: items
                            .map<Widget>(
                              (item) => item.type == Type.File ? fileItem(item.file!) : postItem(item, item.post!),
                            )
                            .toList() +
                        [
                          if (_isLoadingMore)
                            Align(
                              alignment: Alignment.center,
                              child: Loading(
                                backgroundColor: Colors.transparent,
                              ),
                            )
                        ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget fileItem(File file) {
    return GestureDetector(
      onTap: () {
        playingVideoController?.pause();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FileScreen(id: file.id!),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: items.first == file ? 0 : 5),
        child: viewType == ViewType.List ? FileHorizontalItem(file: file) : FileSlideItem(file: file),
      ),
    );
  }

  Widget postItem(HomeItem item, Post post) {
    return PostItem(
      post: post,
      onStartVideo: (vController) => onStartVideo(vController, item),
    );
  }

  onStartVideo(vController, HomeItem e) {
    var index = items.lastIndexWhere((element) => element.post?.id == e.post?.id);

    setState(() {
      playingPostIndex = index;
      playingVideoController = vController;
    });
  }

  void _scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  HSState currentBlocState = HSInitState();

  getFiles() {
    if (homeScreenBloc.isClosed) {
      homeScreenBloc = HSBloc();
    }
    homeScreenBloc.add(
      HSLoadEvent(
        filterData: filterData,
      ),
    );
  }

  String getTitle(List<city.City> cities) {
    return cities.isEmpty
        ? "انتخاب شهر"
        : cities.length == 1
            ? cities.first.name ?? "${cities.length} شهر"
            : "${cities.length} شهر";
  }

  Future<void> checkInitialLink() async {
    if (!initialURILinkHandled) {
      initialURILinkHandled = true;
      final uri = await getInitialUri();
      if (uri != null) {
        if (!mounted) return;

        RegExp reg = new RegExp(r'https://siraf.app/files/([0-9]+)');

        if (reg.hasMatch(uri.toString())) {
          var match = reg.firstMatch(uri.toString());
          var id = match!.group(1);

          if (id == null) {
            return;
          }

          playingVideoController?.pause();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FileScreen(
                id: int.parse(id),
              ),
            ),
          );

          return;
        }

        reg = new RegExp(r'https://siraf.app/real-estate/consultant/([0-9]+)');

        if (reg.hasMatch(uri.toString())) {
          var match = reg.firstMatch(uri.toString());
          var id = match!.group(1);

          if (id == null) {
            return;
          }

          playingVideoController?.pause();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ConsultantProfileScreen(
                consultantId: int.parse(id),
                consultantName: null,
              ),
            ),
          );
          return;
        }
        reg = new RegExp(r'https://siraf.app/real-estate/agency/([0-9]+)');

        if (reg.hasMatch(uri.toString())) {
          var match = reg.firstMatch(uri.toString());
          var id = match!.group(1);

          if (id == null) {
            return;
          }

          playingVideoController?.pause();

          push(
            context,
            EstateProfileScreen(estateId: int.parse(id)),
          );
          return;
        }

        reg = new RegExp(r'https://siraf.app/contents/([0-9]+)');

        if (reg.hasMatch(uri.toString())) {
          var match = reg.firstMatch(uri.toString());
          var id = match!.group(1);

          if (id == null) {
            return;
          }

          playingVideoController?.pause();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LearnScreen(),
            ),
          );

          return;
        }
      }
    }
  }

  void listenLink() {
    uriLinkStream.listen((Uri? uri) {
      if (!mounted) return;

      RegExp reg = new RegExp(r'https://siraf.app/files/([0-9]+)');

      if (reg.hasMatch(uri.toString())) {
        var match = reg.firstMatch(uri.toString());
        var id = match!.group(1);

        if (id == null) {
          return;
        }

        playingVideoController?.pause();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FileScreen(
              id: int.parse(id),
            ),
          ),
        );

        return;
      }

      reg = new RegExp(r'https://siraf.app/real-estate/consultant/([0-9]+)');

      if (reg.hasMatch(uri.toString())) {
        var match = reg.firstMatch(uri.toString());
        var id = match!.group(1);

        if (id == null) {
          return;
        }

        playingVideoController?.pause();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ConsultantProfileScreen(
              consultantId: int.parse(id),
              consultantName: null,
            ),
          ),
        );
        return;
      }

      reg = new RegExp(r'https://siraf.app/real-estate/agency/([0-9]+)');

      if (reg.hasMatch(uri.toString())) {
        var match = reg.firstMatch(uri.toString());
        var id = match!.group(1);

        if (id == null) {
          return;
        }

        playingVideoController?.pause();
        push(context, EstateProfileScreen(estateId: int.parse(id)));
        return;
      }
    }, onError: (Object err) {
      if (!mounted) {
        return;
      }
      notify("لینک قابل پردازش نیست");
    });
  }

  void listenRabbitData() {
    hasNewMessageStream.close();
    hasNewMessageStream = StreamController<bool>();

    hasNewMessageStream.stream.listen((event) {
      setState(() {});
    });
  }

  void postVideosListener() {
    if (currentPost != null) {
      currentVideoController?.pause();
      currentPost = null;

      setState(() {});
    }
  }

  VideoPlayerController? currentVideoController;
  Post? currentPost;

  void addDevice() async {
    if (await User.hasToken() && await Settings().showNotification()) {
      await http2.postJsonWithToken(
        Uri.parse("https://message.siraf.app/api/fireBase/addDevice/"),
        body: {
          "token": (await FirebaseMessaging.instance.getToken()).toString(),
          "userId": (await User.fromLocal()).id,
        },
      );
    }
  }
}

enum ViewType {
  List,
  Slide;
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback? resumeCallBack;
  final AsyncCallback? suspendingCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack!();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (suspendingCallBack != null) {
          await suspendingCallBack!();
        }
        break;
    }
  }
}
