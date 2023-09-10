import 'package:flutter/services.dart';
import 'package:siraf3/bloc/posts_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/post.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/screens/post_item.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';
import 'package:siraf3/widgets/pagination_loading.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import 'package:siraf3/main.dart';
import '../widgets/my_app_bar.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int? lastId;
  String? sort;
  List<Post> posts = [];
  bool _isLoadingMore = false;
  PostsBloc postsBloc = PostsBloc();
  PostsBloc _moreBloc = PostsBloc();
  ScrollController scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getPosts();

    postsBloc.stream.listen((event) {
      if (event is PostsLoadedState) {
        setState(() {
          lastId = event.lastId;
        });
      }
    });

    scrollController.addListener(pagination);
    scrollController.addListener(() {
      if (playingVideoController == null || !playingVideoController!.value.isPlaying) {
        return;
      }

      var screen_height = MediaQuery.of(context).size.height - 70;

      if ((playingPostIndex) * 340 > scrollController.position.pixels + screen_height || (playingPostIndex + 1) * 340 < scrollController.position.pixels) {
        playingVideoController!.pause();
        playingVideoController = null;
        playingPostIndex = -1;
      }
    });

    _moreBloc.stream.listen(_loadMoreListener);
  }

  void _loadMoreListener(PostsState event) {
    setState(() {
      _isLoadingMore = event is PostsLoadingState;
    });

    if (event is PostsLoadedState) {
      setState(() {
        posts.addAll(event.posts);

        lastId = event.lastId;
      });
    } else if (event is PostsErrorState) {
      notify("خطا در بارگزاری ادامه فایل ها رخ داد لطفا مجدد تلاش کنید");
    }
  }

  bool _canLoadMore() {
    return (scrollController.position.pixels == scrollController.position.maxScrollExtent) && lastId != null && !_isLoadingMore;
  }

  void pagination() async {
    if (_canLoadMore()) {
      if (_moreBloc.isClosed) {
        _moreBloc = PostsBloc();
      }
      _moreBloc.add(PostsEvent(lastId: lastId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: App.getSystemUiOverlay(),
      child: BlocProvider(
        create: (_) => postsBloc,
        child: Scaffold(
          appBar: MyAppBar(
            elevation: 0.7,
            title: TextField2(
              decoration: InputDecoration(
                hintText: "جستجو در آموزش های سیراف",
                hintStyle: TextStyle(color: App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey, fontSize: 13),
                border: InputBorder.none,
              ),
              controller: _searchController,
              style: TextStyle(color: App.theme.tooltipTheme.textStyle?.color ?? Themes.text, fontSize: 13),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                getPosts();
              },
            ),
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            leading: MyBackButton(),
            actions: [
              MyPopupMenuButton(
                iconData: Icons.sort_rounded,
                itemBuilder: (context) {
                  return [
                    MyPopupMenuItem<String>(
                      value: "newest",
                      label: "جدید ترین",
                      withSpace: true,
                      icon: sort == "newest" ? Icons.check_rounded : null,
                    ),
                    MyPopupMenuItem<String>(
                      value: "old",
                      label: "قدیمی ترین",
                      withSpace: true,
                      icon: sort == "old" ? Icons.check_rounded : null,
                    ),
                    MyPopupMenuItem<String>(
                      value: "bookMark",
                      label: "نشان شده ها",
                      withSpace: true,
                      icon: sort == "bookMark" ? Icons.check_rounded : null,
                    ),
                  ];
                },
                onSelected: (value) {
                  setState(() {
                    sort = value;
                  });
    
                  getPosts();
                },
              ),
              MyPopupMenuButton(
                itemBuilder: (context) {
                  return [MyPopupMenuItem<String>(value: "report", label: "گزارش تخلف")];
                },
                onSelected: (value) => callToSupport(),
                iconData: Icons.more_vert_rounded,
              ),
            ],
          ),
          body: BlocBuilder<PostsBloc, PostsState>(builder: _buildBloc),
        ),
      ),
    );
  }

  Widget _buildBloc(BuildContext context, PostsState state) {
    if (state is PostsInitState) return Container();

    if (state is PostsLoadingState) return Center(child: Loading());

    if (state is PostsErrorState) {
      var message = jDecode(state.response.body)['message'] as String?;

      return Center(
        child: TryAgain(onPressed: getPosts, message: message),
      );
    }

    posts = (state as PostsLoadedState).posts;

    return ListView(
      controller: scrollController,
      children: posts
              .map<Widget>(
                (e) => PostItem(
                  post: e,
                  onStartVideo: (vController) => onStartVideo(vController, e),
                ),
              )
              .toList() +
          [
            if (_isLoadingMore) PaginationLoading(),
          ],
    );
  }

  onStartVideo(vController, e) {
    var index = posts.lastIndexWhere((element) => element.id == e.id);

    setState(() {
      playingPostIndex = index;
      playingVideoController = vController;
    });
  }

  int playingPostIndex = -1;
  VideoPlayerController? playingVideoController;

  getPosts() {
    var searchText = _searchController.text.trim().isEmpty ? null : _searchController.text;
    postsBloc.add(PostsEvent(search: searchText, sort: sort));
  }
}
