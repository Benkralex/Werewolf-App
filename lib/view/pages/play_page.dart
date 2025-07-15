import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/view/dialogs/ask_dialog.dart';
import 'package:werewolf_app/view/pages/player_overview_page.dart';
import 'package:werewolf_app/view/dialogs/select_player_dialog.dart';
import 'package:werewolf_app/view/dialogs/msg_dialog.dart';
import 'package:werewolf_app/viewmodel/main.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => PlayPageState();
}

class PlayPageState extends State<PlayPage> {
  @override
  void initState() {
    super.initState();
    if (ViewModel.gameController == null) {
      throw Exception("GameController is null. Please create a game first.");
    }

    // Initialize callbacks for ViewModel
    ViewModel.selectPlayerCallback =
        (List<Player> players, String message, Player askingPlayer) async {
      return await selectPlayerDialog(context, players, message, askingPlayer);
    };
    ViewModel.showMessageCallback = (String message) async {
      return await msgDialog(context, message);
    };
    ViewModel.askCallback = (String msg, List<String> options) async {
      return await askDialog(context, msg, options);
    };
  }

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Text(
          'gametime.${ViewModel.gameController!.gameState.time.toString()}'
              .tr(),
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          bool gameFinished = ViewModel.gameController!.gameState.gameFinished;
          if (!gameFinished) {
            await ViewModel.gameController!.next();
            setState(() {});
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('dialog_title.game_finished').tr(),
                  content: Text('win_msg'.tr(namedArgs: {
                    'winner':
                        'role.${ViewModel.gameController!.gameState.winningGroups.join(", ")}'
                            .tr(),
                  })),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('option.new_game').tr(),
                      onPressed: () async {
                        await Navigator.of(context).pushNamedAndRemoveUntil(
                          '/',
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        tooltip: 'option.next'.tr(),
        icon: const Icon(Icons.arrow_forward),
        label: const Text('option.next').tr(),
      ),
    );
  }
}