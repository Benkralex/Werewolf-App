import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/villager.dart';

class Lykanthropin extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "";

  @override
  String group = "villager";

  @override
  String name = "role.lykanthropin";

  @override
  GameTime nightActionTime = GameTime.sunrise;

  @override
  int difficultyIndex = -1;

  @override
  bool checkWin(GameController game, Player p) {
    return Villager().checkWin(game, p);
  }

  @override
  int maxPlayers = 1;
}
