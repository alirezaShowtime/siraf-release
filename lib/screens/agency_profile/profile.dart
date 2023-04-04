part of 'package:siraf3/screens/agency_profile/agency_profile_screen.dart';

extension Profile on _AgencyProfileScreen {
  Widget profile(BuildContext context, estateProfileModel.EstateProfile estateProfile) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Container(
            height: 170,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Avatar(size: 80, imagePath: estateProfile.logoFile),
                    Container(
                      padding: const EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.shade200, width: 1))),
                      child: Column(
                        children: [
                          Text(
                            estateProfile.name ?? "",
                            style: TextStyle(
                              color: Themes.text,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            estateProfile.guildCode ?? "",
                            style: TextStyle(color: Themes.text, fontSize: 11),
                          ),
                          StaticStar(rating: estateProfile.rate ?? 0),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              card(title: "فروشی", value: (estateProfile.countOnSale ?? 0).toString(), onTap: () {}),
                              card(title: "اجاره ای", value: (estateProfile.countRent ?? 0).toString(), onTap: () {}),
                              card(title: "ساخت و ساز", value: (estateProfile.countConstruction ?? 0).toString(), onTap: () {}),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              estateProfile.bio ?? "",
                              maxLines: 2,
                              style: TextStyle(color: Themes.textGrey, fontSize: 11),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: viewMoreDetail,
                                  child: Text(
                                    moreDetail ? "کمتر" : "بیشتر...",
                                    style: TextStyle(
                                      color: Themes.text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    final bool previousValueOfMoreDetail = moreDetail;
                                    showComment = !showComment;

                                    viewMoreDetail(force: false);

                                    if (!previousValueOfMoreDetail && !showComment) {
                                      showSearchBarWidget = true;
                                    }

                                    if (!previousValueOfMoreDetail && showComment) {
                                      showSearchBarWidget = false;
                                    }
                                  }),
                                  child: Text(
                                    !showComment ? "نمایش نظرات (${estateProfile.comment?.length ?? 0})" : "فایل های دفتر املاک",
                                    style: TextStyle(
                                      color: Themes.text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: collopsAnimation,
            axis: Axis.vertical,
            child: profileDetail(estateProfile),
          ),
          if (showSearchBarWidget) searchBar(estateProfile.name ?? ""),
          if (showComment)
            Expanded(
              child: ListView.builder(
                itemCount: (estateProfile.comment?.length ?? 0) + 1,
                itemBuilder: (context, i) {
                  if (i == 0) return addCommentWidget(estateProfile.id!);

                  return commentItem(estateProfile.comment![i - 0]);
                },
              ),
            ),
          if (!showComment)
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) => fileItem(list[i]),
              ),
            ),
        ],
      ),
    );
  }
}
