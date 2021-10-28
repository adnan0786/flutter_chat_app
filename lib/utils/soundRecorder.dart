import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';

class SoundRecording {
  FlutterSoundRecorder? _audioRecording;
  FlutterSoundPlayer? soundPlayer;
  AudioPlayer? player;

  Future init() async {
    _audioRecording = FlutterSoundRecorder();
    soundPlayer = FlutterSoundPlayer();
    await _audioRecording?.openAudioSession();
    player = AudioPlayer();
  }

  void destroy() {
    _audioRecording?.closeAudioSession();
    _audioRecording = null;
  }

  Future stop() async {
    await _audioRecording?.stopRecorder();
  }

  Future start(String path) async {
    await player?.setAsset("assets/audio/recording_start.wav");
    await _audioRecording?.startRecorder(toFile: path);
  }

  Future startPlayer(String path) async {
    await soundPlayer?.startPlayer(
      fromURI: path,
    );
  }
}
