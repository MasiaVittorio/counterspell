import 'package:counter_spell_new/core.dart';

class Developer extends StatelessWidget {

  const Developer();

  static const double height = 400;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        physics: Stage.of(context).panelScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Section([
              const AlertTitle("Who I am", centered: false),
              const ListTile(
                leading: Icon(Icons.school),
                title: Text("A Student attending a master's degree in physics"),
              ),
              const ListTile(
                leading: Icon(McIcons.visual_studio_code),
                title: Text("A guy who learned mobile development to make his own life counter"),
              ),
              const ListTile(
                leading: Icon(McIcons.xbox_controller),
                title: Text("A gamer with little time for his beloved Halo"),
              ),
              const ListTile(
                leading: Icon(McIcons.cards_outline),
                title: Text("A Magic player since time spiral, with little budget and too many commander decks"),
              ),
            ]),
            const Section([
              const SectionTitle("Who I want to be"),
              const ListTile(
                leading: Icon(Icons.school),
                title: Text("A teacher capable of making maths and physics look awesome"),
              ),
              const ListTile(
                leading: Icon(McIcons.visual_studio_code),
                title: Text("A freelance Flutter developer making tons of cross-platform apps"),
              ),
              const ListTile(
                leading: Icon(McIcons.xbox_controller),
                title: Text("A gamer with plenty of time for his split-screen sessions with the boys"),
              ),
              const ListTile(
                leading: Icon(McIcons.cards_outline),
                title: Text("A Magic player with a reasonable amount of decks"),
                subtitle: Text("(Ok that's not going to happen)", style: TextStyle(
                  fontStyle: FontStyle.italic
                )),
              ),
            ]),

            ListTile(
              title: Text("Contact me via e-mail"),
              leading: Icon(Icons.mail_outline),
              onTap: () => Stage.of(context).showAlert(ConfirmEmail(), size: ConfirmEmail.height),
            ),
          ],
        ),
      ),
    );
  }
}