part of 'consultant_profile_screen.dart';

extension AppBarWidget on _ConsultantProfileScreen {
  appBar() {
    return AppBar(
      backgroundColor: Themes.appBar,
      elevation: 0.7,
      automaticallyImplyLeading: false,
      leading: MyBackButton(),
      titleSpacing: 0,
      title: AppBarTitle(title),
      actions: [
        IconButton(onPressed: share, icon: icon(Icons.share_rounded, size: 22)),
        MyPopupMenuButton(
          itemBuilder: (_) => [
            popupMenuItem(
              title: "گزارش تخلف",
              value: "report",
            ),
          ],
          onSelected: (v) => report(),
          iconData: Icons.more_vert,
        ),
      ],
    );
  }
}
