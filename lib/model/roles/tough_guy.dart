import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/villager.dart';

class ToughGuy extends Role {
  @override
  Map<String, dynamic> defaultProperties = {"property.diesNextSunrises": 0};

  @override
  String description = "";

  @override
  String group = "villager";

  @override
  String name = "role.tough_guy";

  @override
  GameTime nightActionTime = GameTime.sunrise;

  @override
  int difficultyIndex = 3;

  @override
  bool checkWin(GameController game, Player p) {
    return Villager().checkWin(game, p);
  }

  @override
  Future<void> onDeath(GameController game, Player p) async {
    if (p.killedBy?.role.name == "role.werewolve" &&
        p.properties["property.diesNextSunrises"] == 0) {
      p.isAlive = true;
      p.diesAt = GameTime.sunrise;
      p.properties["property.diesNextSunrises"] = 1;
    }
  }

  @override
  int maxPlayers = 1;
}
