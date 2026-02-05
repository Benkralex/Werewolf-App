import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/model/roles/armor.dart';
import 'package:werewolve_app/model/roles/blink_girl.dart';
import 'package:werewolve_app/model/roles/bodyguard.dart';
import 'package:werewolve_app/model/roles/cursed.dart';
import 'package:werewolve_app/model/roles/gerber.dart';
import 'package:werewolve_app/model/roles/ghost.dart';
import 'package:werewolve_app/model/roles/hunter.dart';
import 'package:werewolve_app/model/roles/idiot.dart';
import 'package:werewolve_app/model/roles/lepers.dart';
import 'package:werewolve_app/model/roles/lonely_wolf.dart';
import 'package:werewolve_app/model/roles/lykanthropin.dart';
import 'package:werewolve_app/model/roles/mage.dart';
import 'package:werewolve_app/model/roles/mayor.dart';
import 'package:werewolve_app/model/roles/minion.dart';
import 'package:werewolve_app/model/roles/old_man.dart';
import 'package:werewolve_app/model/roles/pacifist.dart';
import 'package:werewolve_app/model/roles/priest.dart';
import 'package:werewolve_app/model/roles/prince.dart';
import 'package:werewolve_app/model/roles/seer.dart';
import 'package:werewolve_app/model/roles/seerin.dart';
import 'package:werewolve_app/model/roles/tough_guy.dart';
import 'package:werewolve_app/model/roles/vampire.dart';
import 'package:werewolve_app/model/roles/villager.dart';
import 'package:werewolve_app/model/roles/werewolve.dart';
import 'package:werewolve_app/model/roles/werewolve_kid.dart';
import 'package:werewolve_app/model/roles/witch.dart';

class ViewModel {
  static GameController? gameController;
  static List<Role> roles = [
    Armor(),
    BlinkGirl(),
    Bodyguard(),
    Cursed(),
    Gerber(),
    Ghost(),
    Hunter(),
    Idiot(),
    Lepers(),
    LonelyWolf(),
    Lykanthropin(),
    Mage(),
    Mayor(),
    Minion(),
    OldMan(),
    Pacifist(),
    Priest(),
    Prince(),
    Seer(),
    Seerin(),
    ToughGuy(),
    Vampire(),
    Villager(),
    WerewolveKid(),
    Werewolve(),
    Witch(),
  ];

  static List<String> names = [];

  // Callbacks
  static Function? selectPlayerCallback;
  static Future<Player> selectPlayer(
    List<Player> players,
    String message,
    Player askingPlayer,
  ) async {
    return await selectPlayerCallback?.call(players, message, askingPlayer);
  }

  static Function? showMessageCallback;
  static Future<void> showMessage(String message) async {
    return await showMessageCallback?.call(message);
  }

  static Function? askCallback;
  static Future<String> ask(
    String msg,
    String askedBy,
    List<String> options,
  ) async {
    return await askCallback?.call(msg, askedBy, options);
  }

  static Function? winCallback;
  static Future<void> showWin() async {
    return await winCallback?.call();
  }

  static List<String> playerNames = [];
}
