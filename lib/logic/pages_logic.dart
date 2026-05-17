import 'package:counter_spell/main.dart';
import 'package:counter_spell/models/pages.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

extension PagesLogicFromContext on BuildContext {
  PagesLogic get pagesLogic => counterSpell.pagesLogic;
}

class PagesLogic extends LogicBase {
  static PagesLogic of(BuildContext context) => context.provide<PagesLogic>();

  final Reactive<BodyPage> bodyPage = Reactive(BodyPage.life);
  final Reactive<PanelPage> panelPage = Reactive(PanelPage.game);

  @override
  void dispose() {
    bodyPage.dispose();
    panelPage.dispose();
    super.dispose();
  }
}
