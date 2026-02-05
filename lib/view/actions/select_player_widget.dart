import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/view/helpers/color_helpers.dart';

class SelectPlayerWidget extends StatefulWidget {
  final List<Player> players;
  final String message;
  final Player askingPlayer;
  final ValueChanged<Player?>? onResult;

  const SelectPlayerWidget({
    super.key,
    required this.players,
    required this.message,
    required this.askingPlayer,
    this.onResult,
  });

  @override
  State<SelectPlayerWidget> createState() => _SelectPlayerWidgetState();
}

class _SelectPlayerWidgetState extends State<SelectPlayerWidget> {
  Player? selectedPlayer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.0),
        Text(
          widget.message.tr(),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        SizedBox(height: 5.0),
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
                            ((player.notes != "") ? ("\n${player.notes}") : ""),
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
                        if (widget.onResult != null) {
                          widget.onResult!(isSelected ? null : player);
                        }
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
      ],
    );
  }
}
