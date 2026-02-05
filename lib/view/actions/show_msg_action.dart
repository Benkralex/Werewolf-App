import 'package:flutter/material.dart';
import 'package:werewolve_app/view/actions/game_action.dart';

class ShowMsgAction extends GameAction {
  ShowMsgAction(String message, BuildContext context) {
    super.interface = Center(
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }

  @override
  String? getResult() {
    return "";
  }
}
