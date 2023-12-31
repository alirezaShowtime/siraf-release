part of 'consultant_profile_screen.dart';

extension SearchBar on _ConsultantProfileScreen {
  Widget searchBar() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: App.theme.textTheme.bodyLarge?.color ?? Themes.text, width: 1),
                ),
              ),
              child: TextField2(
                controller: searchController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: "جستجو در امللاک برج",
                  border: InputBorder.none,
                  isDense: true,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 11,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
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
          IconButton(
            onPressed: viewFilterFileWidget,
            icon: icon(OctIcons.sliders_16, size: 15),
            constraints: BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
