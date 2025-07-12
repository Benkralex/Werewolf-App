import '../player/role.dart';
import 'game_time.dart';

class GameState {
  // Time
  GameTime time;
  // Players and their roles
  List<Role> playingRoles;
  late int activeRoleIndex;
  // Counters
  late int dayCount;
  late int nightCount;
  // Win related
  late bool gameFinished;
  late List<String> winningGroups;

  GameState(this.time, this.playingRoles) {
    activeRoleIndex = 0;
    dayCount = 0;
    nightCount = 0;
    gameFinished = false;
  }

  List<Role> get activeRoles {
    return time.isDay
        ? []
        : playingRoles
              .where((r) => r.nightActionTime.phase == time.phase)
              .toList();
  }

  Role? get activeRole {
    if (activeRoles.isEmpty) return null;
    return activeRoles[activeRoleIndex];
  }

  void next() {
    if (activeRoleIndex >= (activeRoles.length - 1)) {
      //Next phase
      time.next();
      activeRoleIndex = 0;
    } else {
      //Next role of this phase
      activeRoleIndex++;
    }
    //Counter
    if (time.isSunrise) {
      nightCount++;
    } else if (time.isSunset) {
      dayCount++;
    }
  }

  @override
  String toString() {
    return """
---GameState---
ActiveRoleIndex: $activeRoleIndex
GameTime ${time.toString()}
PlayingRoles ${playingRoles.map((r) => r.name).toString()}
DayCount $dayCount
NightCount $nightCount
ActiveRoles ${activeRoles.map((r) => r.name).toString()}
ActiveRole ${activeRole.toString()}
""";
  }
}
