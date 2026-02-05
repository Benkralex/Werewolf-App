import 'package:easy_localization/easy_localization.dart';
import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/villager.dart';

class Seerin extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "description.seerin";

  @override
  String name = "role.seerin";

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
    Player target = await game.selectPlayer(
      game.alivePlayers.where((i) => i != p).toList(),
      "selection.see_player_role",
      p,
    );
    game.showMessage(
      "show_role_message".tr(
        namedArgs: {
          "name": target.name,
          "role": (target.role.name == "role.lykanthropin")
              ? "role.werewolve".tr()
              : target.role.name.tr(),
        },
      ),
    );
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
