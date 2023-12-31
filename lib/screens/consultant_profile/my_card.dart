part of 'consultant_profile_screen.dart';

extension MyCard on _ConsultantProfileScreen {
  Widget card({
    required String title,
    required String value,
    void Function()? onTap,
  }) {
    return Expanded(
      child: Container(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                fontFamily: "IranSansBold",
                fontSize: 11,
              ),
            ),
            SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
