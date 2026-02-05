import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/werewolve.dart';

class WerewolveKid extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "";

  @override
  String name = "role.werewolve_kid";

  @override
  String group = "werewolve";

  @override
  GameTime nightActionTime = GameTime.withWerewolves;

  @override
  int difficultyIndex = -8;

  @override
  bool checkWin(GameController game, Player p) {
    return Werewolve().checkWin(game, p);
  }

  @override
  Future<void> onNightAction(GameController game, Player p) async {
    if (game.alivePlayers
        .where(
          (p2) =>
              p2.role.name == "role.werewolve" ||
              p2.role.name == "role.lonely_wolf",
        )
        .isEmpty) {
      Werewolve().onNightAction(game, p);
    }
  }

  @override
  Future<void> onDeath(GameController game, Player p) async {
    Werewolve().editPropertyForEveryWerewolve(
      game,
      "property.next_night_victim_count",
      2,
    );
  }

  @override
  Future<void> onLynch(GameController game, Player p) async {
    await onDeath(game, p);
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
