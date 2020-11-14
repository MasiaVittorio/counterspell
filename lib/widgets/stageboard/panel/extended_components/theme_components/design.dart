import 'package:counter_spell_new/core.dart';


class DesignPatterns extends StatelessWidget {

  const DesignPatterns();

  @override
  Widget build(BuildContext context) {
    final stage = Stage.of(context);
    final bloc = CSBloc.of(context);
    final theme = Theme.of(context);
    final placeVar = stage.themeController.colorPlace;
    final themer = bloc.themer;
    final pageColorsVar = stage.themeController.derived.mainPageToPrimaryColor;
    final color = theme.accentColor;
    // Color.alphaBlend(
    //   theme.colorScheme.onSurface.withOpacity(0.1), 
    //   theme.canvasColor,
    // );


    return bloc.payments.unlocked.build((_, unlocked)
      => Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Section([
            // placeVar.build((_, val) => SwitchListTile(
            //   value: val.isTexts, 
            //   onChanged: (_) => themer.toggleGoogleLikeColors(),
            //   title: const Text("Google-like colors"),
            //   subtitle: AnimatedText(val.isTexts
            //     ? "Colored text"
            //     : "Colored background"
            //   ),
            //   secondary: Icon(val.isTexts 
            //     ? McIcons.alpha_a_box_outline
            //     : McIcons.alpha_a_box
            //   ),
            // ),),
            // if(!CSThemer.flatLinkedToColorPlace)
            // themer.flatDesign.build((context, val) => SwitchListTile(
            //   value: val,
            //   onChanged: (_) => themer.toggleFlatDesign(),
            //   title: const Text("Flat design"),
            //   subtitle: const Text("Over material"),
            //   secondary: Icon(val
            //     ? McIcons.rounded_corner
            //     : McIcons.android_studio
            //   ),
            // )),
            Row(children: [
              Expanded(child: placeVar.build((_, place) => SubSection(
                <Widget>[
                  const SectionTitle("Color Place"),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 4.0,
                    ),
                    child: pageColorsVar.build((_, pages) 
                      => themer.flatDesign.build((_, flat) => Material(
                        color: place.isTexts 
                          ? theme.canvasColor
                          : pages[CSPage.life],
                        borderRadius: BorderRadius.circular(
                          10,
                          // flat ? 10 : 0,
                        ),
                        elevation: flat ? 0 : 6,
                        child: Container(
                          alignment: Alignment.center,
                          height: 38.0,
                          width: 38.0,
                          child: IconTheme(
                            data: IconThemeData(
                              opacity: 1.0,
                              color: place.isTexts 
                                ? pages[CSPage.life]
                                : pages[CSPage.life].contrast, 
                            ),
                            child: const Icon(CSIcons.castIconFilled),
                          ),
                        ),
                      ),
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 3.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 24,
                      child: AnimatedText(
                        place.isTexts ? "Text" : "Background",
                      ),
                    ),
                  ),
                ], 
                crossAxisAlignment: CrossAxisAlignment.center,
                onTap: themer.toggleGoogleLikeColors,
                margin: EdgeInsets.zero,
                color: false,
              ),),),

              CSWidgets.extraButtonsDivider, 

              Expanded(child: themer.flatDesign.build((_, flat) => SubSection(
                <Widget>[
                  const SectionTitle("Design"),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 4.0,
                    ),
                    child: pageColorsVar.build((_, pages) 
                      => Material(
                        color: color,
                        borderRadius: BorderRadius.circular(
                          // flat ? 10 : 0,
                          10
                        ),
                        elevation: flat ? 0 : 6,
                        child: Container(
                          alignment: Alignment.center,
                          height: 38.0,
                          width: 38.0,
                          child: Icon(
                            McIcons.android_studio,
                            color: color.contrast,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 3.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 24,
                      child: AnimatedText(
                        flat ? "Flat" : "Solid",
                      ),
                    ),
                  ),
                ], 
                crossAxisAlignment: CrossAxisAlignment.center,
                onTap: themer.toggleFlatDesign,
                margin: EdgeInsets.zero,
                color: false,
              ),),),

            ],),

          ]),

          if(!unlocked) Positioned.fill(child: GestureDetector(
            onTap: () => stage.showAlert(const SupportAlert(), size: SupportAlert.height),
            child: Container(
              color: theme.scaffoldBackgroundColor
                  .withOpacity(0.5),
            ),
          ),),
        ],
      ),
    );
  }
}