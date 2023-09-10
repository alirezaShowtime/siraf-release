import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:siraf3/bloc/auth/edit_profile_bloc.dart';
import 'package:siraf3/dark_themes.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_text_icon_button.dart';
import 'package:siraf3/widgets/text_form_field_2.dart';
import 'package:siraf3/widgets/usefull/button/button_primary.dart';

import '../../main.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditProfileBloc editProfileBloc = EditProfileBloc();
  User? user;

  @override
  void initState() {
    super.initState();

    getUser();

    editProfileBloc.stream.listen((event) async { 
      if (event is EditProfileErrorState){
        notify(event.message);
      } else if (event is EditProfileSuccessState) {
        notify("پروفایل با موفقیت ویرایش شد");

        user!.name = event.name;
        user!.bio = event.bio;
        user!.avatar = event.avatar;
        await user!.save();

        Navigator.pop(context);
      }
    });
  }

  getUser() async {
    var u = await User.fromLocal();
    setState(() {
      user = u;
      nameController.text = u.name ?? "";
      descriptionController.text = u.bio ?? "";
    });
  }

  FileImage? fileImage;
  String? name;
  String? description;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => editProfileBloc,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: App.getSystemUiOverlayTransparentLight(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Stack(
                children: [
                  _profileWidget(),
                  Positioned(
                    top: MediaQuery.of(context).padding.top,
                    right: 7,
                    child: MyBackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Themes.textLight,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 5,
                    child: MyTextIconButton(
                      onPressed: _uploadImage,
                      text: "آپلود تصویر",
                      color: Colors.white,
                      icon: Icon(
                        CupertinoIcons.camera,
                        size: 24,
                        color: Themes.iconLight,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 14,
                      ),
                      Text(
                        "نام و نام خانوادگی",
                        style: TextStyle(
                          fontSize: 14,
                          color: App.theme.textTheme.bodyLarge?.color,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "نام و نام خانوادگی خود را به صورت کامل بنویسید",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontFamily: "IranSansMedium",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField2(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.dividerColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.dividerColor,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.primaryColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                        ),
                        style: TextStyle(fontSize: 14, color: App.theme.textTheme.bodyLarge?.color ?? Themes.text),
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        cursorColor: App.theme.primaryColor,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "لطفا نام و نام خانوادگی را بنویسید";
                          }
                        },
                        onSaved: ((newValue) {
                          setState(() {
                            name = newValue;
                          });
                        }),
                        controller: nameController,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: BlocBuilder<EditProfileBloc, EditProfileState>(
                  builder: (context, state) {
                    if (state is EditProfileLoadingState) {
                      return Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: App.theme.primaryColor,
                        ),
                        child: Loading(
                          color: Colors.white,
                          backgroundColor: Colors.transparent,
                          size: 25.0,
                        ),
                      );
                    }
                    return ButtonPrimary(
                      onPressed: _apply,
                      text: "ویرایش اطلاعات",
                      fullWidth: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 3 * 1.7,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/menu_background.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            App.isDark ? DarkThemes.background : App.theme.primaryColor,
            BlendMode.hardLight,
          ),
        ),
      ),
      child: Hero(
        tag: "profileImage",
        child: Avatar(
          image: (fileImage ?? NetworkImage(user?.avatar ?? ""))
              as ImageProvider<Object>,
          size: 120,
          errorWidget: _profileDefaultWidget(),
          loadingWidget: Container(
            color: App.theme.primaryColor.withOpacity(0.7),
            width: 120,
            height: 120,
            alignment: Alignment.center,
            child: SpinKitRing(
              size: 25,
              lineWidth: 2,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  _profileDefaultWidget() => Container(
        color: App.theme.primaryColor.withOpacity(0.7),
        width: 120,
        height: 120,
        alignment: Alignment.center,
        child: Icon(
          Icons.person_rounded,
          color: Colors.white,
          size: 44,
        ),
      );

  _uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowedExtensions: image_extensions,
        type: FileType.custom);

    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.first.path!);
      if (!checkImageExtension(file.path)) {
        notify(
            'فرمت فایل انتخابی باید یکی از فرمت های ' +
                image_extensions.join(", ") +
                " باشد",
            duration: Duration(seconds: 4));
        return;
      }

      setState(() {
        fileImage = FileImage(file);
      });
    }
  }

  _apply() {
    editProfileBloc.add(
      EditProfileEvent(
        name: nameController.text.isEmpty ? null : nameController.text,
        bio: descriptionController.text.isEmpty
            ? null
            : descriptionController.text,
        avatar: fileImage,
      ),
    );
  }
}
