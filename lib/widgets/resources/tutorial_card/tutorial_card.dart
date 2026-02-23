import 'package:auto_size_text/auto_size_text.dart';
import 'package:counter_spell/core.dart';
import 'package:counter_spell/widgets/resources/highlightable/highlightable.dart';

class TutorialCards extends StatefulWidget {
  const TutorialCards({
    required this.hints,
    required this.logic,
    super.key,
  });

  final List<Hint> hints;
  final CSBloc logic;

  @override
  State<TutorialCards> createState() => TutorialCardsState();

  static const Hint first = Hint(
    text: "Scroll to see the tips, tap to end the tutorial",
    page: null,
    icon: HintIcon(McIcons.gesture_swipe_horizontal),
    selfHighlight: true,
  );

  static const Hint last = Hint(
    text: "Congratulations! You completed the tutorial",
    page: null,
    autoHighlight: TutorialCard.quit,
    repeatAuto: 1,
  );
}

class TutorialCardsState extends State<TutorialCards> {
  PageController? controller;
  late List<HighlightController?> highlights;

  @override
  void initState() {
    super.initState();
    initController();
    initHighlights();
  }

  void initController() {
    controller?.dispose();
    controller = PageController();
    widget.logic.tutorial.attach(() => this);
  }

  void initHighlights() {
    highlights = [
      for (final hint in widget.hints)
        if (hint.selfHighlight || hint.manualHighlight != null)
          HighlightController(hint.text)
        else
          null,
    ];
  }

  @override
  void didUpdateWidget(covariant TutorialCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    initHighlights();
    bool? update;
    if (oldWidget.hints.length != widget.hints.length) {
      update = true;
    } else {
      for (int i = 0; i < oldWidget.hints.length; i++) {
        if (oldWidget.hints[i].text == widget.hints[i].text) {
          update = true;
          break;
        }
      }
    }
    update ??= false;
    if (update == true) {
      initController();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void handle(int i, CSBloc logic) async {
    if (!widget.hints.checkIndex(i)) {
      return;
    }
    final hint = widget.hints[i];

    logic.tutorial.handle(hint, highlights[i], i);
  }

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    return PageView.builder(
      physics: const BouncingScrollPhysics(),
      controller: controller,
      itemCount: widget.hints.length,
      onPageChanged: (i) {
        if (widget.hints.checkIndex(i)) {
          handle(i, logic);
        }
      },
      itemBuilder: (_, i) => TutorialCard(
        hint: widget.hints[i],
        controller: highlights[i],
      ),
    );
  }
}

class TutorialCard extends StatelessWidget {
  const TutorialCard({
    required this.hint,
    required this.controller,
    super.key,
  });

  final Hint hint;
  final HighlightController? controller;

  @override
  Widget build(BuildContext context) {
    final logic = CSBloc.of(context);
    final stage = Stage.of(context)!;
    return StageBuild.offMainPage<CSPage>(
      (_, page) => StageBuild.offMainColors<CSPage>(
        (_, color, colors) {
          final Color background = hint.getCustomColor?.call(logic) ??
              (hint.page == null ? color : colors![hint.page]!);
          final Color contrast = background.contrast;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Material(
              elevation: 12,
              borderRadius: BorderRadius.circular(12),
              color: background,
              child: IconTheme(
                data: IconTheme.of(context).copyWith(color: contrast),
                child: DefaultTextStyle(
                  style: DefaultTextStyle.of(context).style.copyWith(
                        color: contrast,
                      ),
                  child: hint.selfHighlight
                      ? Highlightable(
                          borderRadius: 12,
                          controller: controller!,
                          child: materialContent(stage, logic, contrast),
                        )
                      : materialContent(stage, logic, contrast),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Future<void> quit(CSBloc logic) async {
    final stage = logic.stage;
    logic.tutorial.quitTutorial();
    await Future.delayed(const Duration(milliseconds: 500));
    await stage.closePanelCompletely();
    stage.openPanel();
    await Future.delayed(const Duration(milliseconds: 500));
    stage.panelPagesController!.goToPage(SettingsPage.info);
    await Future.delayed(const Duration(milliseconds: 500));
    logic.tutorial.tutorialHighlight.launch();
  }

  Widget materialContent(
    StageData stage,
    CSBloc logic,
    Color contrast,
  ) =>
      InkWell(
        onTap: () => stage.showAlert(
          ConfirmAlert(
            action: () => quit(logic),
            autoCloseAfterConfirm: false,
            warningText: "Quit tutorial?",
            confirmColor: CSColors.delete,
            confirmIcon: Icons.close,
            confirmText: "Yes, I'll figure it out",
          ),
          size: ConfirmAlert.height,
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Expanded(
                child: row(contrast),
              ),
              if (hint.manualHighlight != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: manual(contrast, logic),
                ),
            ],
          ),
        ),
      );

  Widget row(Color contrast) => Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: AutoSizeText(
                hint.text,
                minFontSize: 6,
                // maxLines: hint.manualHighlight != null ? 2 : 3,
                style: TextStyle(
                  color: contrast,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (hint.icon != null)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: hint.icon,
            ),
        ],
      );

  Widget manual(Color contrast, CSBloc logic) => Material(
        color: contrast.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: Highlightable(
          controller: controller!,
          borderRadius: 10,
          brightness: contrast.brightness.opposite,
          child: InkWell(
            onTap: () => hint.manualHighlight!(logic),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 14,
              ),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                "Show me",
                textAlign: TextAlign.center,
                style: TextStyle(color: contrast),
              ),
            ),
          ),
        ),
      );
}
