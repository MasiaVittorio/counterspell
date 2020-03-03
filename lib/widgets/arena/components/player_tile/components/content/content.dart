import 'package:counter_spell_new/core.dart';
import 'package:counter_spell_new/widgets/arena/arena_widget.dart';
import 'components/all.dart';

class AptContent extends StatelessWidget {

  AptContent({
    @required this.name,
    @required this.pageColors,
    @required this.buttonAlignment,
    @required this.constraints,
    @required this.bloc,
    @required this.rawSelected,
    @required this.highlighted,
    @required this.isScrollingSomewhere,
    @required this.gameState,
    @required this.increment,
  });

  //Business Logic
  final CSBloc bloc;

  //Actual Game State
  final GameState gameState;
  final String name;

  //Interaction information
  final bool isScrollingSomewhere;
  final bool highlighted;
  final int increment;
  final bool rawSelected;
  //TODO: attacca / difendi

  //Theming
  final Map<CSPage,Color> pageColors;

  //Layout information
  final BoxConstraints constraints;
  final Alignment buttonAlignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: Row(
        children: leftButton 
          ? <Widget>[info, expandedBody]
          : <Widget>[expandedBody, info],
      ),
    );
  }

  bool get leftButton => (buttonAlignment?.x ?? 0) < 0;
  bool get rightInfo => leftButton;

  Widget get expandedBody => Expanded(child: body,);

  Widget get body => Column(children: <Widget>[
    if(buttonOnTop) SizedBox(height: ArenaWidget.buttonSize.height/2),
    Expanded(child: Center(child: number,),),
    nameAndRole,
  ],);

  bool get buttonOnTop => buttonAlignment != null;

  Widget get number {
    final playerState = gameState.players[name].states.last;
    final bool scrolling = highlighted && isScrollingSomewhere;
    return APTNumber(
      rawSelected: rawSelected,
      scrolling: scrolling,
      increment: this.increment,
      playerState: playerState,
      constraints: this.constraints,
    );
  }

  Widget get nameAndRole => Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: rightInfo 
      ? MainAxisAlignment.start
      : MainAxisAlignment.end,
    children: rightInfo 
      ? <Widget>[role, nameWidget]
      : <Widget>[nameWidget, role],
  );

  Widget get nameWidget => bloc.settings.arenaHideNameWhenImages.build((_, hideNameWithImage){
    if(hideNameWithImage){
      final bool thereIsCard = bloc.game.gameGroup.cards(
        !this.gameState.players[name].usePartnerB,
      ).value[name] != null;
      
      if(thereIsCard) return SizedBox();
    }
    return Text("$name", style: const TextStyle(fontSize: 16),);
  },);

  Widget get role => AptRole(
    name: this.name,
    rawSelected: this.rawSelected,
    actionBloc: this.bloc.game.gameAction,
    pageColors: this.pageColors,
  );

  Widget get info => AptInfo(
    gameState: this.gameState,
    bloc: this.bloc,
    name: this.name,
    pageColors: this.pageColors,
  );

}