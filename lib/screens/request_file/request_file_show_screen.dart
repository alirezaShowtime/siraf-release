import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:siraf3/bloc/delete_request_bloc.dart';
import 'package:siraf3/bloc/request_consulants_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/request.dart';
import 'package:siraf3/models/request_consultant.dart';
import 'package:siraf3/screens/consultant_profile/consultant_profile_screen.dart';
import 'package:siraf3/screens/request_file/edit_request_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';
import 'package:siraf3/widgets/try_again.dart';

class RequestFileShowScreen extends StatefulWidget {
  Request request;

  RequestFileShowScreen({required this.request});

  @override
  State<RequestFileShowScreen> createState() => _RequestFileShowScreen();
}

class _RequestFileShowScreen extends State<RequestFileShowScreen> {
  RequestConsultantBloc requestConsultantBloc = RequestConsultantBloc();
  DeleteRequestBloc deleteRequestBloc = DeleteRequestBloc();

  Map<int, Color?> statusColors = {
    5: Color(0xfffdb713), // عدم پذیرش
    1: Color(0xff00cc11), // تایید شده
    2: Color(0xfffd1313), // رد شده
    3: Colors.grey, // در انتظار تایید
    4: Color(0xff00cc11), // پذیرش شده
  };

  Map<int, String?> statusHelpTexts = {
    5: """متاسفانه درخواست شما جهت پیگیری پذیرفته نشد. این موضوع می تواند به دلایل مختلفی مانند غیر واقعی بودن درخواست و توضیحات مبهم رخ داده باشد. در صورت تمایل درخواست خود را جهت رسیدگی مجدد ویرایش نمایید. """, // عدم پذیرش
    4: """درخواست شما توسط مشاور / مشاوران زیر پذیرش شده""", // پذیرش شده
    2: null, // رد شده
    // 1: """لطفا تا پذیرش درخواست فایل خود توسط دفتر / دفاتر املاک شکیبا باشید. این وضعیت نهایتا تا 24 ساعت زمان خواهد""", // در انتظار پذیرش
    1: null,
    3: """برسی درخواست های فایل به صورت 24 ساعته می باشد و حداکثر 2 ساعت زمان خواهد برد.""", // در انتظار تایید
  };

  @override
  void initState() {
    super.initState();

    deleteRequestBloc.stream.listen(_listenDelete);

    if (widget.request.status == 1) {
      requestConsultantBloc.add(RequestConsultantEvent(id: widget.request.id!));
    }
  }

