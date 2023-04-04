part of 'agent_profile_screen.dart';

extension Profile on _AgentProfileScreen {
  Widget profile(ConsultantInfo consultantInfo) {
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
                    Avatar(size: 80, imagePath: consultantInfo.avatar),
                    Container(
                      padding: const EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.shade200, width: 1))),
                      child: Column(
                        children: [
                          Text(
                            consultantInfo.name!,
                            style: TextStyle(
                              color: Themes.text,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          StaticStar(rating: consultantInfo.rate ?? 0),
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
                              card(title: "فروشی", value: consultantInfo.countOnSale.toString(), onTap: () {}),
                              card(title: "اجاره ای", value: consultantInfo.countRent.toString(), onTap: () {}),
                              card(title: "ساخت و ساز", value: consultantInfo.countConstruction.toString(), onTap: () {}),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "ds;ofdskj dolspfk dkdofdks oidmnsfk dnf dosmjfoidns d[sk fldpofdspofmks dpolfkdms dms,fp[doskjf ods,fkdpsnf dpsfdms fdskmofds",
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
                                    !showComment ? "نمایش نظرات (${consultantInfo.comment?.length ?? 0})" : "فایل های مشاور",
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
            child: profileDetail(),
          ),
          if (showSearchBarWidget) searchBar(),
          if (showComment)
            //todo: show list-is-empty image, if don`s exists comments
            Expanded(
              child: ListView.builder(
                itemCount: (consultantInfo.comment?.length ?? 0) + 1,
                itemBuilder: (context, i) {
                  if (i == 0) return addCommentWidget(consultantId: consultantInfo.id!);
                  return commentItem(consultantInfo.comment![i - 1]);
                },
              ),
            ),
          if (!showComment)
            //todo: show list-is-empty image, if don`s exists comments
            //todo: the endpoint to get file list of consultant is isolate
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
