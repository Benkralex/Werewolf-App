import 'package:werewolf_app/model/game/game_controller.dart';
import 'package:werewolf_app/model/game/game_time.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/model/player/role.dart';
import 'package:werewolf_app/model/roles/villager.dart';

class Witch extends Role {
  @override
  Map<String, dynamic> defaultProperties = {"property.kills": 2, "property.heals": 2};

  @override
  String description = "";

  @override
  String name = "role.witch";

  @override
  String group = "villager";

  @override
  GameTime nightActionTime = GameTime.afterWerewolfs;

  @override
  bool checkWin(GameController game, Player p) {
    return Villager().checkWin(game, p);
  }

  @override
  Future<void> onNightAction(GameController game, Player p) async {
    List<Player> dyingPlayers = game.players
        .where((p) => (p.isAlive && p.diesAt != null))
        .toList();
    for (Player p2 in dyingPlayers) {
      List<String> options = ["option.skip"];
      if (p.properties["property.kills"] > 0) options.add("option.kill");
      if (p.properties["property.heals"] > 0) options.add("option.heal");
      String action = await game.ask(p2.name, options);
      if (action == "option.kill") {
        game.killPlayer(
          await game.selectPlayer(game.alivePlayers, "selection.select_player_kill", p),
          p,
          GameTime.sunset,
        );
        p.properties["property.heal"]--;
      } else if (action == "option.heal") {
        p2.diesAt = null;
        p2.killedBy = null;
        p.properties["property.heals"]--;
      }
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
