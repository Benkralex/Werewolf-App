import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/villager.dart';

class Bodyguard extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "";

  @override
  String group = "villager";

  @override
  String name = "role.bodyguard";

  @override
  GameTime nightActionTime = GameTime.preWerewolves;

  @override
  int difficultyIndex = 3;

  @override
  bool checkWin(GameController game, Player p) {
    return Villager().checkWin(game, p);
  }

  @override
  Future<void> onNightAction(GameController game, Player p) async {
    Player target = await game.selectPlayer(
      game.alivePlayers,
      "selection.protect_player",
      p,
    );
    target.isProtected = true;
    target.protectedBy = p;
    target.protectedUntil = GameTime.sunrise;
  }

  @override
  int maxPlayers = 1;
}
