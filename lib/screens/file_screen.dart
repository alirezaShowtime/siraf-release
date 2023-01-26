import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:latlong2/latlong.dart';
import 'package:siraf3/bloc/add_violation_bloc.dart';
import 'package:siraf3/bloc/file_bloc.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/file_detail.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/auth/login_screen.dart';
import 'package:siraf3/screens/support_file_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/custom_slider.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';

class FileScreen extends StatefulWidget {
  int id;

  FileScreen({required this.id, super.key});

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  FileBloc fileBloc = FileBloc();

  AddViolationBloc addViolationBloc = AddViolationBloc();

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    fileBloc.add(FileFetchEvent(id: widget.id));
    fileBloc.stream.listen((event) {
      if (event is FileLoadedState) {
        setState(() {
          isFavorite = event.favorite ?? false;

          description = event.file.description ?? "";
          summary = event.file.description ?? "";

          if (summary.length > 128) {
            summary = summary.substring(0, 128) + "...";
          }
        });

        if (event.file.media!.image![0].name == null ||
            event.file.media!.image![0].name == "") {
          imageName.add(null);
        } else {
          imageName.add(" | ${event.file.media!.image![0].name!.trim()}");
        }
      }
    });

    addViolationBloc.stream.listen((event) {
      if (event is AddViolationInitState || event is AddViolationLoadingState) {
        showLoadingDialog();
      } else if (event is AddViolationErrorState) {
        dissmisLoadingDialog();
        notify("خطا در ثبت اطلاعات رخ داد");
      } else if (event is AddViolationSuccessState) {
        dissmisLoadingDialog();
        dismissViolationDialog();
        notify("تخلف با موفقیت ثبت شد");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => fileBloc,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<FileBloc, FileState>(builder: buildBaseBloc),
        ),
      ),
    );
  }

  Widget buildBaseBloc(_co, FileState state) {
    if (state is FileInitState || state is FileLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is FileErrorState) {
      return Center(
        child: TryAgain(
          onPressed: () {
            fileBloc.add(FileFetchEvent(id: widget.id));
          },
          message: jDecode(state.response?.body ?? "")['message'],
        ),
      );
    }

    state = state as FileLoadedState;

    //ops
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
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
              Divider(
                height: 0.7,
                color: Themes.textGrey,
              ),
              SizedBox(height: 15),
              _buildProps(state.file),
              SizedBox(height: 15),
              Divider(
                height: 0.7,
                color: Themes.textGrey,
              ),
              if (state.file.lat != null || state.file.long != null)
                _buildMap(state.file),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  doWithLogin(context, () {
                    showViolationDialog();
                  });
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      "ثبت تخلف و مشکل فایل",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: "IranSans",
                        color: Color(0xff8c8c8c),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 65),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildPriceSection(state.file),
        ),
      ],
    );
  }

  StreamController<String?> imageName = StreamController();

  Widget _buildSliders(FileDetail file) {
    return Stack(
      children: [
        CarouselSliderCustom(
          images:
              file.media?.image?.map<String>((e) => e.path ?? "").toList() ??
                  [],
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
              if (file.media!.image![i].name == null ||
                  file.media!.image![i].name == "") {
                imageName.add(null);
              } else {
                imageName.add(" | ${file.media!.image![i].name!.trim()}");
              }
            });
          },
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  CupertinoIcons.back,
                  color: Themes.iconLight,
                ),
              ),
              IconButton(
                onPressed: () async {
                  doWithLogin(context, () async {
                    if (await addOrRemoveFavorite(widget.id)) {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    }
                  });
                },
                icon: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 25,
          right: 10,
          child: StreamBuilder(
            builder: (context, snapshot) {
              return Container(
                color: Colors.white60,
                padding: EdgeInsets.all(5),
                child: Text(
                  widget.id.toString() +
                      (snapshot.data != null ? snapshot.data.toString() : ""),
                  style: TextStyle(
                    fontFamily: "IranSans",
                    color: Color(0xff606060),
                    fontSize: 13,
                  ),
                ),
              );
            },
            stream: imageName.stream,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(FileDetail file) {
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
                child: Flexible(
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
                        color: Themes.text,
                        fontFamily: "IranSans",
                        fontSize: 14,
                        height: 1.3),
                    maxLines: 3,
                  ),
                ),
              ),
              Text(
                file.publishedAgo! + ' | ' + file.city!,
                style: TextStyle(
                  color: Themes.textGrey,
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
              linkUrl: "https://siraf.biz/312" /* + file.id!.toString()*/,
              chooserTitle: 'اشتراک گذاری در',
            );
          },
          icon: m.Image(
            image: AssetImage("assets/images/ic_share.png"),
            width: 16,
            height: 16,
            color: Themes.icon,
          ),
        ),
      ],
    );
  }

  Widget _buildMainProps(FileDetail file) {
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

  Widget _buildDescription(FileDetail file) {
    if (file.description == null) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        description,
        style: TextStyle(
          color: Themes.text,
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

  Widget _buildMap(FileDetail file) {
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
            TileLayer(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=${MAPBOX_ACCESS_TOKEN}",
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point:
                      LatLng(double.parse(file.lat!), double.parse(file.long!)),
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
            )
          ],
        ),
      ),
    );
  }

  bool isPropOpen = true;

  Widget _buildProps(FileDetail file) {
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

  Widget _buildPriceSection(FileDetail file) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            offset: const Offset(0, -1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(9),
              child: !file.isRental()
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "قیمت",
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 12),
                          ),
                        ),
                        Text(
                          file.prices != null
                              ? number_format(file.prices)
                              : "توافقی",
                          style: TextStyle(
                              color: Themes.text,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ودیعه",
                              style: TextStyle(
                                  color: greyColor, fontSize: 10, height: 1),
                            ),
                            Text(
                              file.prices != null
                                  ? number_format(file.prices)
                                  : "توافقی",
                              style: TextStyle(
                                  color: Themes.text,
                                  fontSize: 12,
                                  height: 1,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "اجاره ماهانه",
                              style: TextStyle(color: greyColor, fontSize: 13),
                            ),
                            Text(
                              number_format(file.rent),
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                var result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SupportFileScreen(
                      file: file,
                      isFavorite: isFavorite,
                      id: widget.id,
                    ),
                  ),
                );

                if (result is bool) {
                  setState(() {
                    isFavorite = result;
                  });
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Themes.primary,
                ),
                child: Text(
                  "تماس | پیام",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> addOrRemoveFavorite(int id) async {
    if (isFavorite) {
      return await removeFavorite(id);
    } else {
      return await addFavorite(id);
    }
  }

  Future<bool> addFavorite(int id) async {
    showLoadingDialog();

    var result = false;

    try {
      var response = await get(
          getFileUrl('file/addFileFavorite/' + id.toString() + '/'),
          headers: {
            "Authorization": await User.getBearerToken(),
          });

      if (isResponseOk(response)) {
        result = true;
      } else {
        var json = jDecode(response.body);
        notify(json['message'] ??
            "خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
        result = false;
      }
    } on HttpException {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    } catch (e) {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    }

    dissmisLoadingDialog();

    return result;
  }

  Future<bool> removeFavorite(int id) async {
    showLoadingDialog();

    var result = false;

    try {
      var response = await get(
          getFileUrl('file/deleteFileFavorite/' + id.toString() + '/'),
          headers: {
            "Authorization": await User.getBearerToken(),
          });

      if (isResponseOk(response)) {
        result = true;
      } else {
        var json = jDecode(response.body);
        notify(json['message'] ??
            "خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
        result = false;
      }
    } on HttpException {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    } catch (e) {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    }

    dissmisLoadingDialog();

    return result;
  }

  showLoadingDialog() {
    showDialog(
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
                    'در حال ارسال درخواست صبور باشید',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
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

  BuildContext? violationDialogContext;

  showViolationDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        violationDialogContext = _;
        TextEditingController _controller = TextEditingController();
        TextEditingController _controller2 = TextEditingController();
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Themes.background,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Wrap(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: TextField2(
                        maxLines: 1,
                        controller: _controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Themes.textGrey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Themes.text, width: 1),
                          ),
                          hintText: "عنوان",
                          hintStyle: TextStyle(
                            color: Themes.textGrey,
                            fontSize: 13,
                            fontFamily: "IranSans",
                          ),
                        ),
                        style: TextStyle(
                          color: Themes.text,
                          fontSize: 13,
                          fontFamily: "IranSansMedium",
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: TextField2(
                        minLines: 6,
                        maxLines: 10,
                        controller: _controller2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Themes.textGrey, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Themes.text, width: 1),
                          ),
                          hintText: "توضیحات",
                          hintStyle: TextStyle(
                            color: Themes.textGrey,
                            fontSize: 13,
                            fontFamily: "IranSans",
                          ),
                        ),
                        style: TextStyle(
                          color: Themes.text,
                          fontSize: 13,
                          fontFamily: "IranSansMedium",
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () async {
                                if (_controller.text.trim().isEmpty) {
                                  return notify("لطفا عنوان را وارد کنید");
                                }
                                if (_controller2.text.trim().isEmpty) {
                                  return notify("لطفا توضیحات را وارد کنید");
                                }

                                addViolationBloc.add(
                                  AddViolationEvent(
                                    title: _controller.text,
                                    body: _controller2.text,
                                    fileId: widget.id,
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "تایید",
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

  dismissViolationDialog() {
    if (violationDialogContext != null) {
      Navigator.pop(violationDialogContext!);
    }
  }
}
