import 'package:werewolf_app/model/game/game_controller.dart';
import 'package:werewolf_app/model/game/game_time.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/model/player/role.dart';

class Vampire extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "";

  @override
  String name = "role.vampire";

  @override
  String group = "vampire";

  @override
  GameTime nightActionTime = GameTime.withWerewolfs;

  @override
  bool checkWin(GameController game, Player p) {
    int count = 0;
    bool werewolfsArePlaying = game.playingRoles.any((role) => role.group == "werewolf");
    for (Player p2 in game.alivePlayers) {
      if (p2.role.group == "vampire") count++;
    }
    if (werewolfsArePlaying) {
      return count == game.alivePlayers.length;
    } else {
      return (count) >= (game.alivePlayers.length / 2);
    }
  }

  @override
  Future<void> onNightAction(GameController game, Player p) async {
    Player target = await game.selectPlayer(game.players, "selection.select_player_kill", p);
    game.killPlayer(target, p, GameTime.sunset);
  }

  @override
  String toString() {
    if (description == "") {
      return name;
    }
    return "$name: $description";
  }

  @override
  int maxPlayers = 6;
}
