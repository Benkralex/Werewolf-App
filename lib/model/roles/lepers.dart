import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/werewolve.dart';

class Lepers extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "description.lepers";

  @override
  String name = "role.lepers";

  @override
  String group = "villager";

  @override
  GameTime nightActionTime = GameTime.sunrise;

  @override
  int difficultyIndex = 3;

  @override
  bool checkWin(GameController game, Player p) {
    return Werewolve().checkWin(game, p);
  }

  @override
  Future<void> onDeath(GameController game, Player p) async {
    if (p.killedBy?.role.name == "role.werewolve") {
      Werewolve().editPropertyForEveryWerewolve(
        game,
        "property.next_night_victim_count",
        0,
      );
    }
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
