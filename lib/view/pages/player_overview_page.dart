import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/viewmodel/main.dart';

class PlayerOverviewPage extends StatefulWidget {
  const PlayerOverviewPage({super.key});

  @override
  State<PlayerOverviewPage> createState() => _PlayerOverviewPageState();
}

class _PlayerOverviewPageState extends State<PlayerOverviewPage> {
  void editPlayer(Player p) {
    String playerName = p.name;
    String notes = p.notes;
    TextEditingController playerNameController =
        TextEditingController(text: playerName);
    TextEditingController notesController = TextEditingController(text: notes);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('edit_player').tr(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  playerName = value;
                },
                controller: playerNameController,
                maxLength: 10,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
                decoration: InputDecoration(labelText: 'player_name'.tr()),
              ),
              TextField(
                onChanged: (value) {
                  notes = value;
                },
                controller: notesController,
                decoration: InputDecoration(labelText: 'note'.plural(2)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('option.cancel').tr(),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  p.name = playerName;
                  p.notes = notes;
                });
                Navigator.of(context).pop();
              },
              child: const Text('option.save').tr(),
            ),
          ],
        );
      },
    );
  }

  void editProperties(Player p) {
    Map<String, dynamic> properties = p.properties;
    Map<String, dynamic> defaultProperties = p.role.defaultProperties;
    Map<String, TextEditingController> propertyControllers = {};
    properties.forEach((key, value) {
      propertyControllers[key] = TextEditingController(text: value.toString());
    });
    Map<String, dynamic> changedProperties = Map<String, dynamic>.from(properties);
    List<Widget> propertyWidgets = [];
    properties.forEach(
      (key, value) {
        propertyWidgets.add(
          TextField(
            onChanged: (value) {
              changedProperties[key] = int.tryParse(value) ?? properties[key];
            },
            controller: propertyControllers[key],
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            decoration: InputDecoration(labelText: '${key.tr()} (${defaultProperties[key]})'),
          )
        );
      }
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('edit_properties').tr(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: propertyWidgets,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('option.cancel').tr(),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  p.properties = changedProperties;
                });
                Navigator.of(context).pop();
              },
              child: const Text('option.save').tr(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ViewModel.gameController == null) throw Exception('GameController is null');

    final players = List<Player>.from(ViewModel.gameController!.players);
    players.sort((a, b) => (a.isAlive ? 0 : 1).compareTo((b.isAlive ? 0 : 1)));

    return Scaffold(
      appBar: AppBar(
        title: Text('player_overview').tr(),
      ),
      body: ListView(
        children: players.map((player) {
          return ListTile(
            title: Text(
              player.name,
              style: TextStyle(color: player.isAlive ? Colors.white : Colors.grey),
            ),
            subtitle: Text(
              player.role.name.tr() + ((player.notes != "") ? ("\n${player.notes}") : ""),
              style: TextStyle(color: player.isAlive ? Colors.grey.shade300 : Colors.grey.shade600),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    editPlayer(player);
                  },
                  icon: const Icon(Icons.edit),
                  color: ViewModel.iconButtonActiveColor(context),
                ),
                (player.properties.keys.isNotEmpty)
                  ? IconButton(
                    onPressed: () {
                      editProperties(player);
                    },
                    icon: const Icon(Icons.settings),
                    color: ViewModel.iconButtonActiveColor(context),
                  )
                  : IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.settings),
                    color: ViewModel.iconButtonInactiveColor(context),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}