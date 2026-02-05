import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/werewolve.dart';

class LonelyWolf extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "description.lonely_wolf";

  @override
  String name = "role.lonely_wolf";

  @override
  String group = "lonely_wolf";

  @override
  GameTime nightActionTime = GameTime.withWerewolves;

  @override
  int difficultyIndex = -5;

  @override
  bool checkWin(GameController game, Player p) {
    return game.alivePlayers.length == 1 && game.alivePlayers.first == p;
  }

  @override
  Future<void> onNightAction(GameController game, Player p) async {
    if (game.alivePlayers
        .where((p2) => p2.role.name == "role.werewolve")
        .isEmpty) {
      Werewolve().onNightAction(game, p);
    }
  }

  @override
  String toString() {
    if (description == "") {
      return name;
    }
    return "$name: $description";
  }

  @override
  int maxPlayers = 1;
}
