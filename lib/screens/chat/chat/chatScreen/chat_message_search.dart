part of 'chat_screen.dart';

extension ChatMessageSearch on _ChatScreen {
  Widget searchControllerWidget() {
    return Container(
      width: double.infinity,
      height: 60,
      padding: EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 0.7)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, -3),
            spreadRadius: -3,
            blurRadius: 1,
            color: Colors.black12,
          ),
        ],
      ),
      child: StatefulBuilder(builder: (context, setState) {
        return BlocConsumer(
          bloc: chatMessageSearchBloc,
          listener: (context, state) {
            if (state is ChatMessageSearchSuccess && state.countSearch != null) {
              countSearch = state.countSearch!;

              if (currentFoundedIndex == null) {
                currentFoundedIndex = foundMessageWidgetIndexes.currentIndex + 1;
              }
            }
          },
          builder: (context, state) {
            var text = "";
            if (state is ChatMessageSearchLoading) {
              text = "درحال یافتن...";
            }

            if (state is ChatMessageSearchError) {
              text = "خطا";
            }

            if (state is ChatMessageSearchSuccess && countSearch == 0) {
              text = "0 از 0";
            }
            if (state is ChatMessageSearchSuccess && countSearch > 0) {
              text = "$currentFoundedIndex از ${countSearch}";
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    MyIconButton(
                      onTap: () => nextSearched(setState),
                      iconColor: App.theme.primaryColor,
                      disable: currentFoundedIndex == null || currentFoundedIndex! >= countSearch,
                      iconData: Icons.keyboard_arrow_up_rounded,
                    ),
                    MyIconButton(
                      onTap: () => previousSearched(setState),
                      iconColor: App.theme.primaryColor,
                      disable: currentFoundedIndex == null || currentFoundedIndex! <= 1,
                      iconData: Icons.keyboard_arrow_down_rounded,
                    ),
                  ],
                ),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "IranSansBold",
                    color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  void previousSearched(var setState) {
    if (foundMessageWidgetIndexes.hasPrevious()) {
      scrollToIndex(foundMessageWidgetIndexes.previous().key, true);
      currentFoundedIndex = currentFoundedIndex! - 1;
      setState(() {});
    } else if (currentFoundedIndex != null && currentFoundedIndex! > 0) {
      chatMessageSearchBloc.add(ChatMessageSearchRequestEvent(
        chatId: widget.chatId,
        lastId: foundMessageWidgetIndexes.current.value,
        type: MessageSearchType.Previous,
      ));
      currentFoundedIndex = currentFoundedIndex! - 1;
      setState(() {});
    }
  }

  void nextSearched(var setState) {
    if (foundMessageWidgetIndexes.hasNext()) {
      scrollToIndex(foundMessageWidgetIndexes.next().key, true);
      currentFoundedIndex = currentFoundedIndex! + 1;
      setState(() {});
    } else if (currentFoundedIndex != null && currentFoundedIndex! < countSearch) {
      chatMessageSearchBloc.add(ChatMessageSearchRequestEvent(
        chatId: widget.chatId,
        lastId: foundMessageWidgetIndexes.current.value,
        type: MessageSearchType.Next,
      ));
      currentFoundedIndex = currentFoundedIndex! + 1;
      setState(() {});
    }
  }
}
