import 'package:werewolf_app/model/game/game_controller.dart';
import 'package:werewolf_app/model/game/game_time.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/model/player/role.dart';

class Gerber extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "";

  @override
  String group = "gerber";

  @override
  String name = "role.gerber";

  @override
  GameTime nightActionTime = GameTime.sunrise;

  bool hasWon = false;

  @override
  bool checkWin(GameController game, Player p) {
    return hasWon;
  }

  @override
  Future<void> onDeath(GameController game, Player p) async {
    hasWon = true;
  }

  @override
  int maxPlayers = 1;
}
