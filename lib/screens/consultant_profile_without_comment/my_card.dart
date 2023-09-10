part of 'consultant_profile_screen.dart';

extension MyCard on _ConsultantProfileScreen {
  Widget card({required String title, required int? value, void Function()? onTap}) {
    return Expanded(
      child: MyTextButton(
        onPressed: onTap,
        rippleColor: Colors.grey,
        child: Container(
          height: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 2),
              Text(
                (value ?? 0).toString(),
                style: TextStyle(
                  fontSize: 11,
                  color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                  fontFamily: "IranSansBold",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
