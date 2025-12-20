import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:werewolf_app/main.dart';
import 'package:werewolf_app/model/player/role.dart';
import 'package:werewolf_app/view/helpers/color_helpers.dart';
import 'package:werewolf_app/view/pages/setup_roles_page.dart';
import 'package:werewolf_app/view/widgets/select_count_widget.dart';
import 'package:werewolf_app/viewmodel/main.dart';

class SetupNamesPage extends StatefulWidget {
  const SetupNamesPage({super.key});

  @override
  State<SetupNamesPage> createState() => SetupNamesPageState();
}

class SetupNamesPageState extends State<SetupNamesPage> {
  List<String> names = ViewModel.playerNames;
  int value = 5;
  double maxPlayers = ViewModel.roles
      .map((Role r) => r.maxPlayers)
      .fold<int>(0, (a, b) => a + b)
      .toDouble();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Color selectedColor = prefs.getInt('seedColor') != null
      ? Color(prefs.getInt('seedColor')!)
      : Colors.blue;

  @override
  void initState() {
    names = ViewModel.names
        .where((name) => !name.startsWith('player'.tr()))
        .toList();
    int missingNames = value.toInt() - names.length;
    for (int i = 0; i < missingNames; i++) {
      names.add('${'player'.tr()} ${i + 1}');
    }
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    names = names.where((name) => !name.startsWith('player'.tr())).toList();
    int missingNames = value.toInt() - names.length;
    for (int i = 0; i < missingNames; i++) {
      names.add('${'player'.tr()} ${i + 1}');
    }
    super.setState(fn);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listTiles = names.map((name) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListTile(
          title: Text(
            name,
            style: TextStyle(
              color: (!name.startsWith('player'.tr()))
                  ? ColorHelpers.onSurfaceColor(context)
                  : ColorHelpers.getDisabledColor(
                      ColorHelpers.onSurfaceColor(context),
                    ),
            ),
          ),
          leading: SizedBox(
            width: 50.0,
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: name.startsWith('player'.tr())
                  ? null
                  : () {
                      names.remove(name);
                      setState(() {});
                    },
              color: Theme.of(context).colorScheme.primary,
              disabledColor: ColorHelpers.getDisabledColor(
                ColorHelpers.primaryColor(context),
              ),
            ),
          ),
        ),
      );
    }).toList();

    if (listTiles.isNotEmpty) {
      listTiles.add(const Padding(padding: EdgeInsets.only(bottom: 120.0)));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('choose_names').tr(),
        actions: [
          IconButton(
            icon: Icon(Icons.palette),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext bcontext) {
                  return AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('select_app_color').tr(),
                        Expanded(child: Container()),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(bcontext).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                    content: BlockPicker(
                      pickerColor: prefs.getInt('seedColor') != null
                          ? Color(prefs.getInt('seedColor')!)
                          : Colors.blue,
                      onColorChanged: (Color color) {
                        selectedColor = color;
                      },
                    ),
                    actions: <Widget>[
                      Column(
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: FilledButton.tonalIcon(
                              label: Text('option.reset').tr(),
                              icon: Icon(Icons.refresh),
                              onPressed: () {
                                prefs.remove('seedColor');
                                seedColor.value = null;
                                setState(() {});
                                Navigator.of(bcontext).pop();
                              },
                            ),
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: FilledButton.icon(
                              label: Text('option.save').tr(),
                              icon: Icon(Icons.check),
                              onPressed: () {
                                prefs.setInt('seedColor', selectedColor.value);
                                seedColor.value = selectedColor.value;
                                setState(() {});
                                Navigator.of(bcontext).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
          child: TextField(
            focusNode: _focusNode,
            maxLength: 20,
            autofocus: true,
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'add_player_name'.tr(),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (String? text) {
              if (text != null &&
                  text.isNotEmpty &&
                  !names.contains(text) &&
                  !text.startsWith('player'.tr())) {
                names.add(text);
                _controller.clear();
              }
              _focusNode.requestFocus();
              setState(() {});
            },
          ),
        ),
      ),
      body: Column(
        children: [
          SelectCountWidget(
            minCount: 5,
            maxCount: maxPlayers.toInt(),
            count: max(value, names.length),
            onCountChanged: (int newValue) {
              value = newValue;
              setState(() {});
            },
            label: 'selected_players_count',
          ),
          Expanded(child: ListView(children: listTiles)),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          ViewModel.names = names;
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const SetupRolesPage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
