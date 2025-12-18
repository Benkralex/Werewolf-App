import 'package:easy_localization/easy_localization.dart';
import 'package:werewolf_app/model/game/game_controller.dart';
import 'package:werewolf_app/model/game/game_time.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/model/player/role.dart';
import 'package:werewolf_app/model/roles/villager.dart';
import 'package:werewolf_app/model/roles/werewolf.dart';

class Cursed extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "";

  @override
  String group = "villager";

  @override
  String name = "role.cursed";

  @override
  GameTime nightActionTime = GameTime.sunrise;

  @override
  bool checkWin(GameController game, Player p) {
    return Villager().checkWin(game, p);
  }

  @override
  Future<void> onDeath(GameController game, Player p) async {
    if (p.killedBy?.role.name == "role.werewolf") {
      p.isAlive = true;
      game.showMessage(
        "changed_role".tr(
          namedArgs: {
            "player": p.name,
            "oldRole": "role.cursed".tr(),
            "newRole": "role.werewolf".tr(),
          },
        ),
      );
      p.role = Werewolf();
    }
  }

  @override
  int maxPlayers = 1;
}
