import 'package:counter_spell_new/core.dart';


class CommanderSettings {
  //==============================
  // Values
  final bool lifelink;
  final bool damageDefendersLife;
  final bool infect;

  //==============================
  // Constructor
  const CommanderSettings({
    @required this.lifelink,
    @required this.damageDefendersLife,
    @required this.infect,
  }): assert(lifelink != null),
      assert(damageDefendersLife != null),
      assert(infect != null),
      assert(!(damageDefendersLife && infect));

  //==============================
  // default
  static const CommanderSettings defaultSettings = CommanderSettings(
    damageDefendersLife: true,
    infect: false,
    lifelink: false,
  );
  static const CommanderSettings off = CommanderSettings(
    damageDefendersLife: false,
    infect: false,
    lifelink: false,
  );

  //==============================
  // Methods
  CommanderSettings copyWith({
    bool lifelink,
    bool damageDefendersLife,
    bool infect,
  }) => CommanderSettings(
    lifelink: lifelink ?? this.lifelink,
    damageDefendersLife: damageDefendersLife ?? this.damageDefendersLife,
    infect: infect ?? this.infect,
  );

  CommanderSettings toggleDamageDefendersLife() => this.copyWith(
    damageDefendersLife: !this.damageDefendersLife,
    infect: (!this.damageDefendersLife) ? false : null,
  );
  CommanderSettings toggleInfect() => this.copyWith(
    infect: !this.infect,
    damageDefendersLife: (!this.infect) ? false : null,
  );
  CommanderSettings toggleLifelink() => this.copyWith(
    lifelink: !this.lifelink,
  );


  //==============================
  // Persistence
  Map<String,dynamic> get toJson => <String,dynamic>{
    "lifelink": this.lifelink,
    "damageDefendersLife": this.damageDefendersLife,
    "infect": this.infect,
  };

  static CommanderSettings fromJson(Map<String,dynamic> json) => CommanderSettings(
    lifelink: json["lifelink"], 
    damageDefendersLife: json["damageDefendersLife"], 
    infect: json["infect"],
  );
}