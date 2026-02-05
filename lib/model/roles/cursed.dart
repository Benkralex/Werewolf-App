import 'package:easy_localization/easy_localization.dart';
import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/villager.dart';
import 'package:werewolve_app/model/roles/werewolve.dart';

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
  int difficultyIndex = -3;

  @override
  bool checkWin(GameController game, Player p) {
    return Villager().checkWin(game, p);
  }

  @override
  Future<void> onDeath(GameController game, Player p) async {
    if (p.killedBy?.role.name == "role.werewolve") {
      p.isAlive = true;
      game.showMessage(
        "changed_role".tr(
          namedArgs: {
            "player": p.name,
            "oldRole": "role.cursed".tr(),
            "newRole": "role.werewolve".tr(),
          },
        ),
      );
      p.role = Werewolve();
    }
  }

  @override
  int maxPlayers = 1;
}
