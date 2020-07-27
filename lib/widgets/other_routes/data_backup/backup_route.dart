import 'package:flutter/material.dart';
import 'package:counter_spell_new/models/ui_model/colors/colors.dart';
import 'package:flutter/services.dart';
import 'package:stage/stage.dart';

import 'body.dart';

enum BackupPage {
  save,
  load,
}

class BackupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Stage<BackupPage,dynamic>(
      stageTheme: StageThemeData.nullable(
        colors: StageColorsData.nullable(
          lightMainPrimary: CSColors.primary,
          lightPanelPrimary: CSColors.primary,
        ),
        brightness: StageBrightnessData.nullable(
          brightness: Brightness.light,
          autoDark: false,
        ),
      ),
      body: const BackupBody(),
      extendedPanel: const _BackupPanel(),
      topBarData: StageTopBarData(
        title: const Text("Backup & Restore"),
      ),
      collapsedPanel: const _Collapsed(),
      mainPages: StagePagesData<BackupPage>.nullable(
        defaultPage: BackupPage.save,
        orderedPages: BackupPage.values,
        pagesData: <BackupPage,StagePage>{
          BackupPage.save: StagePage(
            icon: McIcons.content_save,
            unselectedIcon: McIcons.content_save_outline,
            name: "Save",
          ),
          BackupPage.load: StagePage(
            icon: McIcons.folder_open,
            unselectedIcon: McIcons.folder_open_outline,
            name: "Load",
          ),
        },
      ),
    );
  }
}


class _Collapsed extends StatelessWidget {
  const _Collapsed();

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const SizedBox(width: 56,),
      const Expanded(child: Center(child: AlertDrag()),),
      InkResponse(
        onTap: Stage.of(context).openPanel,
        child: const SizedBox(
          width: StageDimensions.defaultCollapsedPanelSize,
          height: StageDimensions.defaultCollapsedPanelSize,
          child: Center(child: Icon(Icons.info_outline)),
        ),
      ),
    ]);
  }
}

class _BackupPanel extends StatelessWidget {
  const _BackupPanel();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox.expand(
        child: Align(
          alignment: Alignment.topCenter,
          child: ListView(
            primary: false,
            children: <Widget>[
              const PanelTitle("Info"),
              const ListTile(title: Text(
"""Some info""" 
              ),),
            ],
          ),
        ),
      ),
    );
  }
}