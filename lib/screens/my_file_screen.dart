import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:latlong2/latlong.dart';
import 'package:siraf3/bloc/delete_file_bloc.dart';
import 'package:siraf3/bloc/my_file_bloc.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/file_consulant.dart';
import 'package:siraf3/models/my_file_detail.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/edit/edit_file_first.dart';
import 'package:siraf3/screens/file_view_chart_screen.dart';
import 'package:siraf3/screens/webview_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/custom_slider.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/slider.dart' as s;
import 'package:siraf3/widgets/try_again.dart';
import 'package:url_launcher/url_launcher.dart';

class MyFileScreen extends StatefulWidget {
  int id;
  int progress;

  MyFileScreen({required this.id, required this.progress, super.key});

  @override
  State<MyFileScreen> createState() => _MyFileScreenState();
}

class _MyFileScreenState extends State<MyFileScreen> {
  MyFileBloc fileBloc = MyFileBloc();
  DeleteFileBloc deleteFileBloc = DeleteFileBloc();

  Map<int, String> progress_fa = {
    1: "منتظر تایید",
    2: "در حال پیگیری",
    3: "رد شده",
    4: "تایید شده",
    5: "در انتظار پذیرش املاک",
    6: "توسط دفاتر پذیرش نشده",
    7: "پذیرش شده",
  };

  @override
  void initState() {
    super.initState();

    fileBloc.add(MyFileFetchEvent(id: widget.id, progress: widget.progress));
    fileBloc.stream.listen((event) {
      if (event is MyFileLoadedState) {
        setSliders(event.file);
        setState(() {
          description = event.file.description ?? "";
          summary = event.file.description ?? "";

          if (summary.length > 128) {
            summary = summary.substring(0, 128) + "...";
          }
        });

        if (event.file.media!.image!.asMap().containsKey(0) &&
            event.file.media!.image![0].name.isNotNullOrEmpty()) {
          imageName = " | ${event.file.media!.image![0].name!.trim()}";
        } else {
          imageName = "";
        }
      }
    });

    deleteFileBloc.stream.listen((event) {
      if (event is DeleteFileLoadingState) {
        showLoadingDialog(message: "در حال حذف فایل هستیم لطفا شکیبا باشید");
      } else if (event is DeleteFileErrorState) {
        dissmisLoadingDialog();
        notify("خطا در حذف فایل رخ داد لطفا مجدد تلاش کنید");
      } else if (event is DeleteFileSuccessState) {
        dissmisLoadingDialog();
        dismissDeleteDialog();

        notify("حذف فایل با موفقیت انجام شد");

        Navigator.pop(context, "refresh");
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels > imgHeight && toolbarOpacity == 1)
        return;

      if (_scrollController.position.pixels <= imgHeight && toolbarOpacity == 0)
        return;

      setState(() {
        toolbarOpacity = _scrollController.position.pixels <= imgHeight ? 0 : 1;
      });
    });
  }

  ScrollController _scrollController = ScrollController();

  var imgHeight = 200;

  double toolbarOpacity = 0.0;

