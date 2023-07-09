part of 'package:siraf3/screens/estate_profile/estate_profile_screen.dart';

extension Profile on _EstateProfileScreen {
  Widget profile(BuildContext context, estateProfileModel.EstateProfile estateProfile) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Container(
            height: 170,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            color: App.theme.dialogBackgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Avatar(size: 80, imagePath: estateProfile.logoFile, errorWidget: _profileWidget(),),
                    Container(
                      padding: const EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(border: Border(left: BorderSide(color: Colors.grey.shade200, width: 1))),
                      child: Column(
                        children: [
                          Text(
                            estateProfile.name ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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
                              card(title: "فروشی", value: (estateProfile.countOnSale ?? 0).toString(), onTap: () {}),
                              card(title: "اجاره ای", value: (estateProfile.countRent ?? 0).toString(), onTap: () {}),
                              card(title: "ساخت و ساز", value: (estateProfile.countConstruction ?? 0).toString(), onTap: () {}),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              estateProfile.bio ?? "",
                              maxLines: 2,
                              style: TextStyle(color: App.theme.tooltipTheme.textStyle?.color, fontSize: 11),
                            ),
                            Text(
                              "آدرس : ${estateProfile.address}",
                              maxLines: 2,
                              style: TextStyle(color: App.theme.tooltipTheme.textStyle?.color, fontSize: 11),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: viewMoreDetail,
                                  child: Text(
                                    moreDetail ? "کمتر" : "بیشتر...",
                                    style: TextStyle(
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
          // SizeTransition(
          //   sizeFactor: collapseAnimation,
          //   axis: Axis.vertical,
          //   child: profileDetail(estateProfile),
          // ),
          if (!showComment) searchBar(estateProfile.name ?? ""),
          if (showComment)
            Expanded(
              child: ListView.builder(
                itemCount: (estateProfile.comment?.length ?? 0) + 1,
                itemBuilder: (context, i) {
                  if (i == 0) return addCommentWidget(estateProfile.id!);

                  return commentItem(estateProfile.comment![i - 1]);
                },
              ),
            ),
          if (!showComment)
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: list.length,
            //     itemBuilder: (context, i) => fileItem(list[i]),
            //   ),
            // ),
            Expanded(
                child: BlocBuilder<FilesBloc, FilesState>(
              builder: _buildEstateFilesBloc,
            )),
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
    if (state is FilesInitState) return Container();

    if (state is FilesLoadingState)
      return Center(
        child: Loading(),
      );

    if (state is FilesErrorState) {
      return Center(
        child: TryAgain(
          onPressed: getFiles,
          message: state.response != null ? jDecode(state.response!.body)['message'] : null,
        ),
      );
    }

    state = FilesLoadedState(files: (state as FilesLoadedState).files);

    files = state.files;

    return ListView(
      children: files
          .map<Widget>(
            (e) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FileScreen(id: e.id!),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(top: files.first == e ? 0 : 5),
                child: FileHorizontalItem(file: e),
              ),
            ),
          )
          .toList(),
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
