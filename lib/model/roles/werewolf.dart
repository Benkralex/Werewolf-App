import 'package:werewolf_app/model/game/game_controller.dart';
import 'package:werewolf_app/model/game/game_time.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/model/player/role.dart';

class Werewolf extends Role {
  @override
  Map<String, dynamic> defaultProperties = {
    "property.next_night_victim_count": 1,
  };

  @override
  String description = "";

  @override
  String name = "role.werewolf";

  @override
  String group = "werewolf";

  @override
  GameTime nightActionTime = GameTime.withWerewolfs;

  @override
  bool checkWin(GameController game, Player p) {
    int count = 0;
    bool vampiresArePlaying = game.playingRoles.any(
      (role) => role.group == "vampire",
    );
    for (Player p2 in game.alivePlayers) {
      if (p2.role.group == "werewolf") count++;
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
    editPropertyForEveryWerewolf(game, "property.next_night_victim_count", 1);
  }

  void editPropertyForEveryWerewolf(
    GameController game,
    String property,
    dynamic value,
  ) {
    for (Player p2 in game.players) {
      if (p2.role.name == "role.werewolf") {
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
                  p.role.group != "werewolf" && p.role.group != "lonely_wolf",
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