  setSliders(MyFileDetail file) async {
    var data = await file.getSliders();
    setState(() {
      sliders = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => fileBloc,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<MyFileBloc, MyFileState>(builder: buildBaseBloc),
        ),
      ),
    );
  }

  Widget buildBaseBloc(_co, MyFileState state) {
    if (state is MyFileInitState || state is MyFileLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is MyFileErrorState) {
      return Center(
        child: TryAgain(
          onPressed: () {
            fileBloc.add(
              MyFileFetchEvent(
                id: widget.id,
                progress: widget.progress,
              ),
            );
          },
          message: jDecode(state.response?.body ?? "")['message'],
        ),
      );
    }

    state = state as MyFileLoadedState;

    //ops
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  _buildSliders(state.file),
                  SizedBox(height: 10),
                  _buildTitle(state.file),
                  SizedBox(height: 15),
                  if (state.file.getMainProperties().isNotEmpty)
                    _buildMainProps(state.file),
                  if (state.file.getMainProperties().isNotEmpty)
                    SizedBox(height: 15),
                  _buildDescription(state.file),
                  SizedBox(height: 15),
                  if (state.file.getOtherProperties().isNotEmpty)
                    Divider(
                      height: 0.5,
                      color: Themes.textGrey.withOpacity(0.5),
                    ),
                  if (state.file.getOtherProperties().isNotEmpty)
                    SizedBox(height: 15),
                  if (state.file.getOtherProperties().isNotEmpty)
                    _buildProps(state.file),
                  SizedBox(height: 15),
                  Divider(
                    height: 0.5,
                    color: Themes.textGrey.withOpacity(0.5),
                  ),
                  if (state.file.lat != null || state.file.long != null)
                    _buildMap(state.file),
                  SizedBox(height: 10),
                  Divider(
                    height: 0.5,
                    color: Themes.textGrey.withOpacity(0.5),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(9),
                    child: !state.file.isRental()
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "قیمت",
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    state.file.getPrice()?.value != null
                                        ? number_format(
                                            state.file.getPrice()!.value)
                                        : "توافقی",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "قیمت هر متر",
                                    style: TextStyle(
                                      color: greyColor,
                                      fontSize: 10.5,
                                    ),
                                  ),
                                  Text(
                                    state.file.getPricePermater(),
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 11.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "ودیعه",
                                    style: TextStyle(
                                      color: greyColor,
                                      fontSize: 12,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    state.file.getPrice()?.value != null
                                        ? number_format(
                                            state.file.getPrice()?.value)
                                        : "توافقی",
                                    style: TextStyle(
                                        color: Themes.text,
                                        fontSize: 13,
                                        height: 1,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "اجاره ماهانه",
                                    style: TextStyle(
                                        color: greyColor, fontSize: 10.5),
                                  ),
                                  Text(
                                    state.file.getRent()?.value != null
                                        ? number_format(
                                            state.file.getRent()?.value)
                                        : "توافقی",
                                    style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 11.5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 0.5,
                    color: Themes.textGrey.withOpacity(0.5),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        "وضعیت : " + (progress_fa[widget.progress] ?? "نامشخص"),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "IranSans",
                          color: App.theme.tooltipTheme.textStyle?.color,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 400),
                ] +
                state.consulants
                    .map<Widget>((element) => _item(element))
                    .toList() +
                <Widget>[
                  SizedBox(height: 10),
                ],
          ),
        ),
        _buildTopBar(state.file),
      ],
    );
  }

  String imageName = "";

  List<s.Slider> sliders = [];

  Widget _buildSliders(MyFileDetail file) {
    return Stack(
      children: [
        CarouselSliderCustom(
          sliders: sliders,
          autoPlay: false,
          height: 250,
          indicatorsCenterAlign: true,
          viewportFraction: 1.0,
          itemMargin: EdgeInsets.only(bottom: 15),
          indicatorPosition: EdgeInsets.only(left: 0, right: 0, bottom: 0),
          itemBorderRadius: BorderRadius.zero,
          imageFit: BoxFit.cover,
          indicatorSelectedColor: Themes.blue,
          indicatorColor: Colors.grey,
          onPageChanged: (i) {
            setState(() {
              if (file.media!.image!.asMap().containsKey(i) &&
                  file.media!.image![i].name.isNotNullOrEmpty()) {
                imageName = " | ${file.media!.image![i].name!.trim()}";
              } else {
                imageName = "";
              }
            });
          },
          onImageTap: (s.Slider slider) {
            if (slider.type == s.SliderType.virtual_tour) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WebViewScreen(
                    title: file.name ?? "",
                    url: slider.link!,
                  ),
                ),
              );
            }
          },
        ),
        // Positioned(
        //   top: 0,
        //   left: 0,
        //   right: 0,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       IconButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //         icon: Stack(
        //           children: <Widget>[
        //             Positioned(
        //               left: 1.0,
        //               top: 2.0,
        //               child: Icon(CupertinoIcons.back, color: Colors.black26),
        //             ),
        //             Positioned(
        //               right: 1.0,
        //               top: 2.0,
        //               child: Icon(CupertinoIcons.back, color: Colors.black26),
        //             ),
        //             Icon(
        //               CupertinoIcons.back,
        //               color: Themes.iconLight,
        //             ),
        //           ],
        //         ),
        //       ),
        //       Row(
        //         children: [
        //           IconButton(
        //             onPressed: () async {
        //               showDeleteDialog();
        //             },
        //             icon: Stack(
        //               children: <Widget>[
        //                 Positioned(
        //                   left: 0.5,
        //                   top: 0.5,
        //                   child: Icon(CupertinoIcons.delete, color: Colors.black26),
        //                 ),
        //                 Positioned(
        //                   right: 0.5,
        //                   top: 0.5,
        //                   child: Icon(CupertinoIcons.delete, color: Colors.black26),
        //                 ),
        //                 Icon(
        //                   CupertinoIcons.delete_solid,
        //                   color: Themes.iconLight,
        //                 ),
        //               ],
        //             ),
        //           ),
        //           MyPopupMenuButton(
        //             itemBuilder: (context) {
        //               return [
        //                 PopupMenuItem<int>(
        //                   value: 0,
        //                   child: Text(
        //                     "ویرایش",
        //                     style: TextStyle(
        //                       fontSize: 13,
        //                       color: App.theme.textTheme.bodyLarge?.color,
        //                     ),
        //                   ),
        //                   height: 35,
        //                 ),
        //                 PopupMenuItem<int>(
        //                   value: 1,
        //                   child: Text(
        //                     "آمار بازدید",
        //                     style: TextStyle(
        //                       fontSize: 13,
        //                       color: App.theme.textTheme.bodyLarge?.color,
        //                     ),
        //                   ),
        //                   height: 35,
        //                 ),
        //               ];
        //             },
        //             onSelected: (value) {
        //               switch (value) {
        //                 case 0:
        //                   Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                       builder: (_) => EditFileFirst(file: file),
        //                     ),
        //                   );
        //
        //                   break;
        //                 case 1:
        //                   Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                       builder: (_) => FileViewChartScreen(id: widget.id, fileTitle: file.name ?? "",),
        //                     ),
        //                   );
        //
        //                   break;
        //               }
        //             },
        //             icon: Stack(
        //               children: <Widget>[
        //                 Positioned(
        //                   left: 1.0,
        //                   top: 1.0,
        //                   child: Icon(Icons.more_vert, color: Colors.black26),
        //                 ),
        //                 Positioned(
        //                   right: 1.0,
        //                   top: 1.0,
        //                   child: Icon(Icons.more_vert, color: Colors.black26),
        //                 ),
        //                 Icon(
        //                   Icons.more_vert,
        //                   color: Themes.iconLight,
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        Positioned(
          bottom: 25,
          right: 10,
          child: Container(
            color: Colors.white60,
            padding: EdgeInsets.all(5),
            child: Text(
              "${widget.id}$imageName",
              style: TextStyle(
                fontFamily: "IranSans",
                color: Color(0xff606060),
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(MyFileDetail file) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 40 - 25,
                ),
                child: Text(
                  (file.fullCategory != null
                          ? file.fullCategory!
                                  .getMainCategoryName()
                                  .toString()
                                  .trim() +
                              " | "
                          : "") +
                      file.name!.trim(),
                  style: TextStyle(
                      fontFamily: "IranSans", fontSize: 14, height: 1.3),
                  maxLines: 3,
                ),
              ),
              Text(
                file.publishedAgo! + ' | ' + (file.city?.name ?? ""),
                style: TextStyle(
                  color: App.theme.tooltipTheme.textStyle?.color,
                  fontFamily: "IranSans",
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () async {
            await FlutterShare.share(
              title: 'اشتراک گذاری فایل',
              text: file.name ?? '',
              linkUrl: FILE_URL + widget.id.toString(),
              chooserTitle: 'اشتراک گذاری در',
            );
          },
          icon: m.Image(
            image: AssetImage("assets/images/ic_share.png"),
            width: 16,
            height: 16,
            color: App.theme.iconTheme.color,
          ),
        ),
      ],
    );
  }

  Widget _buildMainProps(MyFileDetail file) {
    List<Widget> items = [];

    var a = file
        .getMainProperties()
        .map<List<Widget>>(
          (e) => [
            _buildPropItem(e.value.toString(), e.name!),
            if (file.getMainProperties().last != e)
              VerticalDivider(
                width: 0.7,
                color: Themes.textGrey,
              ),
          ],
        )
        .toList();
    for (List<Widget> item in a) {
      items += item;
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildPropItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Themes.text,
            fontFamily: "IranSans",
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          label.split(r" ").take(2).join(" "),
          style: TextStyle(
            color: Themes.textGrey,
            fontFamily: "IranSans",
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  late String description = "";

  late String summary = "";

  bool showSummary = true;

  Widget _buildDescription(MyFileDetail file) {
    if (file.description == null) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        description,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w400,
          fontFamily: 'IranSans',
          height: 1.5,
        ),
      ),
      // RichText(
      //   text: TextSpan(
      //     children: [
      //       TextSpan(
      //         text: showSummary ? summary : description,
      //         style: TextStyle(
      //           color: Themes.text,
      //           fontSize: 11,
      //           fontWeight: FontWeight.w400,
      //           fontFamily: 'IranSans',
      //         ),
      //       ),
      //       TextSpan(
      //           text: showSummary ? ' توضیحات بیشتر' : ' توضیحات کمتر',
      //           style: TextStyle(
      //             color: Themes.blue,
      //             fontSize: 10.5,
      //             fontWeight: FontWeight.w400,
      //             fontFamily: 'IranSans',
      //           ),
      //           recognizer: TapGestureRecognizer()
      //             ..onTap = () {
      //               setState(() {
      //                 showSummary = !showSummary;
      //               });
      //             }),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildMap(MyFileDetail file) {
    return GestureDetector(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(double.parse(file.lat!), double.parse(file.long!)),
            zoom: 13.0,
            onTap: (_, _1) {
              // MapsLauncher.launchCoordinates(file.lat!, file.long!);
              launchUrl(Uri.parse('geo:0,0?q=${file.lat!},${file.long!}'));
            },
          ),
          children: [
            TileLayerWidget(
              options: TileLayerOptions(
                urlTemplate: App.isDark ? MAPBOX_TILE_DARK : MAPBOX_TILE_LIGHT,
              ),
            ),
            MarkerLayerWidget(
              options: MarkerLayerOptions(
                markers: [
                  Marker(
                    point: LatLng(
                        double.parse(file.lat!), double.parse(file.long!)),
                    builder: (_) {
                      return m.Image(
                        image: AssetImage('assets/images/map_marker.png'),
                        width: 30,
                        height: 40,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isPropOpen = true;

  Widget _buildProps(MyFileDetail file) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "سایر امکانات و ویژگی ها",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "IranSans",
                  color: Color(0xff8c8c8c),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isPropOpen = !isPropOpen;
                  });
                },
                child: Icon(
                  isPropOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 18,
                  color: Color(0xff8c8c8c),
                ),
              ),
            ],
          ),
          if (isPropOpen)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: file
                    .getOtherProperties()
                    .map<Widget>(
                      (e) => Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                (file.getOtherProperties().last != e ? 5 : 0)),
                        child: Text(
                          e.name.toString() + " : " + e.value.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "IranSans",
                            color: Color(0xff8c8c8c),
                            height: 1.3,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  showLoadingDialog({String? message}) {
    showDialog2(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        loadingDContext = _;
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    message ?? 'در حال ارسال درخواست صبور باشید',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Loading(),
              ],
            ),
          ),
        );
      },
    );
  }

  dissmisLoadingDialog() {
    if (loadingDContext != null) {
      Navigator.pop(loadingDContext!);
    }
  }

  BuildContext? loadingDContext;

  Widget _item(FileConsulant item) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(color: Themes.textGrey.withOpacity(0.2), width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: m.Image.network(
                  item.consultantId?.avatar ?? '',
                  height: 50,
                  width: 50,
                  errorBuilder: (_, _1, _2) => m.Image.asset(
                    "assets/images/profile.png",
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.consultantId?.name ?? "؟؟؟",
                      style: TextStyle(
                        color: Themes.text,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "(${item.estateName.toString()})",
                      style: TextStyle(
                        color: Themes.textGrey,
                        fontSize: 10,
                      ),
                    ),
                    RatingBarIndicator(
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 14,
                      unratedColor: Colors.grey,
                      itemPadding: EdgeInsets.symmetric(horizontal: .2),
                      itemBuilder: (context, _) {
                        return Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 10,
                        );
                      },
                      rating: item.consultantId?.rate ?? 5.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  doWithLogin(context, () {
                    createChat();
                  });
                },
                child: Icon(
                  CupertinoIcons.chat_bubble_2,
                  size: 35,
                  color: Themes.primary,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  callTo(item.consultantId!.phone!);
                },
                child: Icon(
                  CupertinoIcons.phone_circle,
                  size: 35,
                  color: Themes.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  createChat() async {
    showLoadingDialog(message: "درحال ایجاد گفتگو هستیم شکیبا باشید");

    //todo: implement

    await Future.delayed(Duration(seconds: 2));

    dissmisLoadingDialog();
  }

  BuildContext? deleteDialogContext;

  showDeleteDialog() {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        deleteDialogContext = _;
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: App.theme.dialogBackgroundColor,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Wrap(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Text(
                        'آیا مایل به حذف فایل هستید؟',
                        style: TextStyle(
                          color: App.theme.tooltipTheme.textStyle?.color,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: dismissDeleteDialog,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "خیر",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: "IranSansBold",
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 9),
                            ),
                          ),
                          SizedBox(
                            width: 0.5,
                          ),
                          Expanded(
                            child: MaterialButton(
                              onPressed: () async {
                                deleteFileBloc.add(
                                  DeleteFileSingleEvent(
                                    id: widget.id,
                                    token: await User.getBearerToken(),
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "بله",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: "IranSansBold",
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  dismissDeleteDialog() {
    if (deleteDialogContext != null) {
      Navigator.pop(deleteDialogContext!);
    }
  }

  Widget _buildTopBar(MyFileDetail file) {
    var iconColor = Themes.iconLight;

    var toolbarOpacity =
        (file.media?.image?.isNotEmpty ?? false) ? this.toolbarOpacity : 1.0;

    if (toolbarOpacity > 0) {
      iconColor = App.theme.appBarTheme.foregroundColor ?? Themes.iconLight;
    }

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color:
            App.theme.appBarTheme.backgroundColor?.withOpacity(toolbarOpacity),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Stack(
                children: <Widget>[
                  if (toolbarOpacity == 0)
                    Positioned(
                      left: 1.0,
                      top: 2.0,
                      child: Icon(CupertinoIcons.back, color: Colors.black26),
                    ),
                  if (toolbarOpacity == 0)
                    Positioned(
                      right: 1.0,
                      top: 2.0,
                      child: Icon(CupertinoIcons.back, color: Colors.black26),
                    ),
                  Icon(
                    CupertinoIcons.back,
                    color: iconColor,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    showDeleteDialog();
                  },
                  icon: Stack(
                    children: <Widget>[
                      if (toolbarOpacity == 0)
                        Positioned(
                          left: 0.5,
                          top: 0.5,
                          child: Icon(CupertinoIcons.delete,
                              color: Colors.black26),
                        ),
                      if (toolbarOpacity == 0)
                        Positioned(
                          right: 0.5,
                          top: 0.5,
                          child: Icon(CupertinoIcons.delete,
                              color: Colors.black26),
                        ),
                      Icon(
                        CupertinoIcons.delete_solid,
                        color: iconColor,
                      ),
                    ],
                  ),
                ),
                MyPopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text(
                          "ویرایش",
                          style: TextStyle(
                            fontSize: 13,
                            color: App.theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        height: 35,
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text(
                          "آمار بازدید",
                          style: TextStyle(
                            fontSize: 13,
                            color: App.theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        height: 35,
                      ),
                    ];
                  },
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditFileFirst(file: file),
                          ),
                        );

                        break;
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FileViewChartScreen(
                              id: widget.id,
                              fileTitle: file.name ?? "",
                            ),
                          ),
                        );

                        break;
                    }
                  },
                  icon: Stack(
                    children: <Widget>[
                      if (toolbarOpacity == 0)
                        Positioned(
                          left: 1.0,
                          top: 1.0,
                          child: Icon(Icons.more_vert, color: Colors.black26),
                        ),
                      if (toolbarOpacity == 0)
                        Positioned(
                          right: 1.0,
                          top: 1.0,
                          child: Icon(Icons.more_vert, color: Colors.black26),
                        ),
                      Icon(
                        Icons.more_vert,
                        color: iconColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
