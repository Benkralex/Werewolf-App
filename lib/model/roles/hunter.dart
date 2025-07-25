import 'package:werewolf_app/model/game/game_controller.dart';
import 'package:werewolf_app/model/game/game_time.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/model/player/role.dart';
import 'package:werewolf_app/model/roles/villager.dart';

class Hunter extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "";

  @override
  String group = "villager";

  @override
  String name = "role.hunter";

  @override
  GameTime nightActionTime = GameTime.sunrise;

  @override
  bool checkWin(GameController game, Player p) {
    return Villager().checkWin(game, p);
  }

  @override
  Future<void> onDeath(GameController game, Player p) async {
    Player target = await game.selectPlayer(game.alivePlayers.where((i) => i != p).toList(), "selection.hunter_kill", p);
    target.killedBy = p;
    game.killPlayerNow(target);
    if (target.isAlive) target.killedBy = null;
  }

  @override
  int maxPlayers = 1;
}
