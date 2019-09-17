import 'package:counter_spell_new/blocs/bloc.dart';
import 'package:counter_spell_new/structure/counterspell_widget_keys.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/widgets/scaffold/scaffold_components.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/bloc/bloc.dart';
import 'package:sidereus/reusable_widgets/sidereus_app/sidereus_app.dart';


class CSHomePage extends StatefulWidget {
  const CSHomePage({
    Key key,
  }) : super(key: key);

  @override
  _CSHomePageState createState() => _CSHomePageState();

  static const _panelThreshold = 0.5;
}

class _CSHomePageState extends State<CSHomePage> {

  SidController controller;
  CSBloc bloc;
 
  @override
  void initState() {
    controller = SidController();
    bloc = CSBloc.of(context);
    bloc.scaffold.controller = controller;

    super.initState();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      if(!controller.isPanelClosed()){
        controller.close();
        return false;
      }
      if(bloc.game.gameAction.actionPending){
        bloc.scroller.cancel();
        return false;
      }
      if(bloc.scaffold.currentPage != CSPage.life){
        bloc.scaffold.goToPage(CSPage.life);
        return false;
      }

      return true;
    },
    child: bloc.scaffold.dimensions.build((_, dim) 
      => SidereusApp(
        backdropColor: Theme.of(context).scaffoldBackgroundColor,
        backdropOpacity: 0.8,
        controller: controller,
        dimensions: dim,
        onPanelSlide: (value) => onPanelSlide(bloc,value),

        body: const CSBody(key: KEY_BODY),

        collapsedPanel: const CSPanelCollapsed(key: KEY_COLLAPSED), 

        panel: const CSPanelExtended(key: KEY_EXTENDED_PANEL),

        closedBottomBar: const CSBottomBarCollapsed(key: KEY_CLOSED_BAR),

        openedBottomBar: const CSBottomBarExtended(key: KEY_OPENED_BOTTOM_BAR),

        floatingActionButton: const CSFab(key: KEY_FAB),

        topBarBuilder: ({position, size, dragUpdate, dragEnd, menuButton, dimensions})
          => bloc.themer.animatedCurrentWidget(child: CSTopBar(
            position: position,
            size: size,
            dragEnd: dragEnd,
            dragUpdate: dragUpdate,
            menuButton: menuButton,
            dimensions: dimensions,
          )),
      ),
    ),
  );
 

  void onPanelSlide(CSBloc bloc, double value){
    final BlocVar<bool> _var = bloc.scaffold.isPanelMostlyOpen;
    if(value > CSHomePage._panelThreshold){
      if(!_var.value){
        _var.set(true);
      }
    }
    else{
      if(_var.value)
        _var.set(false);
    }
  }
}

