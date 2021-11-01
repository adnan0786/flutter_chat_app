import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';

class SoundRecording {
  FlutterSoundRecorder? _audioRecording;
  FlutterSoundPlayer? soundPlayer;


  get isPlaying => soundPlayer?.isPlaying;

  Future init() async {
    _audioRecording = FlutterSoundRecorder();
    soundPlayer = FlutterSoundPlayer();
    await soundPlayer?.openAudioSession();
    await _audioRecording?.openAudioSession();
  }

  void destroy() {
    _audioRecording?.closeAudioSession();
    _audioRecording = null;
  }

  void destroyPlayer() {
    soundPlayer?.closeAudioSession();
    soundPlayer = null;
  }

  Future stopRecording() async {
    await _audioRecording?.stopRecorder();
  }

  Future startRecording(String path) async {
    await _audioRecording?.startRecorder(toFile: path);
  }

  Future<Duration?> startPlayer(String path) async {
    if (isPlaying != null && isPlaying == true) {
      await soundPlayer?.stopPlayer();
      return _playAudio(path);
    } else
      return _playAudio(path);
  }

  Future<Duration?> _playAudio(String path) async {
    return soundPlayer?.startPlayer(fromURI: path);
  }

  Future stopPlayer() async {
    await soundPlayer?.stopPlayer();
  }
}
