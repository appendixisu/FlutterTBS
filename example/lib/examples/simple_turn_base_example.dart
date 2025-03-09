import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertbs/fluttertbs.dart';

/// This example demonstrates how to implement a turn-based system
/// that waits for player actions before progressing to the next turn.
class SimpleTurnBaseExample extends StatefulWidget {
  const SimpleTurnBaseExample({super.key});

  @override
  State<SimpleTurnBaseExample> createState() => _SimpleTurnBaseExampleState();
}

class _SimpleTurnBaseExampleState extends State<SimpleTurnBaseExample> {
  bool isPlayerTurn = false;

  late final SimpleUserPlayer userPlayer = SimpleUserPlayer(onTurn);
  late final FakeAiPlayer aiPlayer = FakeAiPlayer(aiOnTurn);
  late final TurnBaseSystem turnBaseSystem = BaseTurnBaseSystem()..setPlayers([userPlayer, aiPlayer]);
  final ScrollController scrollController = ScrollController();

  List<String> historyEvents = [];
  int turnCounter = 0;


  @override
  void initState() {
    super.initState();
    turnBaseSystem.start();
  }


  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onTurn() {
    setState(() {
      turnCounter++;
      historyEvents.add('turn: $turnCounter');
      historyEvents.add('Player onTurn');
      isPlayerTurn = true;
    });
    scrollToBottom();
  }

  FutureOr<void> aiOnTurn() async {
    setState(() {
      historyEvents.add('AI onTurn');
      print('AI 開始動作');
    });
    scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      historyEvents.add('AI start action');
    });
    scrollToBottom();

    print('AI 結束回合');
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      historyEvents.add('AI endTurn');
      historyEvents.add('');
    });
    scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 1000));
  }


  void endTurn() {
    setState(() {
      historyEvents.add('Player endTurn');
      historyEvents.add('');
      isPlayerTurn = false;
      userPlayer.endTurn();
    });
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final double maxScrollExtent = scrollController.position.maxScrollExtent;
      scrollController.animateTo(
        maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Flexible(
            child: SizedBox(
              width: 500,
              height: 300,
              child: ListView(
                controller: scrollController,
                children: historyEvents.map((history) => Text(history)).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: isPlayerTurn ? endTurn : null,
            child: const Text('EndTurn'),
          ),
        ],
      ),
    );
  }

}


class FakeAiPlayer extends BasePlayer {
  TaskCallback delegateOnTurn;

  FakeAiPlayer(this.delegateOnTurn);

  @override
  Future<void> onTurn() async {
    await delegateOnTurn();
  }
}

class SimpleUserPlayer extends UserPlayer {

  TaskCallback delegateOnTurn;

  SimpleUserPlayer(this.delegateOnTurn);

  @override
  Future<void> onTurn() async {
    final future = super.onTurn();
    await delegateOnTurn();
    return future;
  }
}
