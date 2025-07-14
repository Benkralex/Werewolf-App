import 'package:easy_localization/easy_localization.dart';
import 'package:werewolf_app/model/game/game_controller.dart';
import 'package:werewolf_app/model/game/game_time.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/model/player/role.dart';
import 'package:werewolf_app/model/roles/villager.dart';

class Seer extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "";

  @override
  String name = "role.seer";

  @override
  String group = "villager";

  @override
  GameTime nightActionTime = GameTime.preWerewolfs;

  @override
  bool checkWin(GameController game, Player p) {
    return Villager().checkWin(game, p);
  }

  @override
  Future<void> onNightAction(GameController game, Player p) async {
    Player target = await game.selectPlayer(game.players.where((i) => i != p).toList(), "selection.see_player_role", p);
    game.showMessage(
      "show_role_message".tr(namedArgs: {
        "name": target.name,
        "role": target.role.name.tr(),
      }),
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
