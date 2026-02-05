import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:werewolve_app/view/actions/game_action.dart';
import 'package:werewolve_app/viewmodel/main.dart';

class ShowWinAction extends GameAction {
  ShowWinAction(BuildContext context) {
    super.interface = Center(
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Text(
            'game_finished',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ).tr(),
          SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'win_msg'.tr(
                    namedArgs: {
                      'winner': ViewModel
                          .gameController!
                          .gameState
                          .winningGroups
                          .map((group) => "role.$group".tr())
                          .join(", "),
                    },
                  ),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
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