  @override
  void dispose() {
    super.dispose();

    requestConsultantBloc.close();
    deleteRequestBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => requestConsultantBloc,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0.7,
          leading: MyBackButton(),
          automaticallyImplyLeading: false,
          title: AppBarTitle("درخواست شماره : ${widget.request.id}"),
          actions: [
            IconButton(onPressed: showDeleteDialog, icon: icon(CupertinoIcons.delete, size: 20)),
            MyPopupMenuButton(
              itemBuilder: (_) => [
                MyPopupMenuItem<String>(
                  value: "edit",
                  label: "ویرایش درخواست",
                ),
              ],
              onSelected: (v) => onClickEditRequest(),
              iconData: Icons.more_vert,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 18, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.request.categoryId!.fullCategory! + " | ${widget.request.title}",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "IranSansBold",
                ),
              ),
              SizedBox(height: 10),
              Text(
                "محدوده ${widget.request.isRent() ? 'ودیعه' : 'قیمت'} : " + (createLabel(widget.request.minPrice, widget.request.maxPrice, "تومان") ?? ""),
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "IranSansBold",
                ),
              ),
              if (widget.request.isRent())
                Text(
                  "محدوده اجاره : " + (createLabel(widget.request.minRent, widget.request.maxRent, "تومان", emptyLabel: "توافقی") ?? ""),
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "IranSansBold",
                  ),
                ),
              Text(
                "محدوده متراژ: " + (createLabel(widget.request.minMeter, widget.request.maxMeter, "متر") ?? ""),
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "IranSansBold",
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.request.description ?? "",
                style: TextStyle(
                  color: App.theme.tooltipTheme.textStyle?.color,
                  fontSize: 11,
                  fontFamily: "IranSansMedium",
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.request.createDate ?? "",
                      style: TextStyle(
                        fontFamily: "IranSansMedium",
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "کد پیگیری : ${widget.request.id}",
                      style: TextStyle(
                        fontFamily: "IranSansBold",
                        fontSize: 12,
                        color: App.theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "وضعیت : ${widget.request.statusString}",
                style: TextStyle(
                  fontFamily: "IranSansBold",
                  fontSize: 12,
                  backgroundColor: statusColors[widget.request.status]!.withOpacity(0.3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  statusHelpTexts[widget.request.status!] ?? (widget.request.commentOperator ?? ""),
                  style: TextStyle(
                    color: App.theme.tooltipTheme.textStyle?.color,
                    fontSize: 11,
                    fontFamily: "IranSansMedium",
                  ),
                ),
              ),
              //todo: if status is accepted, show blow widget
              SizedBox(height: 10),
              if (widget.request.status == 1) BlocBuilder<RequestConsultantBloc, RequestConsultantState>(builder: _requestConsultantBlocBuilder),
            ],
          ),
        ),
      ),
    );
  }

  String? createLabel(int? min, int? max, String label, {String emptyLabel = "_"}) {
    if ((min == null && max == null) || (min == 0 && max == null) || (max == 0 && min == null) || (min == 0 && max == 0)) return emptyLabel;

    String text = "";

    if (min != null) {
      text += "از " + number_format(min);
    }

    if (max != 0 && max != null) {
      text += " تا " + number_format(max);
    }

    return "${text} ${label}";
  }

  Widget item(RequestConsultant requestConsultant) {
    return GestureDetector(
      onTap: () {
        push(
          context,
          ConsultantProfileScreen(
            consultantId: requestConsultant.consultantId!.id!,
            consultantName: requestConsultant.consultantId?.name,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: NetworkImage(requestConsultant.consultantId?.avatar ?? ""),
                    height: 40,
                    width: 40,
                    fit: BoxFit.fill,
                    errorBuilder: (context, child, eventProgress) {
                      return Image.asset(
                        "assets/images/profile.jpg",
                        width: 40,
                        height: 40,
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                      );
                    },
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      requestConsultant.consultantId!.name ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "IranSansBold",
                      ),
                    ),
                    Text(
                      "(${requestConsultant.estateName})",
                      style: TextStyle(fontSize: 10, color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey),
                    ),
                    SizedBox(height: 6),
                    RatingBarIndicator(
                      rating: (requestConsultant.consultantId?.rate?.toDouble() ?? 0),
                      // minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      // allowHalfRating: true,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0.25),
                      itemBuilder: (context, _) => icon(Icons.star, color: Colors.amber),
                      itemSize: 10,
                      // onRatingUpdate: (double value) {},
                      // updateOnDrag: false,
                      // ignoreGestures: true,
                      unratedColor: Colors.grey.shade300,
                    ),
                  ],
                ),
              ],
            ),
            IconButton(onPressed: () => call(requestConsultant.consultantId!), icon: icon(Icons.phone_rounded)),
          ],
        ),
      ),
    );
  }

  void onClickEditRequest() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditRequestScreen(request: widget.request),
      ),
    );
  }

  void call(ConsultantId consultantId) {
    var phone = consultantId.phone;

    if (phone == null) {
      return notify("شماره تماس مشاور نامشخص است");
    }

    callTo(phone);
  }

  void startChat(RequestConsultant requestConsultant) {}

  void removeRequest() {
    deleteRequestBloc.add(DeleteRequestEvent(ids: [widget.request.id!]));
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
                        fontFamily: "IranSansBold",
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
                      removeRequest();
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

      Navigator.pop(context, 'removed');

      notify("درخواست با موفقیت حذف شد");
    }
  }

  BuildContext? deleteDialogContext;

  showDeleteDialog() {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        deleteDialogContext = _;
        return ConfirmDialog(
          dialogContext: context,
          content: 'آیا مایل به حذف درخواست هستید؟',
          title: "حذف درخواست",
          titleColor: Colors.red,
          onApply: () {
            dismissDeleteDialog();
            removeRequest();
          },
        );
      },
    );
  }

  dismissDeleteDialog() {
    if (deleteDialogContext != null) {
      Navigator.pop(deleteDialogContext!);
    }
  }

  Widget _requestConsultantBlocBuilder(BuildContext context, RequestConsultantState state) {
    if (state is RequestConsultantInitState) {
      return Container();
    }
    if (state is RequestConsultantLoadingState) {
      return Expanded(
        child: Center(
          child: Loading(),
        ),
      );
    }
    if (state is RequestConsultantErrorState) {
      if (jDecode(state.response?.body ?? "{}")['code'] == 400) {
        consultants = [];
        return Container();
      }
      return Expanded(
        child: Center(
          child: TryAgain(
            message: jDecode(state.response?.body ?? "{}")['message'],
            onPressed: () {
              requestConsultantBloc.add(RequestConsultantEvent(id: widget.request.id!));
            },
          ),
        ),
      );
    }

    state = RequestConsultantLoadedState(consultants: (state as RequestConsultantLoadedState).consultants);

    consultants = state.consultants;

    return Expanded(
      child: ListView(
        children: consultants.map<Widget>((e) => item(e)).toList(),
      ),
    );
  }

  List<RequestConsultant> consultants = [];
}
