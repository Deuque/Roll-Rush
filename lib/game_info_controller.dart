import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final gameInfoProvider = ChangeNotifierProvider<GameInfo>((
    ref) => new GameInfo());

class GameInfo extends ChangeNotifier {
  bool firstPlay = true;
  int previousScore=0;
  int score=0;
  bool newHighScore = false;


  void initGameValues() async {
    previousScore = await getGameValue('previousScore', 0);
    notifyListeners();
  }

  void incrementScore(){
    score=score+1;
    notifyListeners();
  }

  void gameStarted(){
    score = 0;
    newHighScore = false;
    notifyListeners();
  }

  void gameEnded(){
    newHighScore = score > previousScore;
    if(firstPlay)firstPlay = false;
    notifyListeners();
    setPreviousScore();
  }

  void setPreviousScore(){
    previousScore = score;
    notifyListeners();
    saveGameValue('previousScore', previousScore);
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