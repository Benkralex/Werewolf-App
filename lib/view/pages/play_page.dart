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
  Widget build(BuildContext context) {
    if (ViewModel.gameController == null) throw Exception("GameController is null. Please create a game first.");

    // Initialize callbacks for ViewModel
    ViewModel.selectPlayerCallback = (List<Player> players, String message, Player askingPlayer) async {
      return await selectPlayerDialog(context, players, message, askingPlayer);
    };
    ViewModel.showMessageCallback = (String message) async {
      return await msgDialog(context, message);
    };
    ViewModel.askCallback = (String msg, List<String> options) async {
      return await askDialog(context, msg, options);
    };

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
      body: ElevatedButton(onPressed: () => {ViewModel.gameController!.next()}, child: const Text('next')),
    );
  }
}