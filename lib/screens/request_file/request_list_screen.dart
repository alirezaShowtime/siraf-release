import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/requests_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/request_file/request_file_screen.dart';
import 'package:siraf3/screens/request_file/request_file_show_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/models/request.dart';
import 'package:siraf3/widgets/try_again.dart';

class RequestListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RequestListScreen();
}

class _RequestListScreen extends State<RequestListScreen> {
  //todo: selecting item when longClick is`t done
  //todo: String type is a test type, this must be a model class
  List<Request> selectedRequests = [];

  RequestsBloc requestsBloc = RequestsBloc();

  @override
  void initState() {
    super.initState();

    getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => requestsBloc,
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
            titleSpacing: 0,
            elevation: 0.7,
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
            backgroundColor: Themes.appBar,
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
                  icon: icon(Icons.sort_rounded),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                        child:
                            Text("جدیدترین", style: TextStyle(fontSize: 12))),
                    PopupMenuItem(
                        child:
                            Text("قدیمی ترین", style: TextStyle(fontSize: 12))),
                    PopupMenuItem(
                        child: Text("در انتظار تایید",
                            style: TextStyle(fontSize: 12))),
                    PopupMenuItem(
                        child: Text("در انتظار پذیرش",
                            style: TextStyle(fontSize: 12))),
                    PopupMenuItem(
                        child:
                            Text("پذیرش شده", style: TextStyle(fontSize: 12))),
                    PopupMenuItem(
                        child:
                            Text("عدم پذیرش", style: TextStyle(fontSize: 12))),
                    PopupMenuItem(
                        child: Text("رد شده", style: TextStyle(fontSize: 12))),
                  ],
                ),
              ),
              MyPopupMenuButton(
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      "انتخاب همه",
                      style: TextStyle(fontSize: 12),
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

  Map<int, String> statuses = {
    0: "در انتظار تایید",
    1: "در انتظار تایید",
    2: "در انتظار تایید",
    3: "در انتظار تایید",
    4: "در انتظار تایید",
  };

  bool isSelectable = false;

  Widget item(Request request) {
    return InkWell(
      onTap: () =>
          isSelectable ? changeSelection(request) : onClickItem(request),
      onLongPress: () => changeSelection(request),
      child: Container(
        color: Colors.white,
        foregroundDecoration: BoxDecoration(
          color: selectedRequests.any((element) => element.id == request.id)
              ? Themes.blue.withOpacity(0.2)
              : Colors.transparent,
        ),
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "اجاره ای | ${request.title}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "یک روز پیش",
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 10,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${request.id}",
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
                Text(
                  statuses[request.status] ?? "null",
                  style: TextStyle(
                    //todo: I have an idea that the text color status will be sort the color base on status, for example green when the status is approved
                    color: Themes.text,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //event listeners

  void requestFile() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => RequestFileScreen()));
  }

  void removeFile() {
    //todo: implement event listener
  }

  void onClickItem(Request request) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => RequestFileShowScreen()));
  }

  void getRequests() {
    requestsBloc.add(RequestsEvent());
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
}
