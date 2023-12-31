import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:siraf3/bloc/add_violation_bloc.dart';
import 'package:siraf3/bloc/file_bloc.dart';
import 'package:siraf3/bloc/related_files_bloc.dart';
import 'package:siraf3/bookmark.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file.dart';
import 'package:siraf3/models/file_detail.dart';
import 'package:siraf3/screens/file_images_screen.dart';
import 'package:siraf3/screens/support_file_screen.dart';
import 'package:siraf3/screens/webview_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/collapsable.dart';
import 'package:siraf3/widgets/custom_slider.dart';
import 'package:siraf3/widgets/file_horizontal_item.dart';
import 'package:siraf3/widgets/file_related_item.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_icon_button.dart';
import 'package:siraf3/widgets/simple_map.dart';
import 'package:siraf3/widgets/slider.dart' as s;
import 'package:siraf3/widgets/try_again.dart';
import 'package:siraf3/main.dart';

class FileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FileScreen();

  int id;

  FileScreen({required this.id, super.key});
}

class _FileScreen extends State<FileScreen> {
  bool expand = false;
  bool secDescExpand = false;
  late ScrollController _scrollController;
  late String imageName;
  var toolbarSetState;
  List<s.Slider> sliders = [];
  FileBloc fileBloc = FileBloc();
  AddViolationBloc addViolationBloc = AddViolationBloc();
  RelatedFilesBloc relatedFilesBloc = RelatedFilesBloc();

  late Bookmark bookmark;
  List<File> relatedFiles = [];

  bool get _isSliverAppBarCollapsed {
    return _scrollController.hasClients && _scrollController.offset > (200 - kToolbarHeight);
  }

  void setSliders(FileDetail file) async {
    var data = await file.getSliders();
    setState(() {
      sliders = data;
    });
  }

  @override
  void initState() {
    super.initState();

    fileBloc.add(FileFetchEvent(id: widget.id));
    relatedFilesBloc.add(RelatedFilesEvent(id: widget.id));

    _scrollController = ScrollController()..addListener(() => toolbarSetState?.call(() {}));

    fileBloc.stream.listen((state) async {
      if (state is! FileLoadedState) return;
      setSliders(state.file);

      try {
        imageName = state.file.media!.images!.first.name!.trim();
      } catch (e) {
        imageName = "";
      }
    });

    addViolationBloc.stream.listen((state) {
      if (state is AddViolationLoadingState) {
        loadingDialog(context: context);
      }
      if (state is AddViolationErrorState) {
        dismissDialog(loadingDialogContext);
        notify(state.message);
      }
      if (state is AddViolationSuccessState) {
        dismissDialog(loadingDialogContext);
        notify("تخلف با موفقیت ثبت شد");
      }
    });
  }

  @override
  void dispose() {
    fileBloc.close();
    addViolationBloc.close();
    relatedFilesBloc.close();
    super.dispose();
  }

