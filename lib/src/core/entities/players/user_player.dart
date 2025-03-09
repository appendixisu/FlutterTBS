import 'dart:async';

import 'base_player.dart';


class UserPlayer extends BasePlayer {

  Completer<void>? turnCompleter;

  @override
  Future<void> onTurn() async {
    assert(turnCompleter == null, '請確保在回合結束時清空 completer');
    turnCompleter = Completer();
    return turnCompleter?.future;
  }

  void endTurn() {
    turnCompleter?.complete();
    turnCompleter = null;
  }

}