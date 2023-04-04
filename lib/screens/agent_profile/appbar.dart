part of 'agent_profile_screen.dart';

extension AppBarWidget on _AgentProfileScreen {
  appBar() {
    return AppBar(
      backgroundColor: Themes.appBar,
      elevation: 0.7,
      automaticallyImplyLeading: false,
      leading: MyBackButton(),
      titleSpacing: 0,
      title: AppBarTitle(title),
      actions: [
        IconButton(onPressed: share, icon: icon(Icons.share_rounded)),
        MyPopupMenuButton(
          itemBuilder: (_) => [
            popupMenuItemWithIcon(title: "گزارش تخلف", onTap: report),
          ],
        ),
      ],
    );
  }
}
