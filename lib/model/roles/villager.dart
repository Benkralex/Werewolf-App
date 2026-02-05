import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';

class Villager extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "description.villager";

  @override
  String name = "role.villager";

  @override
  String group = "villager";

  @override
  GameTime nightActionTime = GameTime.sunrise;

  @override
  int difficultyIndex = 1;

  @override
  bool checkWin(GameController game, Player p) {
    for (Player p2 in game.alivePlayers) {
      if (p2.role.group != "villager" && p2.role.group != "gerber") {
        return false;
      }
    }
    return true;
  }

  @override
  String toString() {
    if (description == "") {
      return name;
    }
    return "$name: $description";
  }

  @override
  int maxPlayers = 20;
}
