import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:werewolf_app/view/pages/play_page.dart';
import 'package:werewolf_app/viewmodel/main.dart';

class InitNamesPage extends StatefulWidget {
  const InitNamesPage({super.key});

  @override
  State<InitNamesPage> createState() => InitNamesPageState();
}

class InitNamesPageState extends State<InitNamesPage> {
  List<String> names = ViewModel.playerNames;

  @override
  void initState() {
    super.initState();
  }

  Future<String> _showNameInputDialog(String currentName) async {
    String playerName = currentName;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('enter_player_name').tr(),
          content: TextField(
            onChanged: (value) {
              playerName = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'player_name'.tr(),
            ),
            controller: TextEditingController(text: currentName),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('option.cancel').tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('option.accept').tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return playerName;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listTiles = names.map((name) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListTile(
          title: Text(name),
          leading: SizedBox(
            width: 50.0,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  names.remove(name);
                });
              },
              color: ViewModel.iconButtonActiveColor(context),
            ),
          ),
          onLongPress: () {
            _showNameInputDialog(name).then((newName) {
              if (newName.isNotEmpty) {
                setState(() {
                  int index = names.indexOf(name);
                  names[index] = newName;
                });
              }
            });
          },
        ),
      );
    }).toList();

    if (listTiles.isNotEmpty) {
      listTiles.add(const Padding(padding: EdgeInsets.only(bottom: 64.0)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('choose_names').tr(),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showNameInputDialog('').then((playerName) {
                if (playerName.isNotEmpty) {
                  setState(() {
                    names.add(playerName);
                  });
                }
              });
            },
          ),
        ],
      ),
      body: listTiles.isEmpty
          ? Center(child: Text('no_names').tr())
          : ListView(children: listTiles),
      floatingActionButton: FloatingActionButton.extended(
        label: (names.isEmpty)
            ? Text('option.skip').tr()
            : (names.length != (ViewModel.gameController?.players.length ?? 0))
            ? Text('continue_with_names').tr(
                namedArgs: {
                  "count": names.length.toString(),
                  "maxCount":
                      ViewModel.gameController?.players.length.toString() ??
                      'error',
                },
              )
            : Text('option.next').tr(),
        onPressed: () {
          if (!(names.isEmpty ||
              names.length ==
                  (ViewModel.gameController?.players.length ?? 0))) {
            return;
          }
          if (names.isNotEmpty) {
            if (names.length != ViewModel.gameController?.players.length) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('error.every_player_must_have_a_name').tr(
                    namedArgs: {
                      'count': names.length.toString(),
                      'neededCount':
                          ViewModel.gameController?.players.length.toString() ??
                          '0',
                    },
                  ),
                ),
              );
              return;
            }
            names.shuffle();
            int index = 1;
            ViewModel.gameController?.players.forEach((player) {
              player.name = '${'player'.tr()} $index';
              index++;
            });
            for (var name in names) {
              ViewModel.gameController?.players
                      .firstWhere(
                        (player) => player.name.startsWith('player'.tr()),
                      )
                      .name =
                  name;
            }
          }
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const PlayPage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
        tooltip: 'create_game'.tr(),
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
