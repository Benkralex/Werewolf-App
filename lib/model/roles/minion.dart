import 'package:easy_localization/easy_localization.dart';
import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/werewolve.dart';

class Minion extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "description.minion";

  @override
  String name = "role.minion";

  @override
  String group = "werewolve";

  @override
  GameTime nightActionTime = GameTime.preWerewolves;

  @override
  int difficultyIndex = -6;

  @override
  bool checkWin(GameController game, Player p) {
    return Werewolve().checkWin(game, p);
  }

  @override
  Future<void> onNightAction(GameController game, Player p) async {
    if (game.gameState.nightCount != 0) return;
    await game.showMessage(
      "minion_will_wake_up".tr(namedArgs: {"player": p.name}),
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
