import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertbs/core/entities/players/base_player.dart';
import 'package:fluttertbs/core/entities/players/user_player.dart';
import 'package:fluttertbs/core/system/turn_base_system/base_turn_base_system.dart';
import 'package:fluttertbs/core/system/turn_base_system/turn_base_system.dart';


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

  void Function()? testOtherAction;

  @override
  Future<void> onTurn() async {
    await super.onTurn();
    await testDoingSomething();
    super.endTurn();
  }

  Future<void> testDoingSomething() async {

    print('玩家開始動作');
    await Future.delayed(Duration(milliseconds: 1000));

    print('玩家進行移動');
    await Future.delayed(Duration(milliseconds: 1000));

    print('玩家結束行動');
    await Future.delayed(Duration(milliseconds: 1000));

    testOtherAction?.call();
  }

}


void main() {
  test('Test BaseTurnBaseSystem game loop, kill aiPlayer action', () async {

    int turnCounter = 0;
    final FakeAiPlayer aiPlayer = FakeAiPlayer();
    final FakeUserPlayer userPlayer = FakeUserPlayer();

    TurnBaseSystem turnBaseSystem = BaseTurnBaseSystem()..setPlayers([userPlayer, aiPlayer]);

    userPlayer.testOtherAction = () {
      turnCounter++;
      if(turnCounter == 3) {
        print('玩家殺死了 aiPlayer');
        turnBaseSystem.removePlayer(aiPlayer);
      }
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

    userPlayer.testOtherAction = () {
      turnCounter++;
      if(turnCounter == 3) {
        print('玩家自殺了');
        turnBaseSystem.removePlayer(userPlayer);
      }
    };

    await turnBaseSystem.start();
    expect(turnBaseSystem.players.length, 1);
    expect(turnBaseSystem.currentPlayer, aiPlayer);
  });
}