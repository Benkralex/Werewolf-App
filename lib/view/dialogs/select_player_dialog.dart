import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/view/helpers/color_helpers.dart';

class SelectPlayerDialog extends StatefulWidget {
  final List<Player> players;
  final String message;
  final Player askingPlayer;
  final ValueChanged<Player?>? onResult;

  const SelectPlayerDialog({
    super.key,
    required this.players,
    required this.message,
    required this.askingPlayer,
    this.onResult,
  });

  @override
  State<SelectPlayerDialog> createState() => _SelectPlayerDialogState();
}

class _SelectPlayerDialogState extends State<SelectPlayerDialog> {
  Player? selectedPlayer;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          SizedBox(height: 20.0),
          Text(
            widget.message.tr(),
            style: TextStyle(
              color: ColorHelpers.onSurfaceColor(context),
              fontSize: 32.0,
            ),
          ),
          Text(
            (widget.askingPlayer.role.maxPlayers > 1)
                ? widget.askingPlayer.role.name.tr()
                : "${widget.askingPlayer.role.name.tr()} (${widget.askingPlayer.name})",
            style: TextStyle(
              color: ColorHelpers.onSurfaceVariantColor(context),
              fontSize: 16.0,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: widget.players.length,
                itemBuilder: (context, index) {
                  final player = widget.players[index];
                  final isSelected = selectedPlayer == player;
                  return Column(
                    children: [
                      ListTile(
                        title: Text(player.name),
                        subtitle: Text(
                          player.role.name.tr() +
                              ((player.notes != "")
                                  ? ("\n${player.notes}")
                                  : ""),
                        ),
                        selected: isSelected,
                        selectedTileColor: ColorHelpers.onPrimaryColor(context),
                        selectedColor: ColorHelpers.primaryColor(context),
                        trailing: isSelected
                            ? Icon(
                                Icons.check,
                                color: ColorHelpers.primaryColor(context),
                              )
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onTap: () {
                          setState(() {
                            selectedPlayer = isSelected ? null : player;
                          });
                        },
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: FilledButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              onPressed: selectedPlayer != null
                  ? () {
                      if (widget.onResult != null) {
                        widget.onResult!(selectedPlayer);
                      } else {
                        Navigator.of(context).pop(selectedPlayer);
                      }
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
        return SelectPlayerDialog(
          players: players,
          message: message,
          askingPlayer: askingPlayer,
        );
      },
    ).then((value) {
      selectedPlayer = value;
    });
  }
  return selectedPlayer!;
}
