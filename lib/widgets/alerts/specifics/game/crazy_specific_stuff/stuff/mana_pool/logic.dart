import 'package:counter_spell_new/core.dart';


class MPLogic {

  bool mounted;

  PersistentVar<Map<Clr,bool>> show; 
  PersistentVar<List<ManaAction>> history; 

  CSScroller localScroller;

  BlocVar<int> delta;
  BlocVar<Clr> selected; 

  ManaAction get currentAction => ManaAction(
    delta: delta.value, 
    color: selected.value,
  );

  BlocVar<Map<Clr,int>> pool;

  void dispose() {
    mounted = false;
    show?.dispose();
    history?.dispose();
    localScroller?.dispose();
    delta?.dispose();
    selected?.dispose();
    pool?.dispose();
  }

  MPLogic(CSBloc parentBloc) {
    mounted = true;
    localScroller = CSScroller(parentBloc, overrideOnConfirm: (v){
      if(!mounted) return;
      delta.value += v;
      delta.refresh();
    });
    delta = BlocVar<int>(0);
    show = PersistentVar<Map<Clr,bool>>(
      key: "mana_pool_state: show map",
      initVal: <Clr, bool>{
        Clr.w: true,
        Clr.u: true,
        Clr.b: true,
        Clr.r: true,
        Clr.g: true,
      },
      fromJson: (j) => <Clr,bool>{
        for(final e in (j as Map<String,bool>).entries)
          Clrs.fromName(e.key): e.value,
      },
      toJson: (v) => <String,bool>{
        for(final e in v.entries)
          e.key.name: e.value,
      },
    );
    history = PersistentVar<List<ManaAction>>(
      key: "mana_pool_state: history list",
      initVal: <ManaAction>[],
      fromJson: (j) => <ManaAction>[
        for(final jv in j)
          ManaAction.fromJson(jv),
      ],
      toJson: (l) => <Map<String,dynamic>>[
        for(final lv in l)
          lv.toJson,
      ],
    );
    pool = BlocVar<Map<Clr,int>>(<Clr,int>{
      for(final v in Clr.values)
        v: 0,
    });
  }

  void apply(ManaAction action){
    pool.value[action.color] += action.delta;
    if(pool.value[action.color] < 0)
      pool.value[action.color] = 0;
    pool.refresh();
    delta.set(0);

    if(history.value.contains(action)){
      history.value.remove(action);
    }
    if(history.value.length >= 4){
      history.value.removeAt(0);
    }
    history.value.add(action);
    history.refresh();
  }


}




enum Clr {w,u,b,r,g}
extension on Clr {
  static const _map = {
    Clr.w: "w",
    Clr.u: "u",
    Clr.b: "b",
    Clr.r: "r",
    Clr.g: "g",
  };
  String get name => _map[this]; 
}
class Clrs {
  static const _map = {
    "w": Clr.w,
    "u": Clr.u,
    "b": Clr.b,
    "r": Clr.r,
    "g": Clr.g,
  };
  static Clr fromName(String name) => _map[name];
}

class ManaAction {

  final int delta;
  final Clr color;

  const ManaAction({
    @required this.delta,
    @required this.color,
  });

  Map<String,dynamic> get toJson => <String,dynamic>{
    "delta": delta,
    "color": color.name,
  };

  static ManaAction fromJson(Map<String,dynamic> json) => ManaAction(
    delta: json["delta"],
    color: Clrs.fromName(json["color"]),
  );

  @override
  operator ==(Object other){
    if (other is ManaAction){
      if(other.delta != delta) return false;
      if(other.color != color) return false;
      return true;
    } else return false;
  }

  @override 
  int get hashCode => this.toJson.hashCode;

}
