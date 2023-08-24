part of 'consultant_profile_screen.dart';

extension MyCard on _ConsultantProfileScreen {
  Widget card({required String title, required int? value}) {
    return Expanded(
      child: Container(
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Themes.text,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
            SizedBox(height: 2),
            Text(
              (value ?? 0).toString(),
              style: TextStyle(color: Themes.textGrey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
