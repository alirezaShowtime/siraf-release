part of 'consultant_profile_screen.dart';

extension Profile on _ConsultantProfileScreen {
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
                    Avatar(
                        size: 80,
                        imagePath: consultantInfo.avatar,
                        errorWidget: _profileWidget()),
                    Container(
                      padding: const EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: Colors.grey.shade200, width: 1))),
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
                              card(
                                  title: "فروشی",
                                  value: consultantInfo.countOnSale.toString(),
                                  onTap: () {}),
                              card(
                                  title: "اجاره ای",
                                  value: consultantInfo.countRent.toString(),
                                  onTap: () {}),
                              card(
                                  title: "ساخت و ساز",
                                  value: consultantInfo.countConstruction
                                      .toString(),
                                  onTap: () {}),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              consultantInfo.bio ?? "",
                              maxLines: 2,
                              style: TextStyle(
                                  color: Themes.textGrey, fontSize: 11),
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
                                    final bool previousValueOfMoreDetail =
                                        moreDetail;
                                    showComment = !showComment;

                                    viewMoreDetail(force: false);

                                    if (!previousValueOfMoreDetail &&
                                        !showComment) {
                                      showSearchBarWidget = true;
                                    }

                                    if (!previousValueOfMoreDetail &&
                                        showComment) {
                                      showSearchBarWidget = false;
                                    }
                                  }),
                                  child: Text(
                                    !showComment
                                        ? "نمایش نظرات (${consultantInfo.comment?.length ?? 0})"
                                        : "فایل های مشاور",
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
          // SizeTransition(
          //   sizeFactor: collapseAnimation,
          //   axis: Axis.vertical,
          //   child: profileDetail(),
          // ),
          if (showSearchBarWidget) searchBar(),
          if (showComment)
            //todo: show list-is-empty image, if don`s exists comments
            Expanded(
              child: ListView.builder(
                itemCount: (consultantInfo.comment?.length ?? 0) + 1,
                itemBuilder: (context, i) {
                  if (i == 0)
                    return addCommentWidget(consultantId: consultantInfo.id!);
                  return commentItem(consultantInfo.comment![i - 1]);
                },
              ),
            ),
          if (!showComment)
            //todo: show list-is-empty image, if don`s exists comments
            //todo: the endpoint to get file list of consultant is isolate
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: list.length,
            //     itemBuilder: (context, i) => fileItem(list[i]),
            //   ),
            // ),

            Expanded(
                child: BlocBuilder<FilesBloc, FilesState>(
              builder: _buildFilesBloc,
            )),
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
          message: state.response != null
              ? jDecode(state.response!.body)['message']
              : null,
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
