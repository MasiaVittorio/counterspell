import 'package:counter_spell_new/business_logic/sub_blocs/scroller/scroller_generic.dart';
import 'package:counter_spell_new/core.dart';


class MPLogic {

  bool? mounted;

  late BlocVar<Map<Clr,bool>> show; 
  late BlocVar<List<ManaAction>> history; 

  late ScrollerLogic localScroller;

  late BlocVar<Clr?> selected; 

  ManaAction? get currentAction => selected.value == null 
    ? null
    : ManaAction(
    delta: localScroller.intValue.value, 
    color: selected.value!,
  );

  late BlocVar<Map<Clr,int>> pool;

  void dispose() {
    mounted = false;
    show.dispose();
    history.dispose();
    localScroller.dispose();
    selected.dispose();
    pool.dispose();
  }

  MPLogic(CSBloc parentBloc) {
    mounted = true;

    selected = BlocVar<Clr?>(null);
    
    localScroller = ScrollerLogic(
      okVibrate: () => parentBloc.settings.appSettings.canVibrate! 
        && parentBloc.settings.appSettings.wantVibrate.value,
      onCancel: (_, __){
        selected.set(null);
      },
      scrollSettings: parentBloc.settings.scrollSettings,
      resetAfterConfirm: true,
      onConfirm: (v){
        apply(currentAction);
      },
    );

    show = BlocVar(<Clr, bool>{
      for(final c in Clr.values)
        c: true,
    },);

    history = BlocVar(<ManaAction>[]);

    pool = BlocVar(<Clr,int>{
      for(final v in Clr.values)
        v: 0,
    });
  }

  void apply(ManaAction? action){
    if(action == null) return;
    pool.value[action.color] = pool.value[action.color]! + action.delta;
    if(pool.value[action.color]! < 0) {
      pool.value[action.color] = 0;
    }
    pool.refresh();

    if(action.delta != 0){
      if(history.value.contains(action)){
        return;
      }
      if(history.value.length >= 4){
        int deleteAt = 0;
        for(int i=0; i<history.value.length; ++i){
          if(!show.value[history.value[i].color]!) {
            deleteAt = i;
          }
        }
        history.value.removeAt(deleteAt);
      }
      history.value.add(action);
      history.refresh();
    }
  }

  void onPan(Clr color){
    if(selected.value == null){
      selected.set(color);
    } else {
      if(selected.value != color){
        if(localScroller.isScrolling.value) {
          apply(currentAction);
        }
        selected.set(color);
      } 
    }
  }

}




enum Clr {w,u,b,r,g,c} ///+ colorless
extension ClrExt on Clr {

  String get name => const <Clr,String>{
    Clr.w: "w",
    Clr.u: "u",
    Clr.b: "b",
    Clr.r: "r",
    Clr.g: "g",
    Clr.c: "c",
  }[this]!; 

  Color get color => const <Clr,Color>{
    Clr.w: Color(0xFFfffbd6),
    Clr.u: Color(0xFFaae0fa),
    Clr.b: Color(0xFFccc3c1),
    Clr.r: Color(0xFFf9aa8f),
    Clr.g: Color(0xFF9bd3af),
    Clr.c: Color(0xFFd5cece),
  }[this]!;

  IconData? get icon => const <Clr,IconData>{
    Clr.w: ManaIcons.w,
    Clr.u: ManaIcons.u,
    Clr.b: ManaIcons.b,
    Clr.r: ManaIcons.r,
    Clr.g: ManaIcons.g,
    Clr.c: ManaIcons.c,
  }[this];

}
class Clrs {
  static Clr? fromName(String? name) => const <String,Clr>{
    "w": Clr.w,
    "u": Clr.u,
    "b": Clr.b,
    "r": Clr.r,
    "g": Clr.g,
    "c": Clr.c,
  }[name ?? ''];
}

class ManaAction {

  final int delta;
  final Clr color;

  const ManaAction({
    required this.delta,
    required this.color,
  });

  Map<String,dynamic> get toJson => <String,dynamic>{
    "delta": delta,
    "color": color.name,
  };

  static ManaAction fromJson(Map<String,dynamic> json) => ManaAction(
    delta: json["delta"],
    color: Clrs.fromName(json["color"])!,
  );

  @override
  operator ==(Object other){
    if (other is ManaAction){
      if(other.delta != delta) return false;
      if(other.color != color) return false;
      return true;
    } else {
      return false;
    }
  }

  @override 
  int get hashCode => toJson.hashCode;

}
