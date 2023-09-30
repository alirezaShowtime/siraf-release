import 'package:siraf3/bloc/delete_file_bloc.dart';
import 'package:siraf3/bloc/extension_file_bloc.dart';
import 'package:siraf3/bloc/my_file_bloc.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file_consultant.dart';
import 'package:siraf3/models/file_detail.dart';
import 'package:siraf3/models/my_file_detail.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/file_images_screen.dart';
import 'package:siraf3/screens/edit/edit_file_first.dart';
import 'package:siraf3/screens/webview_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/collapsable.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';
import 'package:siraf3/widgets/custom_slider.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_icon_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';
import 'package:siraf3/widgets/simple_map.dart';
import 'package:siraf3/widgets/slider.dart' as s;
import 'package:siraf3/widgets/static_star.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';

import 'package:siraf3/main.dart';
import 'consultant_profile_without_comment/consultant_profile_screen.dart';
import 'file_view_chart_screen.dart';

class MyFileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyFileScreen();
  int id;
  int progress;

  MyFileScreen({required this.id, required this.progress, super.key});
}

class _MyFileScreen extends State<MyFileScreen> {
  bool expand = false;
  bool secDescExpand = false;
  bool rejectDescExpand = false;
  late ScrollController _scrollController;
  late String imageName;
  var toolbarSetState;
  List<s.Slider> sliders = [];

  MyFileBloc fileBloc = MyFileBloc();
  DeleteFileBloc deleteFileBloc = DeleteFileBloc();
  ExtensionFileBloc expBloc = ExtensionFileBloc();

  Map<int, String> progressFa = {
    1: "در انتظار تایید",
    2: "رد شده",
    3: "رد شده",
    4: "تایید شده",
    5: "در انتظار پذیرش",
    6: "پذیرش نشده",
    7: "پذیرش شده",
  };

  Map<int, Color> progressColor = {
    1: Colors.indigo,
    2: Colors.red,
    3: Colors.red,
    4: Colors.green,
    5: Colors.indigo,
    6: Colors.red,
    7: Colors.green,
  };

  bool get _isSliverAppBarCollapsed {
    return _scrollController.hasClients && _scrollController.offset > (200 - kToolbarHeight);
  }

  void setSliders(MyFileDetail file) async {
    var data = await file.getSliders();
    setState(() {
      sliders = data;
    });
  }

  @override
  void initState() {
    super.initState();

    fileBloc.add(MyFileFetchEvent(id: widget.id, progress: widget.progress));

    _scrollController = ScrollController()..addListener(() => toolbarSetState?.call(() {}));

    fileBloc.stream.listen((state) async {
      if (state is! MyFileLoadedState) return;
      setSliders(state.file);

      try {
        imageName = state.file.media!.image!.first.name!.trim();
      } catch (e) {
        imageName = "";
      }
    });

    deleteFileBloc.stream.listen((event) {
      if (event is DeleteFileLoadingState) {
        loadingDialog(context: context, message: "در حال حذف فایل هستیم لطفا شکیبا باشید");
      }
      if (event is DeleteFileErrorState) {
        dismissDialog(loadingDialogContext);
        notify("خطا در حذف فایل رخ داد لطفا مجدد تلاش کنید");
      }
      if (event is DeleteFileSuccessState) {
        dismissDialog(loadingDialogContext);
        notify("فایل با موفقیت حذف شد");
        Navigator.pop(context, "refresh");
      }
    });

    expBloc.stream.listen((event) {
      if (event is ExtensionFileLoadingState) {
        loadingDialog(context: context);
      } else if (event is ExtensionFileErrorState) {
        dismissDialog(loadingDialogContext);
        notify(event.message);
      } else if (event is ExtensionFileSuccessState) {
        notify("تمدید فایل با موفقیت انجام شد");
        setState(() {
          file.expireDay = (file.expireDay??0) + 30;
        });
      }
    });
  }

  late MyFileDetail file;

  @override
  void dispose() {
    fileBloc.close();
    deleteFileBloc.close();
    super.dispose();
  }

