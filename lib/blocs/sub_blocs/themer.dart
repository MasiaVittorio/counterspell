import 'package:counter_spell_new/models/game/types/counters.dart';
import 'package:counter_spell_new/models/game/types/damage_type.dart';
import 'package:counter_spell_new/models/game/types/type_ui.dart';
import 'package:counter_spell_new/structure/damage_types_to_pages.dart';
import 'package:counter_spell_new/structure/pages.dart';
import 'package:counter_spell_new/themes/cs_theme.dart';
import 'package:counter_spell_new/themes/my_durations.dart';
import 'package:counter_spell_new/themes/preset_themes.dart';
import 'package:flutter/material.dart';
import 'package:sidereus/reusable_widgets/material_color_picker/sheet_color_picker.dart';
import 'package:sidereus/sidereus.dart';

import '../bloc.dart';

class CSThemer {

  void dispose(){

  }

  //================================
  // Values
  final CSBloc parent;
  final PersistentSet<CSTheme> themeSet;
  final BlocVar<CSTheme> temporary;



  //================================
  // Getters

  CSTheme get currentTheme => themeSet.variable.value;
  bool get isSaved {
    if(temporary.value == null) return false;

    return temporary.value.isEqualTo(currentTheme);
  }




  //================================
  // Constructor
  CSThemer(this.parent): 
    themeSet = PersistentSet(
      key: "bloc_themer_blocvar_themeset",
      initList: [
        ...csDefaultThemesLight.values,
        ...csDefaultThemesDark.values,
      ],
      toJson: (list) => [
        for(final theme in list)
          theme.toJson(),
      ],
      fromJson: (jsonList) => [
        for(final json in jsonList)
          CSTheme.fromJson(json),
      ]
    ),
    temporary = BlocVar<CSTheme>(null);





  //=================================
  // Helper Functions

  static Widget _applyThemeAnimated(ThemeData theme, Widget child) 
    => DefaultTextStyle.merge(
      style: theme.textTheme.body1,
      child: ListTileTheme.merge(
        iconColor: theme.iconTheme.color,
        child: RadioSliderTheme(
          data: RadioSliderThemeData(
            selectedColor: RightContrast(theme).onCanvas,
          ),
          child: AnimatedTheme(
            duration: MyDurations.fast,
            data: theme,
            child: child,
          ),
        ),
      ),
    );
  static Widget applyTheme(ThemeData theme, Widget child) 
    => DefaultTextStyle(
      style: theme.textTheme.body1,
      child: RadioSliderTheme(
        data: RadioSliderThemeData(
          selectedColor: theme.brightness == Brightness.dark 
            ? theme.colorScheme.onSurface
            : RightContrast(theme).onCanvas,
        ),
        child: Theme(
          data: theme,
          child: ListTileTheme.merge(
            iconColor: theme.iconTheme.color,
            child: child,
          ),
        ),
      ),
    );




  //===================
  // Builder Functions
  //===================

  Widget currentWidget({
    Widget child,
    Widget Function(BuildContext, CSTheme) builder,
  }){
    assert(builder == null || child == null);
    assert(builder != null || child != null);

    if(child != null)
      return this._currentChild(child: child);
    else
      return this._currentBuilder(builder);
  }

  ///does not animate the changing theme
  Widget _currentChild({@required Widget child})
    => this.themeSet.build((context, themeVal)
      => applyTheme(themeVal.data, child),
    );
  ///does not animate the changing theme
  Widget _currentBuilder(Widget Function(BuildContext, CSTheme) builder)
    => this.themeSet.build((context, themeVal)
      => applyTheme(themeVal.data, Builder(
        builder: (context) => builder(context, themeVal)
      )),
    );



  //============================
  // Animated Builder Functions
  //============================

  Widget animatedCurrentWidget({
    Widget child,
    Widget Function(BuildContext, CSTheme) builder,
  }){
    assert(builder == null || child == null);
    assert(builder != null || child != null);

    if(child != null)
      return this._animatedCurrentChild(child: child);
    else
      return this._animatedCurrentBuilder(builder);
  }
  Widget _animatedCurrentChild({@required Widget child})
    => this.themeSet.build((context, themeVal)
      => _applyThemeAnimated(themeVal.data, child),
    );
  Widget _animatedCurrentBuilder(Widget Function(BuildContext, CSTheme) builder)
    => this.themeSet.build( (context, themeVal)
      => _applyThemeAnimated(themeVal.data, Builder(
        builder: (context) => builder(context, themeVal)
      )),
    );



