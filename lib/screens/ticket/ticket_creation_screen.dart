import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/widgets/block_btn.dart';
import 'package:siraf3/widgets/field_dialog.dart';
import 'package:siraf3/widgets/list_dialog.dart';
import 'package:siraf3/widgets/section.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';

enum SupportSection {
  submitFile,
  marketing,
  technical,
  report,
}

class TicketCreationScreen extends StatefulWidget {
  @override
  State<TicketCreationScreen> createState() => _TicketCreationScreen();
}

class _TicketCreationScreen extends State<TicketCreationScreen> {
  SupportSection? supportSection;
  String? title;
  String? fullName;
  String? numberPhone;
  String? emailAddress;

  TextEditingController titleController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController numberPhoneController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();

  Map<SupportSection, String> supportSectionsLabel = {
    SupportSection.submitFile: "ثبت فایل و درخواست",
    SupportSection.marketing: "فروش ،بازاریابی و مالی",
    SupportSection.technical: "فنی",
    SupportSection.report: "گزارشات و پیشنهادات",
  };

  List<Map<String, dynamic>> _getSupportSectionList() {
    List<Map<String, dynamic>> list = [];

    supportSectionsLabel.forEach((section, label) {
      list.add({"name": label, "value": section});
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(titleText: "پشتیبانی آنلاین"),
      body: Padding(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            Section(
              title: "بخش پشتیبانی",
              hint: "انتخاب",
              value: supportSectionsLabel[supportSection],
              onTap: determineSupportSection,
            ),
            Section(
              title: "عنوان",
              hint: "تعیین",
              value: title,
              onTap: determineTitle,
            ),
            Section(
              title: "نام و نام خانوادگی",
              hint: "تعیین",
              value: fullName,
              onTap: determineFullName,
            ),
            Section(
              title: "شماره تماس",
              hint: "تعیین",
              value: numberPhone,
              onTap: determineNumberPhone,
            ),
            Section(
              title: "آدرس ایمیل(اختیاری)",
              hint: "تعیین",
              value: emailAddress,
              onTap: determineEmailAddress,
            ),
            BlockBtn(
              text: "شروع گفتگو",
              padding: EdgeInsets.only(top: 15),
              onTap: createTicked,
            ),
          ],
        ),
      ),
    );
  }

  //event listeners
  void createTicked() {
    //todo: implement event listener

    if (supportSection != null ||
        title != null ||
        fullName != null ||
        numberPhone != null) {
      notify("فیلدها خالی هستند");
      return;
    }

    if (!isValidNumberPhone(numberPhone!)) {
      notify("شماره تماس نامعتبر است");
      return;
    }
  }

  void determineSupportSection() {
    //todo: implement event listener

    showDialog(
      context: context,
      builder: (context) {
        return ListDialog(
          list: _getSupportSectionList(),
          onItemTap: (item) {
            supportSection = item["value"];
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void determineTitle() {
    //todo: implement event listener

    showDialog(
      context: context,
      builder: (context) {
        return FieldDialog(
          numberFieldController: titleController,
          hintText: "عنوان را وارد کنید",
          onPressed: () {
            title = titleController.value.text;
            setState(() {});
          },
        );
      },
    );
  }

  void determineFullName() {
    //todo: implement event listener

    showDialog(
      context: context,
      builder: (context) {
        return FieldDialog(
          numberFieldController: fullNameController,
          hintText: "نام و نام خانوادگی را وارد کنید",
          onPressed: () {
            fullName = fullNameController.value.text;
            setState(() {});
          },
        );
      },
    );
  }

  void determineNumberPhone() {
    //todo: implement event listener

    showDialog(
      context: context,
      builder: (context) {
        return FieldDialog(
          numberFieldController: numberPhoneController,
          hintText: "شماره تماس وارد کنید",
          keyboardType: TextInputType.number,
          onPressed: () {
            numberPhone = numberPhoneController.value.text;
            setState(() {});
          },
        );
      },
    );
  }

  void determineEmailAddress() {
    //todo: implement event listener

    showDialog(
      context: context,
      builder: (context) {
        return FieldDialog(
          numberFieldController: emailAddressController,
          hintText: "آدرس ایمیل را وارد کنید",
          onPressed: () {
            emailAddress = emailAddressController.value.text;
            setState(() {});
          },
        );
      },
    );
  }
}
