import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';

class Vampire extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "description.vampire";

  @override
  String name = "role.vampire";

  @override
  String group = "vampire";

  @override
  GameTime nightActionTime = GameTime.withWerewolves;

  @override
  int difficultyIndex = -8;

  @override
  bool checkWin(GameController game, Player p) {
    int count = 0;
    bool werewolvesArePlaying = game.playingRoles.any(
      (role) => role.group == "werewolve",
    );
    for (Player p2 in game.alivePlayers) {
      if (p2.role.group == "vampire") count++;
    }
    if (werewolvesArePlaying) {
      return count == game.alivePlayers.length;
    } else {
      return (count) >= (game.alivePlayers.length / 2);
    }
  }

  @override
  Future<void> onNightAction(GameController game, Player p) async {
    Player target = await game.selectPlayer(
      game.alivePlayers.where((i) => i.role.group != 'vampire').toList(),
      "selection.select_player_kill",
      p,
    );
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
