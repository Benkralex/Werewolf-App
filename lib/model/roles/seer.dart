import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/seerin.dart';
import 'package:werewolve_app/model/roles/villager.dart';

class Seer extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "description.seer";

  @override
  String name = "role.seer";

  @override
  String group = "villager";

  @override
  GameTime nightActionTime = GameTime.preWerewolves;

  @override
  int difficultyIndex = 7;

  @override
  bool checkWin(GameController game, Player p) {
    return Villager().checkWin(game, p);
  }

  @override
  Future<void> onNightAction(GameController game, Player p) async {
    Seerin().onNightAction(game, p);
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
