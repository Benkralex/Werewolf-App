import '../game/game_time.dart';
import 'role.dart';

class Player {
  //Player
  String name;
  late String notes;
  //Role
  late Map<String, dynamic> properties;
  Role role;
  //Death
  late GameTime? diesAt;
  late Player? killedBy;
  late bool isAlive;
  late List<Player> killsOnDeath;
  //Protection
  late GameTime? protectedUntil;
  late Player? protectedBy;
  late bool isProtected;
  //Day Protection
  late Player? protectedAtDayBy;
  late bool isProtectedAtDay;
  //Night Protection
  late Player? protectedAtNightBy;
  late bool isProtectedAtNight;

  Player(this.name, this.role) {
    notes = "";
    properties = Map<String, dynamic>.from(role.defaultProperties);

    diesAt = null;
    killedBy = null;
    isAlive = true;
    killsOnDeath = [];

    protectedUntil = null;
    protectedBy = null;
    isProtected = false;

    protectedAtDayBy = null;
    isProtectedAtDay = false;

    protectedAtNightBy = null;
    isProtectedAtNight = false;
  }

  bool isNowProtected(GameTime gameTime) {
    if (isProtected) {
      return true;
    }
    if (gameTime.isNight) {
      return isProtectedAtNight;
    }
    if (gameTime.isDay) {
      return isProtectedAtDay;
    }
    return false;
  }

  void updateProtection(GameTime gameTime) {
    if (protectedUntil == gameTime) return;
    protectedUntil = null;
    protectedBy = null;
    isProtected = false;
  }

  @override
  String toString() {
    return """
---Player---
name $name
notes $notes
properties $properties
role ${role.toString()}
diesAt ${diesAt.toString()}
killedBy ${killedBy == null ? "null" : killedBy!.name}
isAlive $isAlive
protectedUntil ${protectedUntil.toString()}
protectedBy ${protectedBy == null ? "null" : protectedBy!.name}
isProtected $isProtected
protectedAtDayBy ${protectedAtDayBy == null ? "null" : protectedAtDayBy!.name}
isProtectedAtDay $isProtectedAtDay
protectedAtNightBy ${protectedAtNightBy == null ? "null" : protectedAtNightBy!.name}
isProtectedAtNight $isProtectedAtNight
""";
  }
}
