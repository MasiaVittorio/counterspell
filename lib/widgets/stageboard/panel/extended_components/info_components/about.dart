import 'package:counter_spell_new/core.dart';


class AboutCounterSpell extends StatelessWidget {

  const AboutCounterSpell();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    
    return Section([
      const AlertTitle("About CounterSpell", centered: false,),
      Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        child: Row(children: <Widget>[
          Expanded(child: ExtraButton(
            icon: Icons.person_outline,
            text: "The developer",
            onTap: () => stage.showAlert(const Developer(), size: Developer.height),
          )),
          Expanded(child: ExtraButton(
            icon: McIcons.file_document_box_check_outline,
            text: "Licenses",
            onTap: () => stage.showAlert(const AlertLicenses(), size: DamageInfo.height),
          )),
          Expanded(child: ExtraButton(
            icon: McIcons.file_document_outline,
            text: "Changelog",
            onTap: () => stage.showAlert(const Changelog(), size: Changelog.height),
          )),
        ].separateWith(CSWidgets.extraButtonsDivider),),
      ),
      CSWidgets.divider,
      ListTile(
        title: const Text("Tutorial"),
        leading: const Icon(Icons.help_outline),
        onTap: () => stage.showAlert(const TutorialAlert(), size: TutorialAlert.height),
      ),
    ]);
  }
}