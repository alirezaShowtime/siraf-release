import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siraf3/extensions/file_extension.dart';
import 'package:video_compressor/video_compressor.dart';

class CompressorEvent {
  List<File> images;
  List<File> videos;

  CompressorEvent({required this.images, required this.videos});
}

class CompressorState {}

class CompressorInitState extends CompressorState {}

class CompressorLoadingState extends CompressorState {}

class CompressorSuccessState extends CompressorState {
  List<File> images;
  List<File> videos;

  CompressorSuccessState({required this.images, required this.videos});
}

class CompressorFailState extends CompressorState {}

class CompressorBloc extends Bloc<CompressorEvent, CompressorState> {
  CompressorBloc() : super(CompressorInitState()) {
    on(_onEvent);
  }

  _onEvent(CompressorEvent event, Emitter<CompressorState> emit) async {
    emit(CompressorLoadingState());

    var newImages = <File>[];

    try {
      for (File image in event.images) {
        var targetPath = (await getTemporaryDirectory()).path + ((await getTemporaryDirectory()).path.endsWith('/') ? '' : '/') + image.fileName;
        var xfile = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path,
          targetPath,
          quality: 88,
        );
        if (xfile == null) {
          newImages.add(image);
        } else {
          newImages.add(File(xfile.path));
        }
      }
    } catch (CompressError) {}

    var newVideos = <File>[];

    for (File video in event.videos) {
      MediaInfo? mediaInfo = await VideoCompressor.compressVideo(
        video.path,
        quality: VideoQuality.NormalResQuality,
        deleteOrigin: false,
      );

      if (mediaInfo == null) {
        newVideos.add(video);
      } else {
        newVideos.add(mediaInfo.file!);
      }
    }

    emit(CompressorSuccessState(images: newImages, videos: newVideos));
  }
}
