part of 'package:siraf3/screens/estate_profile/estate_profile_screen.dart';

extension Profile on _EstateProfileScreen {
  Widget profile(BuildContext context, estateProfileModel.EstateProfile estateProfile) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Container(
            height: 190,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: App.theme.dialogBackgroundColor,
              border: !(showComment || moreDetail) ? null : Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Avatar(
                      size: 80,
                      imagePath: estateProfile.logoFile,
                      errorWidget: _profileWidget(),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.shade200, width: 1))),
                      child: Column(
                        children: [
                          Text(
                            estateProfile.name ?? "",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            estateProfile.guildCode ?? "",
                            style: TextStyle(fontSize: 11),
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
                              card(title: "فروشی", value: (estateProfile.countOnSale ?? 0).toString()),
                              card(title: "اجاره ای", value: (estateProfile.countRent ?? 0).toString()),
                              card(title: "ساخت و ساز", value: (estateProfile.countConstruction ?? 0).toString()),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              estateProfile.bio ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: App.theme.tooltipTheme.textStyle?.color, fontSize: 10),
                            ),
                            Text(
                              "آدرس : ${estateProfile.address}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: App.theme.tooltipTheme.textStyle?.color, fontSize: 10),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: viewMoreDetail,
                                  child: Text(
                                    moreDetail ? "کمتر" : "بیشتر...",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => setState(() {
                                    final bool previousValueOfMoreDetail = moreDetail;
                                    moreDetail = !moreDetail;
                                    // showComment = !showComment;

                                    // viewMoreDetail(force: false);

                                    if (!previousValueOfMoreDetail && !showComment) {
                                      showSearchBarWidget = true;
                                    }

                                    if (!previousValueOfMoreDetail && showComment) {
                                      showSearchBarWidget = false;
                                    }
                                  }),
                                  child: Text(
                                    !showComment ? "نمایش نظرات (${comments.length})" : "فایل های دفتر املاک",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
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
          if (moreDetail) profileDetail(estateProfile),
          if (!moreDetail && !showComment) searchBar(estateProfile.name ?? ""),
          if (showComment)
            Expanded(
              child: ListView.builder(
                itemCount: comments.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0)
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: addCommentWidget(estateProfile.id!),
                    );
                  return CommentItemWidget(estateId: widget.estateId, comment: comments[i - 1]);
                },
              ),
            ),
          if (!showComment) Expanded(child: BlocBuilder<FilesBloc, FilesState>(builder: _buildEstateFilesBloc)),
        ],
      ),
    );
  }

  Widget _profileWidget() {
    return Container(
      color: Color(0xfffafbfd),
      width: 80,
      height: 80,
      alignment: Alignment.center,
      child: Icon(CupertinoIcons.home, color: Themes.primary, size: 34),
    );
  }

  Widget _buildEstateFilesBloc(BuildContext context, FilesState state) {
    if (state is FilesLoadingState || state is FilesInitState) return Center(child: Loading());

    if (state is FilesErrorState) {
      return Center(child: TryAgain(onPressed: getFiles, message: state.message));
    }

    state = FilesLoadedState(files: (state as FilesLoadedState).files);

    files = state.files;

    return MyListView(
      isEmpty: files.isEmpty,
      emptyText: "این املاک فایلی ندارد",
      listView: ListView.builder(
        itemCount: files.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) return SizedBox(height: 10);
          return GestureDetector(
            onTap: () {
              push(context, FileScreen(id: files[i - 1].id!));
            },
            child: FileHorizontalItem(file: files[i - 1]),
          );
        },
      ),
    );
  }

  getFiles() {
    if (filesBloc.isClosed) {
      filesBloc = FilesBloc();
    }
    filesBloc.add(
      FilesLoadEvent(
        filterData: filterData,
      ),
    );
  }
}
