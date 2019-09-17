import 'dart:math';

import 'package:counter_spell_new/blocs/sub_blocs/blocs.dart';
import 'package:counter_spell_new/widgets/resources/confirm_alert_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sidereus/sidereus.dart';

class CSBloc extends BlocBase {

  static CSBloc of(BuildContext context) => BlocProvider.of<CSBloc>(context);


  @override
  void dispose() {
    this.game.dispose();
    this.scaffold.dispose();
    this.scroller.dispose();
    this.settings.dispose();
    this.themer.dispose();
  }



  //=============================
  // Values 

  BuildContext context;

  SheetsBloc sheetsBloc;

  CSGame game;
  CSScaffold scaffold;
  CSScroller scroller;
  CSSettings settings;
  CSThemer themer;




  //=============================
  // Constructor 

  CSBloc(){
    sheetsBloc = SheetsBloc(this);
    game = CSGame(this);
    settings = CSSettings(this);
    ///[CSScaffold] must be initialized after [CSSettings]
    scaffold = CSScaffold(this);
    scroller = CSScroller(this);
    themer = CSThemer(this);
  }




  //=====================================
  // Getters

  double get bottomPadding => this._getBottomPadding();
  double _getBottomPadding(){
    final _mq = MediaQuery.of(this.context);
    return max(_mq.padding.bottom-8, 0);
  }




  //=====================================
  // Builders

  void buildSheet(
    Widget sheet, {
    bool resizeToAvoidBottomPadding = true, 
    Color materialColor = Colors.transparent,
    double verticalFrac = 9/16,
  }) => this.buildContextedSheet(
    sheet, 
    this.context, 
    materialColor: materialColor, 
    verticalFrac: verticalFrac, 
    resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,  
  );

  void buildContextedSheet(
    Widget sheet, BuildContext newContext, {
    bool resizeToAvoidBottomPadding = true, 
    Color materialColor = Colors.transparent, 
    double verticalFrac = 9/16,
  }) => 
    this.sheetsBloc.show(
      sheet: () => showModalBottomSheetApp<void>(
        avoidTop: AvoidTop.always,
        avoidOnlyIfNecessary: true,
        verticalFrac: verticalFrac ?? 9/16,
        landscapeVerticalFrac: 1,
        resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
        materialColor: materialColor,
        dismissOnTap: false,
        context: newContext,
        builder: (_) => sheet,
      )
    );

  void buildSheetTemp(
    Widget sheet, {
    bool resizeToAvoidBottomPadding = true, 
    Color materialColor = Colors.transparent,
    double verticalFrac = 9/16,
  }) => this.sheetsBloc.showTemporary(
    sheet: () => showModalBottomSheetApp<void>(
      avoidTop: AvoidTop.always,
      avoidOnlyIfNecessary: true,
      verticalFrac: verticalFrac ?? 9/16,
      landscapeVerticalFrac: 1,
      resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
      materialColor: materialColor,
      dismissOnTap: false,
      context: this.context,
      builder: (_) => sheet,
    ),
  );

  void confirmSheet({
    @required void Function() action,
    String warningText,
    Color confirmColor,
    String confirmText,
    IconData confirmIcon,
    Color cancelColor,
    String cancelText,
    IconData cancelIcon,
    bool autoPop = false,
  }){
    final Widget _sheet = ConfirmSheet(
      action: action,
      warningText: warningText,
      confirmColor: confirmColor,
      confirmIcon: confirmIcon,
      confirmText: confirmText,
      cancelColor: cancelColor,
      cancelIcon: cancelIcon,
      cancelText: cancelText,
      bottomPadding: this.bottomPadding,
      autoPop: autoPop,
    );

    this.sheetsBloc.showTemporary(
      sheet: () => showModalBottomSheetApp<void>(
        verticalFrac: 9/16,
        landscapeVerticalFrac: 1,
        dismissOnTap: false,
        context: this.context,
        builder: (BuildContext context) => _sheet,
      ),
    );
  }


}
