import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/delete_request_bloc.dart';
import 'package:siraf3/bloc/requests_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/request.dart';
import 'package:siraf3/screens/request_file/request_file_screen.dart';
import 'package:siraf3/screens/request_file/request_file_show_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/try_again.dart';

class RequestListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RequestListScreen();
}

class _RequestListScreen extends State<RequestListScreen> {
  List<Request> selectedRequests = [];

  RequestsBloc requestsBloc = RequestsBloc();
  DeleteRequestBloc deleteRequestBloc = DeleteRequestBloc();

  @override
  void dispose() {
    super.dispose();

    requestsBloc.close();
    deleteRequestBloc.close();
  }

  @override
  void initState() {
    super.initState();

    getRequests();
    deleteRequestBloc.stream.listen(_listenDelete);
  }

  String? currentSortType;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RequestsBloc>(create: (_) => requestsBloc),
        BlocProvider<DeleteRequestBloc>(create: (_) => deleteRequestBloc),
      ],
      child: WillPopScope(
        onWillPop: () async {
          if (isSelectable) {
            setState(() {
              isSelectable = false;
              selectedRequests.clear();
            });
            return false;
          }

          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: MyBackButton(
              onPressed: () {
                if (isSelectable) {
                  setState(() {
                    isSelectable = false;
                    selectedRequests.clear();
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            automaticallyImplyLeading: false,
            title: AppBarTitle(
              "درخواست های من",
              fontSize: 15,
            ),
            actions: [
              Transform.translate(
                offset: Offset(-10, 0),
                child: IconButton(
                  onPressed: requestFile,
                  icon: icon(Icons.add),
                ),
              ),
              if (selectedRequests.length > 0)
                Transform.translate(
                  offset: Offset(-10, 0),
                  child: IconButton(
                    onPressed: removeFile,
                    icon: icon(CupertinoIcons.delete),
                  ),
                ),
              Transform.translate(
                offset: Offset(-10, 0),
                child: MyPopupMenuButton(
                  iconData: Icons.sort_rounded,
                  itemBuilder: (_) => [
                    PopupMenuItem<String?>(
                      value: "newest",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "جدیدترین",
                            style: TextStyle(
                              fontSize: 13,
                              color: App.theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          if (currentSortType == "newest")
                            Icon(
                              Icons.check,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String?>(
                      value: "older",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "قدیمی ترین",
                            style: TextStyle(
                              fontSize: 13,
                              color: App.theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          if (currentSortType == "older")
                            Icon(
                              Icons.check,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String?>(
                      value: "waitePending",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "در انتظار تایید",
                            style: TextStyle(
                              fontSize: 13,
                              color: App.theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          if (currentSortType == "waitePending")
                            Icon(
                              Icons.check,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String?>(
                      value: "waiteAccept",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "در انتظار پذیرش",
                            style: TextStyle(
                              fontSize: 13,
                              color: App.theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          if (currentSortType == "waiteAccept")
                            Icon(
                              Icons.check,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String?>(
                      value: "accepted",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "پذیرش شده",
                            style: TextStyle(
                              fontSize: 13,
                              color: App.theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          if (currentSortType == "accepted")
                            Icon(
                              Icons.check,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String?>(
                      value: "notAccept",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "عدم پذیرش",
                            style: TextStyle(
                              fontSize: 13,
                              color: App.theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          if (currentSortType == "notAccept")
                            Icon(
                              Icons.check,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String?>(
                      value: "fail",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "رد شده",
                            style: TextStyle(
                              fontSize: 13,
                              color: App.theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          if (currentSortType == "fail")
                            Icon(
                              Icons.check,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    setState(() {
                      currentSortType = value;
                    });
                    getRequests();
                  },
                ),
              ),
              MyPopupMenuButton(
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      "انتخاب همه",
                      style: TextStyle(
                          fontSize: 12,
                          color: App.theme.textTheme.bodyLarge?.color),
                    ),
                  ),
                ],
                onSelected: (value) {
                  setState(() {
                    isSelectable = true;
                    selectedRequests.clear();
                    selectedRequests.addAll(requests);
                  });
                },
              ),
            ],
          ),
          body: BlocBuilder<RequestsBloc, RequestsState>(builder: _buildBloc),
        ),
      ),
    );
  }

  Map<int, Color?> statusBadgeColors = {
    0: Color(0xfffdb713), // عدم پذیرش
    1: Color(0xff00cc11), // پذیرش شده
    2: Color(0xfffd1313), // رد شده
    3: Colors.grey, // در انتظار پذیرش
    4: Colors.grey, // در انتظار تایید
  };

  Map<int, Color?> statusTextColors = {
    0: Colors.black, // عدم پذیرش
    1: Colors.black, // پذیرش شده
    2: Colors.white, // رد شده
    3: Colors.black, // در انتظار پذیرش
    4: Colors.black, // در انتظار تایید
  };

  bool isSelectable = false;

  Widget item(Request request) {
    return GestureDetector(
      onTap: () =>
          isSelectable ? changeSelection(request) : onClickItem(request),
      onLongPress: () => changeSelection(request),
      child: Container(
        foregroundDecoration: BoxDecoration(
          color: selectedRequests.any((element) => element.id == request.id)
              ? Themes.blue.withOpacity(0.2)
              : Colors.transparent,
        ),
        decoration: BoxDecoration(
          color: App.theme.dialogBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: App.theme.backgroundColor,
              blurRadius: 1,
              spreadRadius: 1,
              offset: Offset(0, -1),
            )
          ],
        ),
        // margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.categoryId!.getMainCategoryName()! +
                  " | ${request.title}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              request.createDate ?? "",
              style: TextStyle(
                color: App.theme.tooltipTheme.textStyle?.color,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "کد پیگیری : ${request.id}",
                  style: TextStyle(
                    color: App.theme.primaryColor,
                    fontSize: 12,
                    fontFamily: "IranSansBold",
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: statusBadgeColors[request.status!]!, width: 1),
                    borderRadius: BorderRadius.circular(10),
                    color: statusBadgeColors[request.status!]!.withOpacity(0.3),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Text(
                    request.statusString!,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "IranSansBold",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void requestFile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => RequestFileScreen()));
  }

  void removeFile() {
    var ids = selectedRequests.map((e) => e.id!).toList();

    showDeleteDialog(ids);
  }

  void onClickItem(Request request) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RequestFileShowScreen(
          request: request,
        ),
      ),
    );

    if (result == "removed") {
      setState(() {
        requests.removeWhere((element) => element.id == request.id);
      });
    }
  }

  void getRequests() {
    requestsBloc.add(RequestsEvent(sort: currentSortType));
  }

  List<Request> requests = [];

  Widget _buildBloc(BuildContext context, RequestsState state) {
    if (state is RequestsInitState || state is RequestsLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is RequestsErrorState) {
      return Center(
        child: TryAgain(
          onPressed: () {
            getRequests();
          },
        ),
      );
    }

    state as RequestsLoadedState;

    requests = state.requests;

    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "درخواستی پیدا نشد جهت ثبت درخواست دکمه زیر را کلیک کنید",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RawMaterialButton(
              onPressed: requestFile,
              child: Text(
                "ایجاد درخواست",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              elevation: 0.2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              fillColor: Themes.primary,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, i) {
        return item(requests[i]);
      },
    );
  }

  void changeSelection(Request request) {
    setState(() {
      if (selectedRequests.any((element) => element.id == request.id)) {
        selectedRequests.removeWhere((element) => element.id == request.id);
        if (selectedRequests.isEmpty) {
          isSelectable = false;
        }
      } else {
        selectedRequests = selectedRequests + [request];
        isSelectable = true;
      }
    });
  }

  BuildContext? errorDialogContext;

  _listenDelete(DeleteRequestState state) {
    if (state is DeleteRequestLoadingState) {
      loadingDialog(context: context);
    } else if (state is DeleteRequestErrorState) {
      dismissDialog(loadingDialogContext);
      String? message;

      if (jDecode(state.response.body)['message'] is String) {
        message = jDecode(state.response.body)['message'];
      }

      showDialog2(
        context: context,
        barrierDismissible: false,
        builder: (
          _c,
        ) {
          errorDialogContext = _c;
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
                      'خطا',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TryAgain(
                    message: message,
                    onPressed: () {
                      dismissDialog(errorDialogContext);
                      deleteRequests(state.event.ids);
                    },
                  )
                ],
              ),
            ),
          );
        },
      );
    } else if (state is DeleteRequestSuccessState) {
      dismissDialog(loadingDialogContext);

      setState(() {
        requests.removeWhere(
            (element) => state.event.ids.any((e) => element.id == e));
      });
    }
  }

  deleteRequests(List<int> ids) {
    deleteRequestBloc.add(DeleteRequestEvent(ids: ids));
  }

  BuildContext? deleteDialogContext;

  showDeleteDialog(List<int> ids) {
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
                    Container(
                      decoration: BoxDecoration(
                        color: Themes.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
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
                          Expanded(
                            child: MaterialButton(
                              onPressed: () async {
                                dismissDeleteDialog();
                                deleteRequests(ids);
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
}