  Widget animatedTemporaryWidget({
    Widget child,
    Widget Function(BuildContext, CSTheme) builder,
  }){
    assert(builder == null || child == null);
    assert(builder != null || child != null);

    if(child != null)
      return this._animatedTemporaryChild(child: child);
    else
      return this.animatedTemporaryBuilder(builder);
  }
  Widget _animatedTemporaryChild({@required Widget child})
    => this.temporary.build((context, tempThemeVal)
      => _applyThemeAnimated(tempThemeVal.data, child),
    );
  Widget animatedTemporaryBuilder(Widget Function(BuildContext, CSTheme) builder)
    => this.temporary.build((context, tempThemeVal)
      => _applyThemeAnimated(tempThemeVal.data, Builder(
        builder: (context) => builder(context, tempThemeVal)
      )),
    );


  Widget animatedTemporaryInformed(Widget Function(BuildContext, CSTheme, bool) builder)
    => BlocVar.build2(
      this.themeSet.variable,
      this.temporary,
      builder: (_, __, CSTheme tempThemeVal)
        => _applyThemeAnimated(tempThemeVal.data, Builder(
          builder: (themedContext) 
            => builder(themedContext, tempThemeVal, this.isSaved)
        )),
    );







  void _pop() => Navigator.pop(this.parent.context);



  void pickColor({
    Color initialColor, 
    @required void Function(Color color) onColor
  }){

    final Widget _sheet = SheetColorPicker(
      color: initialColor ?? Colors.red[500],
      onSubmitted: (Color c) {
        _pop();
        onColor(c);
      },
      bottomPadding: this.parent.bottomPadding,
      underscrollCallback: _pop,
    );

    this.parent.buildSheet(
      _sheet, 
      resizeToAvoidBottomPadding: false, 
      materialColor: Colors.transparent, 
    );
  }


  static Color getScreenColor({
    @required CSTheme theme, 
    @required CSPage page, 
    @required bool casting, 
    @required bool open,
  }){
      if(open){ //panel
        return theme.data.primaryColor;
      }
      if(page == CSPage.commander && !casting){
        return theme.commanderAttack;
      }
      return theme.pageColors[page];
  }

  static Color getHistoryChipColor({
    @required DamageType type,
    @required bool attack,
    @required CSTheme theme,
  }){
    if(type == DamageType.commanderDamage){
      return attack ? theme.commanderAttack : theme.commanderDefence;
    } else {
      return theme.pageColors[damageToPage[type]];
    }
  }

  static IconData getHistoryChangeIcon({
    @required CSTheme theme,
    @required DamageType type,
    @required bool attack,
    @required Map<String,Counter> counters,
    @required String counterName,
  }){
    if(type == DamageType.commanderDamage){
      return attack ? CSTypesUI.attackIconOne : CSTypesUI.defenceIconFilled;
    } else if (type == DamageType.counters){
      return counters[counterName].icon;
    } else {
      return CSTypesUI.typeIconsFilled[type];
    }
  }


  // void updateBrightness(){
  //   final platform = MediaQuery.platformBrightnessOf(parentBloc.context);
  //   if(autoDark.value == false) 
  //     return;

  //   if(timeOfDay.value == true){
  //     final now = DateTime.now();

  //     if(
  //       now.hour >= startOfDay.value 
  //       && 
  //       now.hour <= endOfDay.value   
  //     ){
  //       this.brightnessDark.setDistinct(false);
  //     }
  //     else {
  //       this.brightnessDark.setDistinct(true);
  //     }

  //   }

  //   else{ //system
  //     if(platform == Brightness.dark){
  //       this.brightnessDark.setDistinct(true);
  //     }
  //     else{
  //       this.brightnessDark.setDistinct(false);
  //     }
  //   }
  // }





}