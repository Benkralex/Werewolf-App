import 'package:werewolf_app/model/game/game_controller.dart';
import 'package:werewolf_app/model/game/game_time.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/model/player/role.dart';
import 'package:werewolf_app/model/roles/werewolf.dart';

class WerewolfKid extends Role {
  @override
  Map<String, dynamic> defaultProperties = {};

  @override
  String description = "";

  @override
  String name = "role.werewolf_kid";

  @override
  String group = "werewolf";

  @override
  GameTime nightActionTime = GameTime.sunrise;

  @override
  bool checkWin(GameController game, Player p) {
    return Werewolf().checkWin(game, p);
  }

  @override
  Future<void> onDeath(GameController game, Player p) async {
    game.players
        .where((p2) {
          return p2.role.name == "role.werewolf";
        })
        .forEach((p2) {
          p2.properties["property.next_night_two_victims"] = 1;
        });
  }

  @override
  Future<void> onLynch(GameController game, Player p) async {
    await onDeath(game, p);
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
