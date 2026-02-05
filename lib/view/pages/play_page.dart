import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/view/actions/ask_action.dart';
import 'package:werewolve_app/view/actions/game_action.dart';
import 'package:werewolve_app/view/actions/select_player_action.dart';
import 'package:werewolve_app/view/actions/show_msg_action.dart';
import 'package:werewolve_app/view/actions/show_win_action.dart';
import 'package:werewolve_app/view/pages/player_overview_page.dart';
import 'package:werewolve_app/viewmodel/main.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => PlayPageState();
}

class PlayPageState extends State<PlayPage> {
  Completer<dynamic>? _dialogCompleter;
  GameAction? action;

  Future<T?> _showInlineDialog<T>(GameAction action) {
    var completer = Completer<T?>();
    _dialogCompleter = completer;
    setState(() {
      this.action = action;
    });
    return completer.future;
  }

  void _closeInlineDialog(dynamic result) {
    if (result == null) {
      return;
    }
    if (_dialogCompleter != null && !_dialogCompleter!.isCompleted) {
      _dialogCompleter!.complete(result);
    }
    setState(() {
      action = null;
      _dialogCompleter = null;
    });
  }

  @override
  void initState() {
    super.initState();
    if (ViewModel.gameController == null) {
      throw Exception("GameController is null. Please create a game first.");
    }

    // Initialize callbacks for ViewModel
    ViewModel.selectPlayerCallback =
        (List<Player> players, String message, Player askingPlayer) async {
          var action = SelectPlayerAction(players, message, askingPlayer);
          await _showInlineDialog<Player?>(action);
          return action.getResult();
        };
    ViewModel.showMessageCallback = (String message) async {
      var action = ShowMsgAction(message, context);
      await _showInlineDialog<void>(action);
      return action.getResult();
    };
    ViewModel.askCallback =
        (String msg, String askedBy, List<String> options) async {
          var action = AskAction(options, msg, askedBy);
          await _showInlineDialog<String?>(action);
          return action.getResult();
        };
    ViewModel.winCallback = () async {
      var action = ShowWinAction(context);
      await _showInlineDialog<void>(action);
      return _closeInlineDialog(null);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (ViewModel.gameController == null) {
      Navigator.of(context).pop();
    }
    // Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('overview').tr(),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const PlayerOverviewPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [Expanded(child: action?.interface ?? Container())],
      ),
      floatingActionButton: (!ViewModel.gameController!.gameState.gameFinished)
          ? FloatingActionButton.large(
              onPressed: () async {
                if (action != null) {
                  _closeInlineDialog(action!.getResult());
                  return;
                }
                bool gameFinished =
                    ViewModel.gameController!.gameState.gameFinished;
                if (!gameFinished) {
                  await ViewModel.gameController!.next();
                  setState(() {});
                } else {
                  var action = ShowWinAction(context);
                  await _showInlineDialog<void>(action);
                  _closeInlineDialog(null);
                }
              },
              child: const Icon(Icons.arrow_forward),
            )
          : FloatingActionButton.large(
              onPressed: () async {
                await Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              },
              //label: Text('option.new_game').tr(),
              child: Icon(Icons.replay),
            ),
    );
  }
}
