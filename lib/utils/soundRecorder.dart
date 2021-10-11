import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';

class SoundRecording {
  FlutterSoundRecorder? _audioRecording;
  AudioPlayer? player;

  Future init() async {
    _audioRecording = FlutterSoundRecorder();
    player = AudioPlayer();
  }

  Future stop() async {
    await _audioRecording?.closeAudioSession();
    await _audioRecording?.stopRecorder();
  }

  Future start(String path) async {
    await player?.setAsset("assets/audio/recording_start.wav");
    await _audioRecording?.openAudioSession();
    await _audioRecording?.startRecorder(toFile: path);
  }
}
