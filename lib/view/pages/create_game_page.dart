import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:werewolf_app/model/game/game_controller.dart';
import 'package:werewolf_app/model/player/player.dart';
import 'package:werewolf_app/model/player/role.dart';
import 'package:werewolf_app/view/pages/play_page.dart';
import 'package:werewolf_app/viewmodel/main.dart';

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({super.key});

  @override
  State<CreateGamePage> createState() => CreateGamePageState();
}


class CreateGamePageState extends State<CreateGamePage> {
  Map<Role, int> roles = {
    ViewModel.roles.firstWhere((role) => role.name == "role.villager"): 5,
    ViewModel.roles.firstWhere((role) => role.name == "role.werewolf"): 2,
  };

  @override
  void initState() {
    super.initState();
    ViewModel.gameController = null;
  }

  void _showRoleSelectionSheet() async {
    final Role? selectedRole = await showModalBottomSheet<Role>(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: (ViewModel.roles.isNotEmpty)
                    ? ViewModel.roles.map((Role role) {
                        if (roles[role] == null) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ListTile(
                              title: Text(role.name).tr(),
                              onTap: () {
                                Navigator.of(context).pop(role);
                              },
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }).toList()
                    : [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text("no_roles").tr(),
                        ),
                      ],
              ),
            );
          },
        );
      },
    );
    if (selectedRole != null) {
      setState(() {
        roles[selectedRole] = (roles[selectedRole] ?? 0) + 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listTiles = roles.entries.map((entry) {
      Role role = entry.key;
      int count = entry.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListTile(
          title: Row(
            children: [
              Text('$count'),
              const SizedBox(width: 8.0),
              Text(role.name).tr(),
            ],
          ),
          trailing: SizedBox(
            width: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: (count == 1)
                      ? const Icon(Icons.delete)
                      : const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (count == 1) {
                        roles.remove(role);
                      } else {
                        roles[role] = count - 1;
                      }
                    });
                  },
                  color: ViewModel.iconButtonActiveColor(context),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (count < role.maxPlayers) {
                        roles[role] = count + 1;
                      }
                    });
                  },
                  icon: const Icon(Icons.add),
                  color: (count < role.maxPlayers) ? ViewModel.iconButtonActiveColor(context) : ViewModel.iconButtonInactiveColor(context),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();

    if (listTiles.isNotEmpty) {
      listTiles.add(
        const Padding(
          padding: EdgeInsets.only(bottom: 64.0),
        ),
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('create_game').tr(),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showRoleSelectionSheet();
            },
          ),
        ],
      ),
      body: listTiles.isEmpty
          ? Center(child: Text('no_roles').tr())
          : ListView(children: listTiles),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          int count = 0;
          roles.forEach((role, c) {
            count += c;
          });
          if (count < 5) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('error.min_player_count_must_be_reached').tr(),
              ),
            );
            return;
          }
          List<Player> players = [];
          roles.forEach((role, c) {
            for (int i = 0; i < c; i++) {
              players.add(Player("${'player'.tr()} ${players.length + 1}", role));
            }
          });
          ViewModel.gameController = GameController(players);
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
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}