import 'package:werewolf_app/model/player/player.dart';

import '../game/game_controller.dart';
import '../game/game_time.dart';

abstract class Role {
  //Properties
  abstract Map<String, dynamic> defaultProperties;
  abstract GameTime nightActionTime;
  abstract String name;
  abstract String group;
  abstract String description;
  abstract int maxPlayers;

  //Win
  bool checkWin(GameController game, Player p) {
    return false;
  }

  //Events
  Future<void> onNightAction(GameController game, Player p) async {
    return;
  }

  Future<void> onDeath(GameController game, Player p) async {
    return;
  }

  Future<void> onLynch(GameController game, Player p) async {
    return;
  }

  @override
  String toString() {
    if (description == "") {
      return name;
    }
    return "$name: $description";
  }

  @override
  bool operator ==(Object other) {
    if (other is! Role) return false;
    return name == other.name;
  }

  @override
  int get hashCode => name.hashCode;
}
