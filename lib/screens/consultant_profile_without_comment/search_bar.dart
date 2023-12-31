part of 'consultant_profile_screen.dart';

extension SearchBar on _ConsultantProfileScreen {
  Widget searchBar(String estateName) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: App.theme.dialogBackgroundColor,
        border: Border(
          bottom: BorderSide(color: App.isDark ? Colors.grey.shade900 : Colors.grey.shade200, width: 1),
          top: BorderSide(color: App.isDark ? Colors.grey.shade900 : Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: TextField2(
                controller: searchController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "جستجو در فایل های مشاور",
                  border: InputBorder.none,
                  isDense: true,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 11, fontFamily: "IranSansMedium"),
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  color: App.theme.textTheme.bodyLarge?.color,
                  fontSize: 11,
                  fontFamily: "IranSansMedium",
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
            badgeStyle: badges.BadgeStyle(badgeColor: App.theme.primaryColor),
            child: IconButton(
              onPressed: viewFilterFileWidget,
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
