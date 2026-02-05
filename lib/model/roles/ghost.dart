import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/villager.dart';

class Ghost extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "description.ghost";

  @override
  String group = "villager";

  @override
  String name = "role.ghost";

  @override
  GameTime nightActionTime = GameTime.preWerewolves;

  @override
  int difficultyIndex = 2;

  @override
  bool checkWin(GameController game, Player p) {
    return Villager().checkWin(game, p);
  }

  @override
  Future<void> onNightAction(GameController game, Player p) async {
    p.diesAt = GameTime.sunrise;
    p.killedBy = p;
  }

  @override
  int maxPlayers = 1;
}
