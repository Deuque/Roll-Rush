import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:roll_rush/game_info_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

void playSound(String path,BuildContext context){
  if(!context.read(gameInfoProvider).speakerOn ) return;
  final player = AudioCache();
  player.play(path, mode: PlayerMode.LOW_LATENCY, stayAwake: false);
}