import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';

class Werewolve extends Role {
  @override
  Map<String, dynamic> defaultProperties = {
    "property.next_night_victim_count": 1,
  };

  @override
  String description = "";

  @override
  String name = "role.werewolve";

  @override
  String group = "werewolve";

  @override
  GameTime nightActionTime = GameTime.withWerewolves;

  @override
  int difficultyIndex = -6;

  @override
  bool checkWin(GameController game, Player p) {
    int count = 0;
    bool vampiresArePlaying = game.playingRoles.any(
      (role) => role.group == "vampire",
    );
    for (Player p2 in game.alivePlayers) {
      if (p2.role.group == "werewolve") count++;
    }
    if (vampiresArePlaying) {
      return count == game.alivePlayers.length;
    } else {
      return (count) >= (game.alivePlayers.length / 2);
    }
  }

  @override
  Future<void> onNightAction(GameController game, Player p) async {
    for (
      int i = 0;
      i < (p.properties["property.next_night_victim_count"] ?? 1);
      i++
    ) {
      await killAPlayer(game, p);
    }
    editPropertyForEveryWerewolve(game, "property.next_night_victim_count", 1);
  }

  void editPropertyForEveryWerewolve(
    GameController game,
    String property,
    dynamic value,
  ) {
    for (Player p2 in game.players) {
      if (p2.role.name == "role.werewolve") {
        p2.properties[property] = value;
      }
    }
  }

  Future<void> killAPlayer(GameController game, Player p) async {
    game.killPlayer(
      await game.selectPlayer(
        game.alivePlayers
            .where(
              (p) =>
                  p.role.group != "werewolve" && p.role.group != "lonely_wolf",
            )
            .toList(),
        "selection.select_player_kill",
        p,
      ),
      p,
      GameTime.sunrise,
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
  int maxPlayers = 12;
}
