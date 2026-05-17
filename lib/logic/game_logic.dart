import 'package:counter_spell/logic/cards_logic.dart';
import 'package:counter_spell/logic/playgroup_logic.dart';
import 'package:counter_spell/models/game/game.dart';
import 'package:counter_spell/models/game/game_state.dart';
import 'package:counter_spell/widgets/body/history_view/animated_action_column.dart';
import 'package:flutter/widgets.dart';
import 'package:sid_base/sid_base.dart';

class GameLogic extends LogicBase {
  final startingLifeTotal = PersistentReactive<int>(40, key: 'startingLife');
  final deltas = Reactive<List<GameStateDelta>>([]);

  final PersistentReactive<Game> _game = PersistentReactive<Game>(
    Game.start(
      startingLifeTotal: 40,
      playerNames: ['Vittorio', 'Giorgio', 'Chicco', 'Marcello'],
      pastGameSettings: null,
    ),
    key: 'game',
    toJsonEncodable: (value) => value.toMap(),
    fromJsonDecoded: (jsonDecoded) => Game.fromMap(jsonDecoded),
  );

  @override
  void dispose() {
    _game.dispose();
    deltas.dispose();
    startingLifeTotal.dispose();
    super.dispose();
  }

  final CardsLogic cardsLogic;

  GameLogic(this.cardsLogic);

  void newGame({
    required List<String> names,
    required PlaygroupLogic playgroupLogic,
  }) {
    if (names.isEmpty) return;
    playgroupLogic.recordPlaygroup(_game.value);
    deltas.value.clear();
    deltas.refresh();
    _game.update(
      Game.start(
        startingLifeTotal: startingLifeTotal.value,
        playerNames: names,
        pastGameSettings: _game.value.settings,
      ),
    );
  }

  static final GlobalKey<AnimatedListState> historyListKey =
      GlobalKey<AnimatedListState>();

  void back() {
    final finalState = _game.value.currentState.deepCopy();
    final result = _game.value.back();
    _game.update(result.game);
    deltas.value.add(result.gameStateDelta);
    historyListKey.currentState?.removeItem(
      0,
      (context, animation) => AnimatedActionColumn.fake(
        animation: animation,
        action: result.gameStateDelta,
        finalGameState: finalState,
        index: 0,
        gameSettings: _game.value.settings,
      ),
    );
    deltas.refresh();
  }

  void forward() {
    if (deltas.value.isEmpty) return;
    _game.update(_game.value.forward(deltas.value.removeLast()));
    historyListKey.currentState?.insertItem(0);
    deltas.refresh();
  }

  Game readGame() => _game.value;

  void addGameListener(VoidCallback listener) => _game.addListener(listener);
  void removeGameListener(VoidCallback listener) =>
      _game.removeListener(listener);

  void editGame(Game Function(Game game) editor) {
    final newValue = editor(_game.value);
    if (newValue.gameStates.length > _game.value.gameStates.length) {
      historyListKey.currentState?.insertItem(0);
    }
    _game.update(newValue);
    deltas.value.clear();
    deltas.refresh();
  }

  void cancelPastAction(int pastIndex) {
    final result = _game.value.cancelPastAction(pastIndex);
    _game.value = result.game;
    _game.refresh();
    final cancelledAction = result.cancelledAction;
    if (cancelledAction == null) return;
    final actionResult = result.actionResult;
    if (actionResult == null) return;
    historyListKey.currentState?.removeItem(
      pastIndex,
      (context, animation) => AnimatedActionColumn.fake(
        animation: animation,
        action: cancelledAction,
        index: pastIndex,
        finalGameState: actionResult,
        gameSettings: _game.value.settings,
      ),
    );
  }

  void mergePastAction(int pastIndex) {
    final result = _game.value.removePartialState(
      _game.value.gameStates.length - 2 - pastIndex,
    );
    _game.value = result.game;
    _game.refresh();
    final removedAction = result.removedAction;
    if (removedAction == null) return;
    final actionResult = result.actionResult;
    if (actionResult == null) return;
    historyListKey.currentState?.removeItem(
      pastIndex + 1,
      (context, animation) => AnimatedActionColumn.fake(
        animation: animation,
        action: removedAction,
        index: pastIndex + 1,
        finalGameState: actionResult,
        gameSettings: _game.value.settings,
      ),
    );
  }

  Widget buildWithGame(
    Widget Function(BuildContext context, Game game) builder,
  ) {
    return _game.build(builder);
  }

  PersistentReactive<Game> get gameReactive => _game;
}
