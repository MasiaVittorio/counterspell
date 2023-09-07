import 'package:counter_spell_new/core.dart';
import 'package:flutter/scheduler.dart';

class PlayGroupEditor extends StatefulWidget {
  final CSBloc bloc;
  final bool fromClosedPanel;
  const PlayGroupEditor(
    this.bloc, {
    required this.fromClosedPanel,
  });

  static const double playerTileSize = 56.0;
  static const double titleSize = PanelTitle.height;
  static const double hintSize = 44;
  static const double newPlayerSize = playerTileSize + hintSize;
  static double sizeCalc(int howMany) =>
      (howMany.clamp(1, 6.5)) * playerTileSize + titleSize + newPlayerSize;

  @override
  State createState() => _PlayGroupEditorState();
}

class _PlayGroupEditorState extends State<PlayGroupEditor> {
  late TextEditingController controller;
  late FocusNode focusNode;
  String? edited;
  //"" => newPlayer
  bool newGrouping = false;

  String get currentText => controller.text.trim();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
    widget.bloc.achievements.playGroupEdited(widget.fromClosedPanel);
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  CSBloc get bloc => widget.bloc;
  CSGame get game => bloc.game;
  CSGameState get state => game.gameState;
  CSGameGroup get group => game.gameGroup;

  void _reCalcSize() {
    final int howMany = state.gameState.value.players.length;
    final stage = Stage.of(context)!;
    stage.panelController.alertController
        .recalcAlertSize(PlayGroupEditor.sizeCalc(howMany));
  }

