import 'package:fluttertbs/core/entities/players/base_player.dart';

abstract class TurnBaseSystem {
  List<BasePlayer> get players;
  BasePlayer? get currentPlayer;

  Future<void> start();

  void rotate();

  void removePlayer(BasePlayer player);

  void setPlayers(List<BasePlayer> players);
}