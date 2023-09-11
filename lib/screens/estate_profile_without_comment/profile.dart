part of 'estate_profile_screen.dart';

extension Profile on _EstateProfileScreen {
  Widget profile(BuildContext context, estateProfileModel.EstateProfile estateProfile) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 180),
            padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 5),
            decoration: BoxDecoration(
              color: App.theme.dialogBackgroundColor,
              border: !(moreDetail || showComment) ? null : Border(bottom: BorderSide(width: 1, color: App.isDark ? Color.fromARGB(255, 43, 43, 43) : Colors.grey.shade200)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  child: Row(
                    children: [
                      Avatar(
                        imagePath: estateProfile.logoFile,
                        errorWidget: _profileWidget(),
                        loadingWidget: _profileWidget(),
                        size: 80,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            card(
                                title: "فروشی",
                                value: estateProfile.countOnSale,
                                onTap: () {
                                  goToFiles(category: Category(id: 1, name: 'فروشی'), appBarTitle: "${estateProfile.name}");
                                }),
                            card(
                                title: "اجاره ای",
                                value: estateProfile.countRent,
                                onTap: () {
                                  goToFiles(category: Category(id: 2, name: 'اجاره ای'), appBarTitle: "${estateProfile.name}");
                                }),
                            card(
                                title: "ساخت و ساز",
                                value: estateProfile.countConstruction,
                                onTap: () {
                                  goToFiles(category: Category(id: 3, name: 'ساخت و ساز'), appBarTitle: "${estateProfile.name}");
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 88,
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          border: Border(left: BorderSide(color: Colors.grey.shade200, width: 1)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              estateProfile.name ?? "بدون نام",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              estateProfile.guildCode!,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: App.theme.textTheme.bodyLarge?.color ?? Themes.text, fontSize: 11),
                            ),
                            StaticStar(rating: estateProfile.rate ?? 0),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "با مدیریت ${estateProfile.managerName}",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "IranSansBold",
                              ),
                            ),
                            Text(
                              estateProfile.bio ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                                fontFamily: "IranSansMedium",
                              ),
                            ),
                            SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: viewMoreDetail,
                                  child: Text(
                                    moreDetail ? "کمتر" : "بیشتر...",
                                    style: TextStyle(fontFamily: "IranSansBold", fontSize: 9),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => setState(() {
                                    moreDetail = !moreDetail;
                                    showComment = !showComment;
                                    viewMoreDetail(force: false);
                                  }),
                                  child: Text(
                                    !showComment ? "ثبت امتیاز" : "فایل های دفتر املاک",
                                    style: TextStyle(fontFamily: "IranSansBold", fontSize: 9),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!moreDetail && !showComment) searchBar(estateProfile.name ?? ""),
          if (moreDetail) profileDetail(estateProfile),
          if (showComment && !moreDetail) addCommentWidget(estateProfile.id!),
          if (!showComment && !moreDetail) Expanded(child: BlocBuilder<EstateFilesBloc, FilesState>(builder: (context, state) => _buildEstateFilesBloc(context, state, estateProfile))),
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
      child: Icon(CupertinoIcons.home, color: App.theme.primaryColor, size: 34),
    );
  }

  Widget _buildEstateFilesBloc(BuildContext context, FilesState state, var estateProfile) {
    if (state is FilesLoadingState || state is FilesInitState) return Center(child: Loading());

    if (state is FilesErrorState) {
      return Center(child: TryAgain(onPressed: getFiles, message: state.message));
    }

    state = FilesLoadedState(files: (state as FilesLoadedState).files);

    files = state.files;

    return MyListView(
      isEmpty: files.isEmpty,
      emptyText: "این املاک فایلی ندارد",
      listView: ListView(
        controller: filesListViewController,
        children: [
          SizedBox(height: 15),
          for (var file in files)
            GestureDetector(
              onTap: () {
                push(context, FileScreen(id: file.id!));
              },
              child: FileHorizontalItem(file: file),
            ),
        ],
      ),
    );
  }

  getFiles() {
    if (filesBloc.isClosed) {
      filesBloc = EstateFilesBloc();
    }
    filesBloc.add(FilesLoadEvent(filterData: filterData));
  }

  goToFiles({String? appBarTitle, Category? category, FilterData? filterData}) async {
    return push(
      context,
      EstateFilesScreen(
        filterData: filterData ?? FilterData(
          category: category,
          estateId: widget.estateId,
        ),
        appBarTitle: appBarTitle,
      ),
    );
  }

  Widget viewMoreWidget() {
    return GestureDetector(
      onTap: () {
        goToFiles(filterData: filterData);
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.only(top: 5),
        color: Colors.grey.shade200,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 15,
              height: 15,
              child: icon(
                CupertinoIcons.down_arrow,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "نمایش موارد بیشتر",
              style: TextStyle(
                fontSize: 10,
                fontFamily: "IranSansBold",
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
