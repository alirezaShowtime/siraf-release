import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class VoiceMessagePlayEvent {}

class VoiceMessagePlayRegisterPlayerEvent extends VoiceMessagePlayEvent {
  AudioPlayer player;

  VoiceMessagePlayRegisterPlayerEvent(this.player);
}

class VoiceMessagePlayPlayOrStop extends VoiceMessagePlayEvent {
  AudioPlayer player;

  VoiceMessagePlayPlayOrStop(this.player);
}

class VoiceMessagePlayState {
  PlayerState playerState;
  String? playerId;

  VoiceMessagePlayState(this.playerState, this.playerId);
}

class VoiceMessagePlayBloc extends Bloc<VoiceMessagePlayEvent, VoiceMessagePlayState?> {
  List<AudioPlayer> players = [];

  VoiceMessagePlayBloc() : super(null) {
    on<VoiceMessagePlayRegisterPlayerEvent>(_register);
    on<VoiceMessagePlayPlayOrStop>(_playOrStop);
  }

  @override
  Future<void> close() {
    players.clear();
    return super.close();
  }

  FutureOr<void> _register(VoiceMessagePlayRegisterPlayerEvent event, Emitter<VoiceMessagePlayState?> emit) {
    if (!players.contains(event.player)) {
      players.add(event.player);
    }
  }

  FutureOr<void> _playOrStop(VoiceMessagePlayPlayOrStop event, Emitter<VoiceMessagePlayState?> emit) async {
    if (event.player.state == PlayerState.playing) {
      event.player.pause();
      event.player.state = PlayerState.paused;
      return emit(VoiceMessagePlayState(PlayerState.paused, event.player.playerId));
    }

    for (AudioPlayer player in players) {
      if (player.state == PlayerState.playing && player.playerId != event.player.playerId) {
        // var source = player.source;
        player.pause();
        // if (source != null) {
        //   player.setSource(source);
        // }
        emit(VoiceMessagePlayState(PlayerState.stopped, player.playerId));
        break;
      }
    }

    event.player.resume();
    event.player.state = PlayerState.playing;
    emit(VoiceMessagePlayState(PlayerState.playing, event.player.playerId));
  }
}
