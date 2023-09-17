part of 'consultant_profile_screen.dart';

extension Profile on _ConsultantProfileScreen {
  Widget profile(ConsultantInfo consultantInfo) {
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
                        imagePath: consultantInfo.avatar,
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
                                value: consultantInfo.countOnSale,
                                onTap: () {
                                  goToFiles(category: Category(id: 1, name: 'فروشی'), appBarTitle: "فایل های ${consultantInfo.name}");
                                }),
                            card(
                                title: "اجاره ای",
                                value: consultantInfo.countRent,
                                onTap: () {
                                  goToFiles(category: Category(id: 2, name: 'اجاره ای'), appBarTitle: "فایل های ${consultantInfo.name}");
                                }),
                            card(
                                title: "ساخت و ساز",
                                value: consultantInfo.countConstruction,
                                onTap: () {
                                  goToFiles(category: Category(id: 3, name: 'ساخت و ساز'), appBarTitle: "فایل های ${consultantInfo.name}");
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
                              consultantInfo.name ?? "بدون نام",
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StaticStar(rating: consultantInfo.rate ?? 0.0),
                            SizedBox(height: 5),
                            InkWell(
                              onTap: () {
                                push(
                                  context,
                                  EstateProfileScreen(
                                    estateId: consultantInfo.estateId!,
                                    estateName: consultantInfo.estateName,
                                  ),
                                );
                              },
                              child: Text(
                                consultantInfo.estateName!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: App.theme.primaryColor,
                                  fontSize: 10,
                                  fontFamily: "IranSansBold",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              consultantInfo.bio ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: "IranSansMedium",
                              ),
                            ),
                            SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
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
                                    !showComment ? "ثبت امتیاز" : "فایل های مشاور",
                                    style: TextStyle(
                                      color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                                      fontFamily: "IranSansBold",
                                      fontSize: 9,
                                    ),
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
          if (showSearchBarWidget) searchBar(consultantInfo.estateName ?? ""),
          if (showComment) addCommentWidget(),
          if (!showComment) Expanded(child: BlocBuilder<ConsultantFilesBloc, FilesState>(builder: _buildFilesBloc)),
        ],
      ),
    );
  }

  Widget _buildFilesBloc(BuildContext context, FilesState state) {
    if (state is FilesInitState) return Container();

    if (state is FilesLoadingState) return Center(child: Loading());

    if (state is FilesErrorState) {
      return Center(
        child: TryAgain(
          onPressed: getFiles,
          message: state.response != null ? jDecode(state.response!.body)['message'] : null,
        ),
      );
    }

    state = state as FilesLoadedState;
    files = state.files;

    return MyListView(
      isEmpty: !files.isFill(),
      emptyText: "این مشاور فایلی ندارد",
      listView: ListView.builder(
        itemCount: files.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) return SizedBox(height: 5);
          return Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: GestureDetector(
              onTap: () => push(context, FileScreen(id: files[i - 1].id!)),
              child: FileHorizontalItem(file: files[i - 1]),
            ),
          );
        },
      ),
    );
  }

  goToFiles({String? appBarTitle, Category? category, FilterData? filterData}) async {
    return push(
      context,
      ConsultantFilesScreen(
        filterData: filterData ??
            FilterData(
              category: category,
              consultantId: widget.consultantId,
            ),
        appBarTitle: appBarTitle,
      ),
    );
  }

  getFiles() {
    if (filesBloc.isClosed) {
      filesBloc = ConsultantFilesBloc();
    }
    filesBloc.add(
      FilesLoadEvent(filterData: filterData),
    );
  }
}
