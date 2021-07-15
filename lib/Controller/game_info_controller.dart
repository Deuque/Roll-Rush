
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final gameInfoProvider = ChangeNotifierProvider<GameInfo>((
    ref) => new GameInfo());

class GameInfo extends ChangeNotifier {
  bool firstPlay = true;
  int bestScore=0;
  int score=0;
  int level = 1;
  int lives = 0;
  bool newHighScore = false;
  bool speakerOn = true;
  bool seenRewardAds = false;


  void initGameValues() async {
    bestScore = await getGameValue('bestScore', 0);
    speakerOn = await getGameValue('speakerOn', true );
    lives = await getGameValue('lives', 0 );
    notifyListeners();
  }

  void incrementScore(int amount){
    score=score+amount;
    notifyListeners();
  }

  void decrementScore(int amount){
    score=score-amount;
    if(score<0)score=0;
    notifyListeners();
  }

  void incrementLives(){
    lives = lives + 1;
    notifyListeners();
    saveGameValue('lives', lives);
  }

  void decrementLives(){
    lives = lives - 1;
    notifyListeners();
    saveGameValue('lives', lives);
  }

  void incrementLevel(){
    level=level+1;
    notifyListeners();
  }

  void gameStarted(){
    score = 0;
    newHighScore = false;
    seenRewardAds = false;
    notifyListeners();
  }

  void gameEnded(){
    newHighScore = score > bestScore;
    if(firstPlay)firstPlay = false;
    notifyListeners();
    if(newHighScore)setBestScore();
  }

  void toggleSpeaker(){
    speakerOn = !speakerOn;
    notifyListeners();
    saveGameValue('speakerOn', speakerOn);
  }

  void toggleSeenRewardAds(){
    seenRewardAds = true;
    notifyListeners();
  }

  void setBestScore(){
    bestScore = score;
    notifyListeners();
    saveGameValue('bestScore', bestScore);
  }

  saveGameValue(String key, dynamic value)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    value is bool ? prefs.setBool(key, value) : value is String ? prefs.setString(key, value) : prefs.setInt(key, value);
  }

  getGameValue(String key, dynamic defValue)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(key)??defValue;
  }


}