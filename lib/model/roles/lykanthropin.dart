import 'package:werewolf_app/model/game/game_controller.dart';
import 'package:werewolf_app/model/game/game_time.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/model/player/role.dart';
import 'package:werewolf_app/model/roles/villager.dart';
import 'package:werewolf_app/model/roles/werewolf.dart';

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
  bool checkWin(GameController game, Player p) {
    return Villager().checkWin(game, p);
  }

  @override
  Future<void> onDeath(GameController game, Player p) async {
    if (p.killedBy!.role == Werewolf()) {
      p.role = Werewolf();
      p.isAlive = true;
      p.killedBy = null;
      p.diesAt = null;
      game.showMessage(
        "The Werewolfs have a new member [tip on shoulder of ${p.name}]",
      );
    }
  }

  @override
  int maxPlayers = 1;
}
