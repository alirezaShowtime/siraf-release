part of 'chat_screen.dart';

extension VoiceRecorder on _ChatScreen {
  Future<void> startRecording() async {
    print("status record start");
    if (await recordPermissionsRequest()) {
      Directory appFolder = await getTemporaryDirectory();
      bool appFolderExists = await appFolder.exists();
      if (!appFolderExists) {
        await appFolder.create(recursive: true);
      }

      final filepath = appFolder.path + '/' + DateTime.now().millisecondsSinceEpoch.toString() + ".mp3";

      await _audioRecorder.start(path: filepath);
      print(await _audioRecorder.isRecording());
    } else {
      print('Permissions not granted');
    }
  }

  Future<String?> stopRecording() async {
    if (!await _audioRecorder.isRecording()) return null;
    print("status record stop");
    String? path = await _audioRecorder.stop();
    _audioRecorder.dispose();

    return path;
  }

  Future<void> cancelRecording() async {
    print("status record cancel");
    try {
      if (await _audioRecorder.isRecording()) {
        String? path = await _audioRecorder.stop();

        await File(path!).delete();
      }
    } catch (e) {}
  }
}

Future<bool> recordPermissionsRequest() async {
  Map<Permission, PermissionStatus> permissions = await [
    Permission.storage,
    Permission.microphone,
  ].request();

  return permissions[Permission.storage]!.isGranted && permissions[Permission.microphone]!.isGranted;
}