  // Text(
  //   "بازدید : ${widget.file.viewCount}",
  //   style: TextStyle(
  //     color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
  //     fontSize: 10.5,
  //     fontWeight: FontWeight.w400,
  //     fontFamily: 'IranSans',
  //   ),
  // ),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder(
        bloc: fileBloc,
        builder: (context, state) {
          if (state is MyFileLoadingState || state is MyFileInitState) return Center(child: Loading());

          if (state is MyFileErrorState)
            return Center(
              child: TryAgain(
                message: state.message,
                onPressed: () {
                  fileBloc.add(MyFileFetchEvent(id: widget.id, progress: widget.progress));
                },
              ),
            );

          state as MyFileLoadedState;

          file = state.file;

          return NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  systemOverlayStyle: App.getSystemUiOverlayTransparentLight(),
                  expandedHeight: 260,
                  elevation: 0.7,
                  backgroundColor: App.theme.dialogBackgroundColor,
                  leading:
                      MyBackButton(color: (state.file.media?.isFill() ?? false ? (App.theme.canvasColor) : App.theme.iconTheme.color ?? Colors.black), shadow: state.file.media?.isFill() ?? false),
                  actions: appBarActions(state.file, (state.file.media?.isFill() ?? false ? (App.theme.canvasColor) : App.theme.iconTheme.color ?? Colors.black),
                      shadow: state.file.media?.isFill() ?? false),
                  flexibleSpace: FlexibleSpaceBar(background: _buildSliders(state.file)),
                ),
                StatefulBuilder(
                  builder: (context, setState) {
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
                                    Container(
                                      height: 18,
                                      constraints: BoxConstraints(minWidth: 20),
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: progressColor[state.file.progress]?.withOpacity(0.2) ?? Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            color: progressColor[state.file.progress],
                                            size: 11,
                                          ),
                                          SizedBox(width: 2),
                                          Text(
                                            progressFa[state.file.progress] ?? "",
                                            style: TextStyle(
                                              color: progressColor[state.file.progress],
                                              fontFamily: "IranSansBold",
                                              fontSize: 9,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "${state.file.city} | ${state.file.publishedAgo}" + (widget.progress == 7 ? "\nبازدید : ${state.file.viewCount}" : ""),
                                      style: TextStyle(
                                        color: Colors.grey,
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
                      actions: <Widget>[
                            if (widget.progress == 7)
                              IconButton(
                                onPressed: () => shareFile(state.file.name!),
                                icon: Icon(Icons.share_rounded),
                              ),
                          ] +
                          (_isSliverAppBarCollapsed ? appBarActions(state.file, App.theme.textTheme.bodyLarge?.color ?? Themes.text) : <Widget>[]),
                    );
                  },
                ),
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
                          "${state.file.isRental() ? 'ودیعه' : 'قیمت کل'} : ${state.file.getPriceStr()}",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "IranSansBold",
                          ),
                        ),
                        Text(
                          "${state.file.isRental() ? 'اجاره ماهانه' : 'قیمت هر متر'} : ${state.file.isRental() ? state.file.getRentStr() : state.file.getPricePerMater()}",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "IranSansBold",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: _buildMainProps(state.file),
                        ),
                        _destWithTitle(title: "آدرس", desc: state.file.address ?? "بدون آدرس"),
                        if (state.file.description.isFill()) _destWithTitle(title: "توضیحات", desc: state.file.description!),
                        if (state.file.secDescription.isFill())
                          Container(
                            clipBehavior: Clip.hardEdge,
                            margin: EdgeInsets.only(bottom: 5, top: 20),
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
                                  onTap: () => setState(() => secDescExpand = !secDescExpand),
                                  child: Container(
                                    height: 50,
                                    padding: EdgeInsets.only(right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "توضیحات محرمانه",
                                          style: TextStyle(
                                            fontFamily: "IranSansBold",
                                            fontSize: 12,
                                          ),
                                        ),
                                        AnimatedRotation(
                                          duration: Duration(milliseconds: 400),
                                          turns: secDescExpand ? 0 : -.5,
                                          child: MyIconButton(
                                            onTap: () => setState(() => secDescExpand = !secDescExpand),
                                            iconData: Icons.keyboard_arrow_up_rounded,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Collapsable(
                                  expand: secDescExpand,
                                  child: Container(
                                    width: double.infinity,
                                    color: App.theme.dialogBackgroundColor,
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      state.file.secDescription!,
                                      style: TextStyle(
                                        fontFamily: "IranSansMedium",
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                                          style: TextStyle(
                                            fontFamily: "IranSansBold",
                                            fontSize: 12,
                                          ),
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
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: SimpleMap(
                              lat: state.file.lat!.toDouble(),
                              long: state.file.long!.toDouble(),
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        if (file.expireDay != null)
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              file.isExpired() ? "${file.expireDay} روز تا انقضا فایل باقیمانده جهت تمدید دکمه زیر را کلیک کنید" : "${file.expireDay} روز تا انقضا فایل",
                              style: TextStyle(
                                fontSize: file.isExpired() ? 10 : 11,
                                fontFamily: "IranSansBold",
                                color: file.isExpired() ? Colors.red : null,
                              ),
                            ),
                          ),
                        ),
                        if (file.isExpired())
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Material(
                              color: App.theme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: InkWell(
                                onTap: () => _tamdid(state.file.expireDay!),
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "تمدید فایل",
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
                        if (state.file.rejectionDesc.isFill() && state.file.progress == 2)
                          Container(
                            clipBehavior: Clip.hardEdge,
                            margin: EdgeInsets.only(bottom: 5),
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
                                  onTap: () => setState(() => rejectDescExpand = !rejectDescExpand),
                                  child: Container(
                                    height: 50,
                                    padding: EdgeInsets.only(right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "علت رد فایل",
                                          style: TextStyle(
                                            fontFamily: "IranSansBold",
                                            fontSize: 12,
                                          ),
                                        ),
                                        AnimatedRotation(
                                          duration: Duration(milliseconds: 400),
                                          turns: rejectDescExpand ? 0 : -.5,
                                          child: MyIconButton(
                                            onTap: () => setState(() => rejectDescExpand = !rejectDescExpand),
                                            iconData: Icons.keyboard_arrow_up_rounded,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Collapsable(
                                  expand: rejectDescExpand,
                                  child: Container(
                                    width: double.infinity,
                                    color: App.theme.dialogBackgroundColor,
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      state.file.rejectionDesc!,
                                      style: TextStyle(
                                        fontFamily: "IranSansMedium",
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (state.consultants.isFill())
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              "لیست مشاوران",
                              style: TextStyle(
                                fontFamily: "IranSansBold",
                                fontSize: 13,
                              ),
                            ),
                          ),
                        if (state.consultants.isFill())
                          SizedBox(
                            height: 60,
                            child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: state.consultants.length,
                              itemBuilder: (context, i) => itemConsultant(state.consultants[i]),
                              separatorBuilder: (_, _2) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: VerticalDivider(width: 25),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  height: 60,
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "مالک : ${state.file.ownerName ?? "??"}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11, fontFamily: "IranSansMedium"),
                            ),
                            Text(
                              state.file.ownerPhoneNumber.isFill() ? phoneFormat(state.file.ownerPhoneNumber!) : "بدون شماره",
                              textDirection: TextDirection.ltr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "IranSansBold",
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "بازدید: ${state.file.visitName ?? "??"}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11, fontFamily: "IranSansMedium"),
                            ),
                            Text(
                              state.file.visitPhoneNumber.isFill() ? phoneFormat(state.file.visitPhoneNumber!) : "بدون شماره",
                              textDirection: TextDirection.ltr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "IranSansBold",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainProps(MyFileDetail file) {
    List<Widget> items = [];

    var a = file
        .getMainProperties()
        .map<List<Widget>>(
          (e) => [
            _buildPropItem(e.value.toString(), e.name!),
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

  Widget _buildSliders(MyFileDetail file) {
    return Container(
      color: App.theme.dialogBackgroundColor,
      child: Stack(
        children: [
          if (!file.media!.image.isFill() && !file.media!.video.isFill() && !file.media!.virtualTour.isFill())
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: App.theme.backgroundColor,
                image: DecorationImage(image: AssetImage(IMAGE_NOT_AVAILABLE), alignment: Alignment.center),
              ),
            ),
          if (file.media!.image.isFill() || file.media!.video.isFill() || file.media!.virtualTour.isFill())
            CarouselSliderCustom(
              sliders: sliders,
              autoPlay: false,
              height: 300,
              indicatorsCenterAlign: true,
              viewportFraction: 1.0,
              itemMargin: EdgeInsets.zero,
              indicatorMargin: EdgeInsets.only(left: 0, right: 0, bottom: 18),
              float: true,
              itemBorderRadius: BorderRadius.zero,
              directPlay: true,
              imageFit: BoxFit.cover,
              indicatorSelectedColor: App.theme.primaryColor,
              indicatorColor: Colors.white,
              onPageChanged: (i) {
                setState(() {
                  if (file.media!.image!.asMap().containsKey(i) && file.media!.image![i].name.isFill()) {
                    imageName = file.media!.image![i].name!.trim();
                  } else {
                    imageName = "";
                  }
                });
              },
              onImageTap: (s.Slider slider) {
                if (slider.type == s.SliderType.image) {
                  push(context, FileImagesScreen(file: FileDetail.fromJson(file.toJson()), index: sliders.indexOf(slider)));
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

  void shareFile(String fileName) async {
    await FlutterShare.share(
      title: 'اشتراک گذاری فایل',
      text: fileName,
      linkUrl: FILE_URL + widget.id.toString(),
      chooserTitle: 'اشتراک گذاری در',
    );
  }

  Widget itemConsultant(FileConsultant consultant) {
    return InkWell(
      onTap: () {
        push(
          context,
          ConsultantProfileScreen(
            consultantId: consultant.consultantId!.id!,
            consultantName: consultant.consultantId?.name,
          ),
        );
      },
      child: Container(
        child: Row(
          children: [
            Avatar(
              size: 45,
              imagePath: consultant.consultantId?.avatar ?? "",
              loadingImage: AssetImage("assets/images/profile.jpg"),
              errorImage: AssetImage("assets/images/profile.jpg"),
            ),
            SizedBox(width: 4),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consultant.consultantId?.name ?? "بدون نام",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "IranSansMedium",
                  ),
                ),
                StaticStar(rating: consultant.consultantId?.rate ?? 0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showDeleteDialog() {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return ConfirmDialog(
          dialogContext: context,
          content: 'آیا مایل به حذف فایل هستید؟',
          title: "حذف فایل",
          titleColor: Colors.red,
          onApply: () async {
            deleteFileBloc.add(
              DeleteFileSingleEvent(
                id: widget.id,
                token: await User.getBearerToken(),
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> appBarActions(MyFileDetail file, Color color, {bool shadow = true}) {
    return [
      MyPopupMenuButton(
        child: Icon(
          Icons.more_vert_rounded,
          color: color,
          shadows: !shadow || _isSliverAppBarCollapsed ? null : [BoxShadow(color: Colors.black87, blurRadius: 3)],
        ),
        itemBuilder: (_) => [
          MyPopupMenuItem(
            value: 0,
            label: "ویرایش",
            icon: Icons.edit_outlined,
          ),
          if (widget.progress == 7)
            MyPopupMenuItem(
              value: 1,
              label: "آمار بازدید",
              icon: Icons.visibility_outlined,
            ),
          MyPopupMenuItem(
            value: 2,
            label: "حذف",
            icon: CupertinoIcons.delete,
          ),
        ],
        onSelected: (v) {
          if (v == 0) push(context, EditFileFirst(file: file));
          if (v == 1) push(context, FileViewChartScreen(id: widget.id, fileTitle: file.name ?? ""));
          if (v == 2) showDeleteDialog();
        },
      ),
    ];
  }

  Widget _destWithTitle({required String title, required String desc}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${title} :",
            style: TextStyle(
              fontSize: 13,
              fontFamily: "IranSansBold",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: Text(
              desc,
              style: TextStyle(
                fontSize: 12,
                fontFamily: "IranSansMedium",
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  _tamdid(int expDay) {
    animationDialog(
        context: context,
        builder: (dialogContext) {
          return ConfirmDialog(
            dialogContext: dialogContext,
            title: "تمدید فایل",
            content: "فایل شما ${expDay} روز دیگر منقضی می شود آیا میخواهید آن را تمدید کنید؟",
            applyText: "بله",
            cancelText: "خیر",
            onApply: () {
              expBloc.add(ExtensionFileEvent(id: widget.id));
            },
          );
        });
  }
}
