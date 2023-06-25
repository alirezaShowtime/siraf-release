import 'package:dio/dio.dart' as dio;
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RequestBloc<T, E> extends Bloc<T, E> {
  List<dio.CancelToken> cancelTokens = [];

  RequestBloc(super.initialState);

  @override
  Future<void> close() {
    cancelTokens.forEach((cancelToken) => cancelToken.cancel());
    return super.close();
  }
}
