import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/view/actions/game_action.dart';
import 'package:werewolve_app/view/actions/select_player_widget.dart';

class SelectPlayerAction extends GameAction {
  Player? _selectedPlayer;

  SelectPlayerAction(
    List<Player> players,
    String message,
    Player askingPlayer,
  ) {
    super.interface = SelectPlayerWidget(
      players: players,
      message: message,
      askingPlayer: askingPlayer,
      onResult: (Player? player) {
        _selectedPlayer = player;
      },
    );
  }

  @override
  Player? getResult() {
    return _selectedPlayer;
  }
}
