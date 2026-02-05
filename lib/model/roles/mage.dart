import 'package:easy_localization/easy_localization.dart';
import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/villager.dart';

class Mage extends Role {
  @override
  Map<String, dynamic> defaultProperties = {
    "property.kills": 2,
    "property.heals": 2,
  };

  @override
  String description = "";

  @override
  String name = "role.mage";

  @override
  String group = "villager";

  @override
  GameTime nightActionTime = GameTime.afterWerewolves;

  @override
  int difficultyIndex = 4;

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
      if (p2.role.name == "role.old_man" &&
          game.gameState.nightCount ==
              game.players
                  .where((p2) => p2.role.name == "role.werewolve")
                  .length) {
        continue;
      }
      List<String> options = ["option.skip"];
      if (p.properties["property.kills"] > 0) options.add("option.kill");
      if (p.properties["property.heals"] > 0) options.add("option.heal");
      String action = await game.ask(
        "witch_ask_heal_kill_msg".tr(namedArgs: {'player': p2.name}),
        "(${p.name}) ${p.role.name.tr()}",
        options,
      );
      if (action == "option.kill") {
        game.killPlayer(
          await game.selectPlayer(
            game.alivePlayers.where((pl) => pl != p2 && pl != p).toList(),
            "selection.select_player_kill",
            p,
          ),
          p,
          p2.diesAt!,
        );
        p.properties["property.kills"]--;
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
