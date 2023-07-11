part of 'package:siraf3/screens/estate_profile/estate_profile_screen.dart';

extension SearchBar on _EstateProfileScreen {
  Widget searchBar(String estateName) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: App.theme.dialogBackgroundColor,
        border: Border(
          bottom: BorderSide(
              color: App.isDark ? Colors.grey.shade900 : Colors.grey.shade200,
              width: 1),
          top: BorderSide(
              color: App.isDark ? Colors.grey.shade900 : Colors.grey.shade200,
              width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                      color: App.isDark ? Themes.textGrey : Themes.text,
                      width: 1),
                ),
              ),
              child: TextField2(
                controller: searchController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "جستجو در $estateName",
                  border: InputBorder.none,
                  isDense: true,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 11,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  color: App.theme.textTheme.bodyLarge?.color,
                  fontSize: 11,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (v) {
                  setState(() {
                    filterData.search = v.isFill() ? v : null;
                  });

                  getFiles();
                },
              ),
            ),
          ),
          badges.Badge(
            badgeContent: Text(''),
            showBadge: filterData.hasFilter(),
            position: badges.BadgePosition.custom(top: -15, end: -6),
            badgeStyle: badges.BadgeStyle(badgeColor: Themes.primary),
            child: IconButton(
              onPressed: openFileBox,
              icon: icon(OctIcons.sliders_16, size: 20),
              constraints: BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
