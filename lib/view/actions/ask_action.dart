import 'package:werewolve_app/view/actions/ask_widget.dart';
import 'package:werewolve_app/view/actions/game_action.dart';

class AskAction extends GameAction {
  String? _selectedAnswer;

  AskAction(List<String> options, String message, String askedBy) {
    super.interface = AskWidget(
      onResult: (String? option) {
        _selectedAnswer = option;
      },
      msg: message,
      askedBy: askedBy,
      options: options,
    );
  }

  @override
  String? getResult() {
    return _selectedAnswer;
  }
}
