import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/widgets/pagination_error.dart';
import 'package:siraf3/widgets/pagination_loading.dart';

abstract class InitialState {}

abstract class LoadingState {}

abstract class SuccessState {
  int? getLastId();

  List getList();
}

abstract class ErrorState {}

class ListViewPagination<T> extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListViewPagination<T>();

  List<T> list;
  int? itemCount;
  int? lastId;
  void Function(int) canMore;
  Bloc moreBlocOnClosed;
  Widget Function(T)? widget;
  Widget Function(BuildContext context, int i)? itemBuilder;
  Bloc moreBloc;

  ListViewPagination({
    required this.lastId,
    required this.canMore,
    required this.moreBlocOnClosed,
    required this.moreBloc,
    required this.list,
    this.itemCount,
    this.widget,
    this.itemBuilder,
  });
}

class _ListViewPagination<T> extends State<ListViewPagination<T>> {
  ScrollController scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasError = false;
  int? lastId;

  @override
  void initState() {
    super.initState();

    lastId = widget.lastId;

    scrollController.addListener(pagination);

    widget.moreBloc.stream.listen((state) {
      try {
        setState(() => _isLoadingMore = state is LoadingState);
      } catch (e) {
        _isLoadingMore = state is LoadingState;
      }

      _hasError = state is ErrorState;

      if (state is SuccessState) {
        lastId = state.getLastId();
        widget.list.addAll(state.getList() as List<T>);
      }
    });
  }

  bool _canLoadMore() {
    return (scrollController.position.pixels == scrollController.position.maxScrollExtent) && lastId != null && !_isLoadingMore;
  }

  void pagination() async {
    if (!_canLoadMore()) return;
    if (widget.moreBloc.isClosed) {
      widget.moreBloc = widget.moreBlocOnClosed;
    }
    widget.canMore.call(lastId!);
  }

  @override
  Widget build(BuildContext context) {
    var itemCount = widget.itemCount != null ? widget.itemCount! + 1 : widget.list.length + 1;

    return ListView.builder(
      physics: ClampingScrollPhysics(),
      controller: scrollController,
      itemCount: itemCount,
      itemBuilder: (context, i) {
        if (itemCount - 1 == i && _isLoadingMore) {
          return PaginationLoading();
        }

        if (itemCount - 1 == i && _hasError) {
          return PaginationError(
            onClickTryAgain: () => widget.canMore.call(lastId!),
          );
        }

        if (widget.itemBuilder != null) {
          return widget.itemBuilder!.call(context, i);
        } else {
          return widget.widget!.call(widget.list[i]);
        }
      },
    );
  }
}