  void startEditing(String who) {
    setState(() {
      edited = who;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void _endEditing() {
    controller.clear();
    setState(() {
      edited = null;
      focusNode.unfocus();
    });
  }

  void confirm() {
    if (edited == "") {
      state.addNewPlayer(currentText);
    } else {
      state.renamePlayer(edited, currentText);
    }
    _endEditing();
    _reCalcSize();
  }

  void cancel() {
    _endEditing();
  }

  void startNewGroup() {
    setState(() {
      newGrouping = true;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void _endNewGrouping() {
    controller.clear();
    setState(() {
      newGrouping = false;
      focusNode.unfocus();
    });
  }

  int? get validateNumber {
    int? result;
    try {
      final int howMany = int.parse(currentText);
      if (howMany > 0 && howMany <= maxNumberOfPlayers) {
        result = howMany;
      }
    } catch (e) {
      result = null;
    }
    return result;
  }

  void confirmNewGroup() {
    final int? howMany = validateNumber;
    if (howMany != null) {
      state.startNew({
        for (int i = 1; i <= howMany; ++i) "Player $i",
      });
      _endNewGrouping();
    }
    _reCalcSize();
  }

  void cancelNewGroup() {
    _endNewGrouping();
  }

  void start(String? who) {
    if (who != null) {
      if (newGrouping) {
        _endNewGrouping();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          startEditing(who);
        });
      } else if (edited != null) {
        if (edited == who) {
          return;
        } else {
          _endEditing();
          SchedulerBinding.instance.addPostFrameCallback((_) {
            startEditing(who);
          });
        }
      } else {
        startEditing(who);
      }
    } else {
      if (newGrouping) {
        return;
      } else if (edited != null) {
        _endEditing();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          startNewGroup();
        });
      } else {
        startNewGroup();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final backgroundColor = themeData.scaffoldBackgroundColor;

    return IconTheme.merge(
      data: const IconThemeData(opacity: 1.0),
      child: WillPopScope(
        onWillPop: () async {
          if (edited != null) {
            _endEditing();
            return false;
          }
          if (newGrouping) {
            _endNewGrouping();
            return false;
          }
          return true;
        },
        child: Material(
          color: backgroundColor,
          child: group.orderedNames.build((_, names) {
            final Widget textField = buildTextField(names);
            return Column(
              children: <Widget>[
                const Material(child: PanelTitle("Edit Playgroup")),
                Expanded(
                  child: Material(
                    elevation: 2,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ReorderableList(
                        shrinkWrap: true,
                        itemCount: names.length,
                        onReorder: group.onReorder,
                        physics: Stage.of(context)!
                          .panelController.panelScrollPhysics(),
                        proxyDecorator: (child, _, animation) => AnimatedBuilder(
                          animation: animation,
                          child: child,
                          builder: (_, child) {
                            return Container(
                              decoration: BoxDecoration(
                                boxShadow: [BoxShadow(
                                  color: Colors.grey.shade900.withOpacity(0.3),
                                  blurRadius: Tween<double>(
                                    begin: 0,
                                    end: 8,
                                  ).evaluate(animation),
                                )]
                              ),
                              child: child,
                            );
                          }
                        ),
                        itemBuilder: (_, int i) => Material(
                          key: ValueKey(names[i]),
                          child: currentPlayer(
                            i, names[i], textField, themeData, names.length == 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                hints(themeData, names),
                newPlayer(textField),
              ],
            );
          },),
        ),
      ),
    );
  }

  TextField buildTextField(List<String> names) => TextField(
    key: const ValueKey("counterspell_key_widget_textfield_groupeditor"),
    onChanged: (_) {
      if (mounted) {
        setState(() {});
      }
    },
    controller: controller,
    keyboardType:
        newGrouping ? TextInputType.number : TextInputType.text,
    textCapitalization: TextCapitalization.words,
    maxLines: 1,
    focusNode: focusNode,
    decoration: InputDecoration(
      isDense: true,
      hintText: edited == ""
        ? "Player's name"
        : edited != null
            ? "Rename $edited"
            : newGrouping
                ? "How many players"
                : null,
      errorText: (newGrouping && validateNumber == null)
        ? "Insert a number between 2 and $maxNumberOfPlayers"
        : (edited == "" && names.contains(currentText))
            ? "Name a different player"
            : null,
    ),
  );

  Widget hints(ThemeData themeData, List<String> currentNames) => SizedBox(
    height: PlayGroupEditor.hintSize,
    child: group.savedNames.build((context, savedNames) => ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        for (final savedName in savedNames)
          if (savedName.toLowerCase().contains(currentText.toLowerCase()) 
            && currentText != "" 
            && currentText != savedName 
            && !currentNames.contains(savedName)
          )
            hint(savedName, themeData),
      ],
    )),
  );

  Padding hint(String savedName, ThemeData themeData) => Padding(
    padding: const EdgeInsets.all(4.0),
    child: InkResponse(
      splashColor: Colors.transparent,
      onTap: () {
        controller.text = savedName;
        confirm();
      },
      child: Chip(
        onDeleted: () => group.unSaveName(savedName),
        backgroundColor: themeData.canvasColor,
        elevation: 1,
        label: Text(savedName),
      ),
    ),
  );

  Widget newPlayer(Widget textField) {
    if (edited == "") return editNewPlayer(textField);
    if (newGrouping) return editNewGroup(textField);
    return promptNewPlayer();
  }

  Widget editNewPlayer(Widget textField) {
    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: cancel,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.check),
        onPressed: confirm,
      ),
      title: textField,
    );
  }

  Widget promptNewPlayer() {
    return ListTile(
      onTap: () => start(""),
      leading:
          IconButton(onPressed: () => start(""), icon: const Icon(Icons.add)),
      title: const Text("New Player"),
      trailing: IconButton(
        onPressed: () => start(null),
        icon: const Icon(Icons.repeat),
      ),
    );
  }

  Widget editNewGroup(Widget textField) {
    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: cancelNewGroup,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.check),
        onPressed: confirmNewGroup,
      ),
      title: textField,
    );
  }

  Widget currentPlayer(
    int index,
    String name, 
    Widget textField, 
    ThemeData themeData, 
    bool last,
  ) {
    Widget result;
    if (name == edited) {
      result = editCurrentPlayer(name, textField);
    } else {
      result = promptCurrentPlayer(index, name, themeData, last);
    }
    return SizedBox(
      height: PlayGroupEditor.playerTileSize,
      child: result,
    );
  }

  Widget promptCurrentPlayer(int index, String name, ThemeData themeData, bool last) {
    return ListTile(
      onTap: () => start(name),
      trailing: ReorderableDragStartListener(
        index: index,
        child: IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          icon: Icon(
            Icons.unfold_more,
            color: themeData.colorScheme.onSurface,
          ),
          onPressed: null,
          tooltip: 'Move Player',
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.delete_forever,
          color: CSColors.delete,
        ),
        onPressed: last
            ? null
            : () {
                widget.bloc.game.gameState.deletePlayer(name);
                _reCalcSize();
              },
      ),
      title: Text(name),
    );
  }

  Widget editCurrentPlayer(String name, Widget textField) {
    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: cancel,
      ),
      title: textField,
      trailing: IconButton(
        icon: const Icon(Icons.check),
        onPressed: confirm,
      ),
    );
  }
}
