import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SirenAudioService {
  static final SirenAudioService _instance = SirenAudioService._internal();
  factory SirenAudioService() => _instance;
  SirenAudioService._internal();

  AudioPlayer? _player;
  Timer? _hapticTimer;
  bool _isPlaying = false;
  bool _useFallback = false;

  bool get isPlaying => _isPlaying;
  bool get isUsingFallback => _useFallback;

  AudioPlayer get _audioPlayer {
    _player ??= AudioPlayer();
    return _player!;
  }

  Future<void> startSiren() async {
    if (_isPlaying) return;
    _isPlaying = true;

    // Start physical tactical vibration pulse synchronized with siren rhythm
    _hapticTimer?.cancel();
    _hapticTimer = Timer.periodic(const Duration(milliseconds: 750), (_) {
      if (_isPlaying) {
        HapticFeedback.heavyImpact();
      }
    });

    try {
      final player = _audioPlayer;
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(1.0);
      await player.play(AssetSource('audio/emergency_siren.wav'));
      _useFallback = false;
    } catch (e) {
      debugPrint('SirenAudioService: Native AudioPlayer unavailable, using audio/haptic alert fallback ($e)');
      _useFallback = true;
      // Immediate system alert chime
      SystemSound.play(SystemSoundType.alert);
    }
  }

  Future<void> stopSiren() async {
    _isPlaying = false;
    _hapticTimer?.cancel();
    _hapticTimer = null;

    try {
      if (_player != null) {
        await _player!.stop();
      }
    } catch (e) {
      debugPrint('SirenAudioService: Error stopping AudioPlayer: $e');
    }
  }

  void dispose() {
    stopSiren();
    _player?.dispose();
    _player = null;
  }
}
