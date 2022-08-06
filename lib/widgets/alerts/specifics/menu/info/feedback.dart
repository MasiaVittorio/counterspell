import 'package:counter_spell_new/core.dart';

class FeedbackAlert extends StatelessWidget {

  const FeedbackAlert();
  
  static const double height = AlternativesAlert.tileSize * 2 + PanelTitle.twoLinesHeight; 

  @override
  Widget build(BuildContext context) {
    return AlternativesAlert(
      label: "Seems like you used CounterSpell for a while, how do you feel about it?",
      twoLinesLabel: true,
      alternatives: [
        Alternative(
          title: "I love it!",
          icon: McIcons.thumb_up_outline,
          action: () => Stage.of(context)!.showAlert(
            PositiveFeedback(), 
            size: PositiveFeedback.height,
          ),
          color: Colors.blue,
        ),
        Alternative(
          title: "Meh, it has some issues...",
          icon: McIcons.thumb_down_outline,
          action: () => Stage.of(context)!.showAlert(
            NegativeFeedback(), 
            size: NegativeFeedback.height,
          ),
          color: CSColors.delete,
        ),
      ],
    );
  }
}

class PositiveFeedback extends StatelessWidget {

  static const double height = AlternativesAlert.tileSize * 3 + PanelTitle.height; 

  @override
  Widget build(BuildContext context) {
    final StageData? stage = Stage.of(context);
    return AlternativesAlert(
      label: "Glad to hear that! Maybe you can help me out :)",
      twoLinesLabel: false,
      alternatives: [
        const Alternative(
          title: "Rate CounterSpell",
          icon: Icons.star_border,
          action: CSActions.review,
        ),
        Alternative(
          title: "Support the development",
          icon: Icons.attach_money,
          autoClose: false,
          action: () => stage!.showAlert(const SupportAlert(), size: SupportAlert.height),
        ),
        Alternative(
          title: "Share your ideas",
          icon: McIcons.telegram,
          action: () => stage!.showAlert(const ConfirmTelegram(), size: ConfirmTelegram.height),
        ),
      ],
    );
  }
}

class NegativeFeedback extends StatelessWidget {

  static const double height = AlternativesAlert.tileSize * 2 + PanelTitle.height; 

  @override
  Widget build(BuildContext context) {
    final StageData? stage = Stage.of(context);
    return AlternativesAlert(
      label: "Let me know how I can improve!",
      twoLinesLabel: false,
      alternatives: [
        Alternative(
          title: "Send feedback",
          icon: Icons.mail_outline,
          action: () => stage!.showAlert(const ConfirmEmail(), size: ConfirmEmail.height),
        ),
        Alternative(
          title: "Get in touch in real time",
          icon: McIcons.telegram,
          action: () => stage!.showAlert(const ConfirmTelegram(), size: ConfirmTelegram.height),
          autoClose: false,
        ),
      ],
    );
  }
}