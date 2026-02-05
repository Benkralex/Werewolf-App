import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:werewolve_app/model/game/game_controller.dart';
import 'package:werewolve_app/model/player/player.dart';
import 'package:werewolve_app/model/player/role.dart';
import 'package:werewolve_app/view/helpers/color_helpers.dart';
import 'package:werewolve_app/view/pages/play_page.dart';
import 'package:werewolve_app/view/pages/player_overview_page.dart';
import 'package:werewolve_app/viewmodel/main.dart';

class SetupRolesPage extends StatefulWidget {
  const SetupRolesPage({super.key});

  @override
  State<SetupRolesPage> createState() => SetupRolesPageState();
}

class SetupRolesPageState extends State<SetupRolesPage> {
  Map<Role, int> roles = {};

  @override
  void initState() {
    super.initState();
    if (ViewModel.gameController?.gameState.gameFinished == true) {
      List<Player> players = ViewModel.gameController?.players ?? [];
      ViewModel.gameController = null;
      for (Player p in players) {
        Role role = p.role;
        if (roles[role] != null) {
          roles[role] = roles[role]! + 1;
        } else {
          roles[role] = 1;
        }
      }
    } else {
      ViewModel.gameController = null;
    }
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
                    ? () {
                        // Group roles by their group
                        Map<String, List<Role>> groupedRoles = {};
                        for (Role role in ViewModel.roles.where(
                          (Role role) => roles[role] == null,
                        )) {
                          String group = ('group.${role.group}').tr();
                          if (!groupedRoles.containsKey(group)) {
                            groupedRoles[group] = [];
                          }
                          groupedRoles[group]!.add(role);
                        }

                        // Build widgets
                        List<Widget> widgets = [];
                        groupedRoles.forEach((group, groupRoles) {
                          widgets.add(
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16.0,
                                16.0,
                                16.0,
                                8.0,
                              ),
                              child: Text(
                                group,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                          widgets.addAll(
                            groupRoles.map((Role role) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ListTile(
                                  title: Text(role.name).tr(),
                                  onTap: () {
                                    Navigator.of(context).pop(role);
                                  },
                                ),
                              );
                            }),
                          );
                        });
                        return widgets;
                      }()
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
                  color: ColorHelpers.primaryColor(context),
                ),
                IconButton(
                  onPressed: (count < role.maxPlayers)
                      ? () {
                          setState(() {
                            if (count < role.maxPlayers) {
                              roles[role] = count + 1;
                            }
                          });
                        }
                      : null,
                  icon: const Icon(Icons.add),
                  color: ColorHelpers.primaryColor(context),
                  disabledColor: ColorHelpers.getDisabledColor(
                    ColorHelpers.primaryColor(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();

    if (listTiles.isNotEmpty) {
      listTiles.add(const Padding(padding: EdgeInsets.only(bottom: 64.0)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('choose_roles').tr(),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showRoleSelectionSheet();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Text('setup_role_count').tr(
            namedArgs: {
              'count': roles.values.fold<int>(0, (a, b) => a + b).toString(),
              'total': ViewModel.names.length.toString(),
            },
          ),
          Expanded(
            child: listTiles.isEmpty
                ? Center(child: Text('no_roles').tr())
                : ListView(children: listTiles),
          ),
        ],
      ),
      floatingActionButton:
          (roles.values.fold<int>(0, (a, b) => a + b) == ViewModel.names.length)
          ? FloatingActionButton.large(
              onPressed: () {
                int count = roles.values.fold<int>(0, (a, b) => a + b);
                if (count != ViewModel.names.length) {
                  return;
                }
                List<Player> players = [];
                List<String> names = ViewModel.names.toList();
                names.shuffle();
                roles.forEach((role, c) {
                  for (int i = 0; i < c; i++) {
                    players.add(Player(names.removeLast(), role));
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
              child: const Icon(Icons.arrow_forward),
            )
          : null,
    );
  }
}
