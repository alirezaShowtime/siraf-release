import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/category.dart';
import 'package:http/http.dart' as http;

class CategoriesEvent {}

class CategoriesFetchEvent extends CategoriesEvent {}

class CategoriesWithDataEvent extends CategoriesEvent {
  List<Category> categories;

  CategoriesWithDataEvent({required this.categories});
}

class CategoriesBlocState {}

class CategoriesBlocInitial extends CategoriesBlocState {}

class CategoriesBlocLoading extends CategoriesBlocState {}

class CategoriesBlocLoaded extends CategoriesBlocState {
  List<Category> categories;

  CategoriesBlocLoaded({required this.categories});
}

class CategoriesBlocError extends CategoriesBlocState {
  http.Response response;

  CategoriesBlocError({required this.response});
}

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesBlocState> {
  CategoriesBloc() : super(CategoriesBlocInitial()) {
    on(_onEvent);
  }

  void _onEvent(CategoriesEvent event, emit) async {
    if (event is CategoriesWithDataEvent) {
      emit(CategoriesBlocLoaded(categories: event.categories));
    } else if (event is CategoriesFetchEvent) {
      emit(CategoriesBlocLoading());

      var response = await http.get(getFileUrl("category/categorys"));
      var resJson = jDecode(response.body);
      if (response.statusCode == 200) {
        emit(CategoriesBlocLoaded(
            categories: Category.fromList(resJson['data'])));
      } else {
        emit(CategoriesBlocError(response: response));
      }
    }
  }
}
