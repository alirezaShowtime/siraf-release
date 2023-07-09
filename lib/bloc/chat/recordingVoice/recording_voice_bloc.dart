import 'package:flutter_bloc/flutter_bloc.dart';

class RecordingVoiceEvent {
  RecordingVoiceState recordingVoice;

  RecordingVoiceEvent(this.recordingVoice);
}

enum RecordingVoiceState { Recording, Done, Cancel, Init }

class RecordingVoiceBloc extends Bloc<RecordingVoiceEvent, RecordingVoiceState> {
  RecordingVoiceBloc() : super(RecordingVoiceState.Init) {
    on<RecordingVoiceEvent>((event, emit) => emit(event.recordingVoice));
  }
}
