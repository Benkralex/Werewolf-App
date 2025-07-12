import 'package:flutter/material.dart';
import 'package:werewolf_app/model/game/game_controller.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/model/player/role.dart';
import 'package:werewolf_app/model/roles/armor.dart';
import 'package:werewolf_app/model/roles/blink_girl.dart';
import 'package:werewolf_app/model/roles/bodyguard.dart';
import 'package:werewolf_app/model/roles/gerber.dart';
import 'package:werewolf_app/model/roles/hunter.dart';
import 'package:werewolf_app/model/roles/idiot.dart';
import 'package:werewolf_app/model/roles/lykanthropin.dart';
import 'package:werewolf_app/model/roles/mage.dart';
import 'package:werewolf_app/model/roles/pacifist.dart';
import 'package:werewolf_app/model/roles/priest.dart';
import 'package:werewolf_app/model/roles/prince.dart';
import 'package:werewolf_app/model/roles/seer.dart';
import 'package:werewolf_app/model/roles/seerin.dart';
import 'package:werewolf_app/model/roles/vampire.dart';
import 'package:werewolf_app/model/roles/villager.dart';
import 'package:werewolf_app/model/roles/werewolf.dart';
import 'package:werewolf_app/model/roles/witch.dart';

class ViewModel {
  static GameController? gameController;
  static List<Role> roles = [
    Armor(),
    BlinkGirl(),
    Bodyguard(),
    Gerber(),
    Hunter(),
    Idiot(),
    Lykanthropin(),
    Mage(),
    Pacifist(),
    Priest(),
    Prince(),
    Seer(),
    Seerin(),
    Vampire(),
    Villager(),
    Werewolf(),
    Witch(),
  ];

  // Colors
  static Color iconButtonActiveColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }
  static Color iconButtonInactiveColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary.withValues(
      alpha: 0.6,
    );
  }
  static Color primaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }
  static Color secondaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  // Callbacks
  static Function? selectPlayerCallback;
  static Future<Player> selectPlayer(List<Player> players, String message, Player askingPlayer) async {
    return await selectPlayerCallback?.call(players, message, askingPlayer);
  }

  static Function? showMessageCallback;
  static Future<void> showMessage(String message) async {
    return await showMessageCallback?.call(message);
  }

  static Function? askCallback;
  static Future<String> ask(String msg, List<String> options) async {
    return await askCallback?.call(msg, options);
  }
}