  bool isBookmark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer(
        bloc: fileBloc,
        listener: (context, state) {
          if (state is! FileLoadedState) return;

          bookmark = Bookmark(
            id: widget.id,
            context: context,
            isFavorite: state.favorite,
          );

          setState(() {
            isBookmark = state.favorite;
          });

          bookmark.favoriteStream.stream.listen((event) {
            setState(() {
              isBookmark = event;
            });
          });
        },
        builder: (context, state) {
          if (state is FileLoadingState || state is FileInitState) return Center(child: Loading());

          if (state is FileErrorState)
            return Center(
              child: TryAgain(
                message: state.message,
                onPressed: () {
                  fileBloc.add(FileFetchEvent(id: widget.id));
                },
              ),
            );

          state as FileLoadedState;

          return NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  systemOverlayStyle: App.getSystemUiOverlayTransparentLight(),
                  expandedHeight: 260,
                  elevation: 0.7,
                  backgroundColor: App.theme.backgroundColor,
                  leading: MyBackButton(color: Colors.white, shadow: true),
                  flexibleSpace: FlexibleSpaceBar(background: _buildSliders(state.file)),
                ),
                StatefulBuilder(builder: (context, setState) {
                  toolbarSetState = setState;
                  return SliverAppBar(
                    systemOverlayStyle: App.getSystemUiOverlay(),
                    elevation: 0.7,
                    backgroundColor: App.theme.backgroundColor,
                    titleSpacing: 0,
                    leading: _isSliverAppBarCollapsed ? MyBackButton() : SizedBox(),
                    leadingWidth: _isSliverAppBarCollapsed ? null : 0,
                    collapsedHeight: 60,
                    expandedHeight: 60,
                    pinned: true,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_isSliverAppBarCollapsed) SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.file.name!,
                                style: TextStyle(
                                  fontSize: _isSliverAppBarCollapsed ? 13 : 15,
                                  fontFamily: "IranSansBold",
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      state.file.fullCategory?.fullCategory ?? "",
                                      style: TextStyle(
                                        color: App.theme.textTheme.bodyLarge?.color,
                                        fontFamily: "IranSansMedium",
                                        fontSize: _isSliverAppBarCollapsed ? 10 : 11,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${state.file.city!.name} | ${state.file.publishedAgo} ",
                                    style: TextStyle(
                                      color: App.theme.tooltipTheme.textStyle?.color,
                                      fontFamily: "IranSansMedium",
                                      fontSize: _isSliverAppBarCollapsed ? 9 : 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => shareFile(state.file.name!),
                        icon: icon(Icons.share_rounded),
                      ),
                      IconButton(
                        onPressed: () => doWithLogin(context, () {
                          bookmark.addOrRemoveFavorite();
                        }),
                        icon: icon(isBookmark ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark),
                      ),
                    ],
                  );
                }),
              ];
            },
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView(
                      children: [
                        Text(
                          "${state.file.isRental() ? 'ودیعه' : 'قیمت کل'} : ${state.file.isRental() ? state.file.getVadieStr() : state.file.getPriceStr()}",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "IranSansBold",
                          ),
                        ),
                        Text(
                          "${state.file.isRental() ? 'اجاره' : 'قیمت هر متر'} : ${state.file.isRental() ? state.file.getRentStr() : state.file.getPricePerMeter()}",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "IranSansBold",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: _buildMainProps(state.file),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            state.file.description.isFill() ? state.file.description! : "فاقد توضیحات",
                            style: TextStyle(
                              fontFamily: "IranSansMedium",
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        if (state.file.getOtherProperties().isFill())
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: App.isDark ? Color.fromARGB(255, 46, 54, 63) : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            foregroundDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(color: App.isDark ? Color.fromARGB(255, 46, 54, 63) : Colors.grey.shade200, width: 2.0),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () => setState(() => expand = !expand),
                                  child: Container(
                                    height: 50,
                                    padding: EdgeInsets.only(right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "سایر ویژگی ها و امکانات",
                                          style: TextStyle(fontFamily: "IranSansBold", fontSize: 12),
                                        ),
                                        AnimatedRotation(
                                          duration: Duration(milliseconds: 400),
                                          turns: expand ? 0 : -.5,
                                          child: MyIconButton(
                                            onTap: () => setState(() => expand = !expand),
                                            iconData: Icons.keyboard_arrow_up_rounded,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Collapsable(
                                  expand: expand,
                                  child: Column(
                                    children: [
                                      for (var item in state.file.getOtherProperties())
                                        propertyItemWidget(
                                          title: item.name.toString(),
                                          value: noneOr(item.value),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (state.file.lat.isFill() && state.file.long.isFill())
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: SimpleMap(
                              lat: state.file.lat!.toDouble(),
                              long: state.file.long!.toDouble(),
                              width: double.infinity,
                              hidden: true,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        BlocBuilder(
                          bloc: relatedFilesBloc,
                          builder: _buildRelatedBloc,
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20, bottom: 10),
                          child: GestureDetector(
                            onTap: () => doWithLogin(context, () => showViolationDialog()),
                            child: Text(
                              "ثبت تخلف و مشکل فایل",
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: "IranSansMedium",
                                decoration: TextDecoration.underline,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: App.theme.dialogBackgroundColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(0.23),
                        offset: Offset(0, 1),
                        blurRadius: 5,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Material(
                    color: App.theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () => onClickCall(state.file, state.favorite),
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "تماس | پیام",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: "IranSansBold",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainProps(FileDetail file) {
    List<Widget> items = [];

    var a = file
        .getMainProperties()
        .map<List<Widget>>(
          (e) => [
            _buildPropItem(noneOr(e.value), e.name!),
            if (file.getMainProperties().last != e) VerticalDivider(width: 1.5, color: Colors.grey.shade300),
          ],
        )
        .toList();

    for (List<Widget> item in a) items += item;

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildPropItem(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            color: App.theme.textTheme.bodyLarge?.color,
            fontFamily: "IranSansBold",
            fontSize: 13,
          ),
        ),
        SizedBox(height: 5),
        Text(
          label.split(r" ").take(2).join(" "),
          style: TextStyle(
            color: Colors.grey,
            fontFamily: "IranSansMedium",
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildSliders(FileDetail file) {
    return Container(
      color: Colors.grey.shade50,
      child: Stack(
        children: [
          if (!file.media!.images.isFill() && !file.media!.video.isFill() && !file.media!.virtualTour.isFill())
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: App.theme.backgroundColor,
                image: DecorationImage(image: AssetImage(IMAGE_NOT_AVAILABLE), alignment: Alignment.center),
              ),
            ),
          if (file.media!.images.isFill() || file.media!.video.isFill() || file.media!.virtualTour.isFill())
            CarouselSliderCustom(
              sliders: sliders,
              autoPlay: false,
              height: 300,
              indicatorsCenterAlign: true,
              viewportFraction: 1.0,
              itemMargin: EdgeInsets.zero,
              float: true,
              indicatorMargin: EdgeInsets.only(left: 0, right: 0, bottom: 18),
              itemBorderRadius: BorderRadius.zero,
              imageFit: BoxFit.cover,
              indicatorSelectedColor: Themes.blue,
              indicatorColor: Colors.white,
              directPlay: true,
              onPageChanged: (i, slide) {
                setState(() {
                  imageName = slide.name ?? "";
                });
              },
              onImageTap: (s.Slider slider) {
                if (slider.type == s.SliderType.image) {
                  push(context, FileImagesScreen(file: file, index: sliders.indexOf(slider)));
                }
                if (slider.type == s.SliderType.virtual_tour) {
                  push(
                    context,
                    WebViewScreen(title: file.name ?? "", url: slider.link!),
                  );
                }
              },
            ),
          if (imageName.isFill())
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(7)),
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
                child: Text(
                  imageName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: "IranSansMedium",
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 5,
            left: 5,
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(7)),
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              child: Text(
                "کد فایل : ${widget.id}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: "IranSansMedium",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget propertyItemWidget({required String title, required String value}) {
    return Container(
      width: double.infinity,
      color: App.theme.dialogBackgroundColor,
      height: 40,
      margin: EdgeInsets.only(bottom: 2, left: 2, right: 2),
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerRight,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontFamily: "IranSansBold",
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontFamily: "IranSansBold",
            ),
          ),
        ],
      ),
    );
  }

  void showViolationDialog() {
    violationDialog(
      context,
      (title, description) {
        addViolationBloc.add(
          AddViolationEvent(
            title: title,
            body: description,
            fileId: widget.id,
          ),
        );
      },
    );
  }

  void shareFile(String fileName) async {
    await FlutterShare.share(
      title: 'اشتراک گذاری فایل',
      text: fileName,
      linkUrl: FILE_URL + widget.id.toString(),
      chooserTitle: 'اشتراک گذاری در',
    );
  }

  void onClickCall(FileDetail file, bool isFavorite) async {
    var result = await push(
      context,
      SupportFileScreen(
        file: file,
        isFavorite: isFavorite,
        id: widget.id,
      ),
    );

    if (result is! bool) return;
    setState(() {
      isFavorite = result;
    });
  }

  Widget _buildRelatedBloc(BuildContext context, RelatedFilesState state) {
    if (state is RelatedFilesInitState) return Container();

    if (state is RelatedFilesLoadingState) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        alignment: Alignment.center,
        child: Loading(),
      );
    }

    if (state is RelatedFilesErrorState) return Container();

    state = (state as RelatedFilesLoadedState);

    relatedFiles = state.files;

    if (relatedFiles.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: Text(
            "فایل های مشابه",
            style: TextStyle(fontSize: 12, fontFamily: "IranSansBold"),
          ),
        ),
        Container(
          height: 110,
          margin: EdgeInsets.only(top: 10),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var relatedFile in relatedFiles)
                Container(
                  height: 140,
                  width: MediaQuery.of(context).size.width - 50,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: () => push(context, FileScreen(id: relatedFile.id!)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FileRelatedItem(
                        file: relatedFile,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
