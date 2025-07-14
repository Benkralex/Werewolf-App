import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/viewmodel/main.dart';

class SelectPlayerDialog extends StatefulWidget {
  final List<Player> players;
  final String message;
  final Player askingPlayer;

  const SelectPlayerDialog({super.key, required this.players, required this.message, required this.askingPlayer});

  @override
  State<SelectPlayerDialog> createState() => _SelectPlayerDialogState();
}

class _SelectPlayerDialogState extends State<SelectPlayerDialog> {
  Player? selectedPlayer;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Column(
        children: [
          AppBar(
            title: 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.tr(),
                ),
                Text(
                  (widget.askingPlayer.role.maxPlayers > 1) 
                    ?  widget.askingPlayer.role.name.tr()
                    : "${widget.askingPlayer.role.name.tr()} (${widget.askingPlayer.name})",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: widget.players.length,
                itemBuilder: (context, index) {
                  final player = widget.players[index];
                  final isSelected = selectedPlayer == player;
                  return ListTile(
                    title: Text(player.name),
                    subtitle: Text(player.role.name.tr() + ((player.notes != "") ? ("\n${player.notes}") : "")),
                    selected: isSelected,
                    selectedTileColor: ViewModel.primaryColor(context),
                    selectedColor: Colors.black,
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.black)
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onTap: () {
                      setState(() {
                        selectedPlayer = isSelected ? null : player;
                      });
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              onPressed: selectedPlayer != null
                  ? () {
                      Navigator.of(context).pop(selectedPlayer);
                    }
                  : null,
              child: Text('selection.select_player'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Player> selectPlayerDialog(
  BuildContext context,
  List<Player> players,
  String message,
  Player askingPlayer,
) async {
  Player? selectedPlayer;
  while (selectedPlayer == null) {
    await showDialog(
      context: context,
      builder: (context) {
        return SelectPlayerDialog(players: players, message: message, askingPlayer: askingPlayer);
      },
    ).then((value) {
      selectedPlayer = value;
    });
  }
  return selectedPlayer!;
}