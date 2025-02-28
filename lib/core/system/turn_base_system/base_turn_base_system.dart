import 'dart:collection';

import 'package:fluttertbs/core/entities/players/base_player.dart';
import 'package:fluttertbs/core/entities/players/user_player.dart';
import 'package:fluttertbs/core/system/turn_base_system/turn_base_system.dart';

class BaseTurnBaseSystem implements TurnBaseSystem {

  Queue<BasePlayer> _players = Queue();

  @override
  List<BasePlayer> get players => List.unmodifiable(_players);

  @override
  BasePlayer? get currentPlayer => players.firstOrNull;

  @override
  void rotate() {
    if(_players.isEmpty) {
      return;
    }

    final BasePlayer endTurnPlayer = _players.removeFirst();
    _players.addLast(endTurnPlayer);
  }

  @override
  Future<void> start() async {

    while(gameIsNotFinished()) {
      print('---- ${currentPlayer.runtimeType} 的回合開始 ---');
      await currentPlayer?.onTurn();
      print('---- ${currentPlayer.runtimeType} 的回合結束 ---');
      print('\n');
      rotate();
    }

    if(currentPlayer case UserPlayer _) {
      print('GameWin');
    }
    else {
      print('GameOver');
    }

  }

  bool gameIsNotFinished() {
    if(_players.length <= 1) {
      return false;
    }

    /// or user player not in players
    if(_players.whereType<UserPlayer>().firstOrNull == null) {
      return false;
    }


    return true;
  }

  @override
  void removePlayer(BasePlayer player) {
    _players.remove(player);
  }

  @override
  void setPlayers(List<BasePlayer> players) {
    _players = Queue()..addAll(players);
  }

}