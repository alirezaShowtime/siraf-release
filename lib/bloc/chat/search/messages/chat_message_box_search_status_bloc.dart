import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessageBoxSearchStatusBloc extends Bloc<bool, bool> {
  ChatMessageBoxSearchStatusBloc() : super(false) {
    on<bool>((bool event, emit) => emit(event));
  }
}
