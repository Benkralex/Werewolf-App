import 'package:easy_localization/easy_localization.dart';
import 'package:werewolf_app/model/game/game_controller.dart';
import 'package:werewolf_app/model/game/game_time.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/model/player/role.dart';
import 'package:werewolf_app/model/roles/villager.dart';

class Armor extends Role {
  @override
  Map<String, dynamic> defaultProperties = {
    "property.wakesUpEveryXNight": 2,
    "property.leftWakeUps": -1,
  };

  @override
  String description = "";

  @override
  String group = "villager";

  @override
  String name = "role.armor";

  @override
  GameTime nightActionTime = GameTime.preWerewolfs;

  @override
  bool checkWin(GameController game, Player p) {
    return Villager().checkWin(game, p);
  }

  @override
  Future<void> onNightAction(GameController game, Player p) async {
    if (p.properties["property.leftWakeUps"] != -1) {
      //If its not infinite...
      if (p.properties["property.leftWakeUps"] > 0) {
        p.properties["property.leftWakeUps"]--; //...subtract one or...
      } else {
        return; //...skip
      }
    }
    Player target1 = await game.selectPlayer(game.alivePlayers, "selection.first_fall_in_love", p);
    Player target2 = await game.selectPlayer(game.alivePlayers, "selection.second_fall_in_love", p);
    if (target1 == target2) {
      game.showMessage("error.armor_same_player_selected".tr());
      return;
    }
    target1.killsOnDeath.add(target2);
    target2.killsOnDeath.add(target1);
  }

  @override
  int maxPlayers = 1;
}
