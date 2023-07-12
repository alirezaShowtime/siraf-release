part of 'consultant_profile_screen.dart';

extension Profile on _ConsultantProfileScreen {
  Widget profile(ConsultantInfo consultantInfo) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Container(
            height: 160,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: !(moreDetail || showComment) ? null : Border(bottom: BorderSide(width: 1, color: Colors.grey.shade200)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Avatar(size: 80, imagePath: consultantInfo.avatar, errorWidget: _profileWidget()),
                    SizedBox(height: 20),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          card(title: "فروشی", value: consultantInfo.countOnSale.toString()),
                          card(title: "اجاره ای", value: consultantInfo.countRent.toString()),
                          card(title: "ساخت و ساز", value: consultantInfo.countConstruction.toString()),
                        ],
                      ),
                      // SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            consultantInfo.bio ?? "",
                            maxLines: 2,
                            style: TextStyle(color: Themes.textGrey, fontSize: 11),
                          ),
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
                                  !showComment ? "نمایش نظرات (${comments.length})" : "فایل های مشاور",
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
              ],
            ),
          ),
          if (showSearchBarWidget) searchBar(),
          if (showComment)
            Expanded(
              child: ListView.builder(
                itemCount: comments.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0)
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: addCommentWidget(),
                    );
                  return CommentItemWidget(
                    comment: comments[i - 1],
                    consultantId: widget.consultantId,
                  );
                },
              ),
            ),
          if (!showComment)
            Expanded(
              child: BlocConsumer<FilesBloc, FilesState>(
                builder: _buildFilesBloc,
                listener: (_, state) {
                  if (state is FilesLoadedState) {
                    files = state.files;
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilesBloc(BuildContext context, FilesState state) {
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

    state = state as FilesLoadedState;

    return MyListView(
      isEmpty: !files.isFill(),
      emptyText: "این مشاور فایلی ندارد",
      listView: ListView.builder(
        itemCount: files.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) return SizedBox(height: 10);
          return GestureDetector(
            onTap: () => push(context, FileScreen(id: files[i - 1].id!)),
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
      FilesLoadEvent(filterData: filterData),
    );
  }
}
