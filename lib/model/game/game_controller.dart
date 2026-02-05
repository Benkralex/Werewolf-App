import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:werewolve_app/model/game/game_state.dart';
import 'package:werewolve_app/model/game/game_time.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/villager.dart';
import 'package:werewolve_app/viewmodel/main.dart';

class GameController {
  List<Player> players;
  late GameState gameState;

  GameController(this.players) {
    gameState = GameState(GameTime.sunset, playingRoles);
  }

  List<Player> get alivePlayers {
    return players.where((p) => p.isAlive).toList();
  }

  List<Role> get playingRoles {
    List<Role> roles = [];
    for (Player p in players) {
      if (!roles.any((r) => r.name == p.role.name)) {
        roles.add(p.role);
      }
    }
    return roles;
  }

  //Game Logic
  Future<void> next() async {
    gameState.next();
    if (gameState.time.isNight && gameState.activeRole != null) {
      Player p = alivePlayers.firstWhere(
        (p) => p.role == gameState.activeRole!,
        orElse: () => Player("null", Villager()),
      );

      if (p.name != "null") {
        await gameState.activeRole!.onNightAction(this, p);
      }
    }
    await update();
  }

  Future<void> update() async {
    await showWakeUpMessages();
    await checkForWins();
    await unalivePlayers();
    await checkForWins();
    await lynchPlayer();
    await checkForWins();
    updatePlayerProtection();
    await checkForWins();
  }

  Future<void> showWakeUpMessages() async {
    if (!gameState.time.isSunrise) return;
    await ViewModel.showMessage("everyone_wake_up".tr());
  }

  Future<void> checkForWins() async {
    List<String> winningGroups = [];
    for (Player p in players) {
      if (p.role.checkWin(this, p)) {
        if (!winningGroups.contains(p.role.group)) {
          winningGroups.add(p.role.group);
        }
        gameState.gameFinished = true;
        await ViewModel.showWin();
      }
    }
    gameState.winningGroups = winningGroups;
  }

  Future<void> lynchPlayer() async {
    if (gameState.gameFinished) return;
    if (gameState.time == GameTime.sunset) {
      Player p = await selectPlayer(
        alivePlayers,
        "selection.select_player_lynch",
        Player("village".tr(), Villager()),
      );
      p.isAlive = false;
      await p.role.onLynch(this, p);
      if (p.isAlive) return;
      await showMessage(
        "player_dies".tr(
          namedArgs: {"player": p.name, "role": p.role.name.tr()},
        ),
      );
      for (Player p2 in p.killsOnDeath) {
        if (!p2.isAlive) continue;
        await killPlayerNow(p2);
      }
    }
  }

  void updatePlayerProtection() {
    for (Player p in players) {
      p.updateProtection(gameState.time);
    }
  }

  Future<void> unalivePlayers() async {
    for (Player p in alivePlayers) {
      if (p.diesAt == gameState.time) {
        if (!p.isNowProtected(gameState.time)) await killPlayerNow(p);
      }
    }
  }

  Future<void> killPlayerNow(Player p) async {
    p.isAlive = false;
    await p.role.onDeath(this, p);
    if (p.isAlive) return;
    await showMessage(
      "player_dies".tr(namedArgs: {"player": p.name, "role": p.role.name.tr()}),
    );
    for (Player p in p.killsOnDeath) {
      if (!p.isAlive) continue;
      await killPlayerNow(p);
    }
  }

  //Actions
  void killPlayer(Player target, Player killer, GameTime diesAt) {
    if (target.diesAt != null) {
      if (((diesAt.phase - gameState.time.phase + 1) % 5) <
          ((target.diesAt!.phase - gameState.time.phase + 1) % 5)) {
        // neu kommt vor alt
        target.diesAt = diesAt;
        target.killedBy = killer;
      }
    } else {
      target.diesAt = diesAt;
      target.killedBy = killer;
    }
  }

  Future<Player> selectPlayer(
    List<Player> players,
    String message,
    Player askingPlayer,
  ) async {
    return ViewModel.selectPlayer(players, message, askingPlayer);
  }

  Future<void> showMessage(String msg) async {
    await ViewModel.showMessage(msg);
  }

  Future<String> ask(String msg, String askedBy, List<String> options) async {
    return await ViewModel.ask(msg, askedBy, options);
  }

  @override
  String toString() {
    return """
---GameController---
players \n${players.map((p) => p.toString().split("\n").map((e) => "  $e").join("\n")).toList().join("\n")}
gameState \n${gameState.toString().split("\n").map((e) => "  $e").join("\n")}
playingRoles \n${playingRoles.map((r) => r.toString().split("\n").map((e) => "  $e").join("\n")).toList().join("\n")}
""";
  }
}
