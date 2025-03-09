import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertbs/fluttertbs.dart';


class FakeAiPlayer extends BasePlayer {
  @override
  Future<void> onTurn() async {
    print('AI 開始動作');
    await Future.delayed(Duration(milliseconds: 1000));

    print('AI 結束回合');
    await Future.delayed(Duration(milliseconds: 1000));
  }
}

class FakeUserPlayer extends UserPlayer {

  TaskCallback? testOtherAction;

  @override
  Future<void> onTurn() async {
    final future = super.onTurn();
    await testOtherAction?.call();
    return future;
  }

}


void main() {

  Future<void> playerTestDoingSomething(UserPlayer player) async {

    print('玩家開始動作');
    await Future.delayed(Duration(milliseconds: 1000));

    print('玩家進行移動');
    await Future.delayed(Duration(milliseconds: 1000));

    print('玩家結束行動');
    await Future.delayed(Duration(milliseconds: 1000));
  }

  test('Test BaseTurnBaseSystem game loop, kill aiPlayer action', () async {

    int turnCounter = 0;
    final FakeAiPlayer aiPlayer = FakeAiPlayer();
    final FakeUserPlayer userPlayer = FakeUserPlayer();

    TurnBaseSystem turnBaseSystem = BaseTurnBaseSystem()..setPlayers([userPlayer, aiPlayer]);

    userPlayer.testOtherAction = () async {
      turnCounter++;
      await playerTestDoingSomething.call(userPlayer);

      if(turnCounter == 3) {
        print('玩家殺死了 aiPlayer');
        turnBaseSystem.removePlayer(aiPlayer);
      }
      userPlayer.endTurn();
    };

    await turnBaseSystem.start();
    expect(turnBaseSystem.players.length, 1);
    expect(turnBaseSystem.currentPlayer, userPlayer);
  });

  test('Test BaseTurnBaseSystem game over', () async {

    int turnCounter = 0;
    final FakeAiPlayer aiPlayer = FakeAiPlayer();
    final FakeUserPlayer userPlayer = FakeUserPlayer();

    TurnBaseSystem turnBaseSystem = BaseTurnBaseSystem()..setPlayers([userPlayer, aiPlayer]);

    userPlayer.testOtherAction = () async {
      turnCounter++;
      await playerTestDoingSomething.call(userPlayer);

      if(turnCounter == 3) {
        print('玩家自殺了');
        turnBaseSystem.removePlayer(userPlayer);
      }
      userPlayer.endTurn();
    };

    await turnBaseSystem.start();
    expect(turnBaseSystem.players.length, 1);
    expect(turnBaseSystem.currentPlayer, aiPlayer);
  });
}