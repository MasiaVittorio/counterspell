import 'package:counter_spell_new/models/game/types/type_ui.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/preset_themes.dart';
import 'package:sidereus/reusable_widgets/stageboard/stage_board.dart';

import '../bloc.dart';

class CSStageBoard {

  void dispose(){
    controller.dispose();
  }

  final StageBoardData<CSPage,dynamic> controller = StageBoardData<CSPage,dynamic>(
      barSize: StageBoard.kBarSize,
      collapsedPanelSize: StageBoard.kBarSize,
      panelRadiusClosed: StageBoard.kBarSize/2,
      panelRadiusOpened: StageBoard.kPanelRadius,
      initialClosedPage: CSPage.life,
      initialClosedPagesData: <CSPage,StageBoardPageTheme>{
        for(final page in CSPage.values)
          page: StageBoardPageTheme(
            primaryColor: csDefaultThemesLight.values.first.pageColors[page],
            name: CSPAGE_TITLES_SHORT[page],
            longName: CSPAGE_TITLES_LONG[page],
            unselectedIcon: CSTypesUI.pageIconsOutlined[page],
            icon: CSTypesUI.pageIconsFilled[page],
          ),
      },
      decodePageClosed: (json) => STRING_TO_CSPAGE[json as String],
      encodePageClosed: (page) => CSPAGE_TO_STRING[page],
      initialClosedPagesList: CSPage.values,


      panelHorizontalPaddingClosed: StageBoard.kPanelHorizontalPaddingClosed,
      panelHorizontalPaddingOpened: StageBoard.kPanelHorizontalPaddingOpened,

      lastClosedPage: CSPage.life,
  );
  final CSBloc parent;
  CSStageBoard(this.parent);
}