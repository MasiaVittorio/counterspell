

class CommanderSettings {
  //==============================
  // Values
  final bool lifelink;
  final bool damageDefendersLife;
  final bool infect;

  //==============================
  // Constructor
  const CommanderSettings({
    required this.lifelink,
    required this.damageDefendersLife,
    required this.infect,
  }): assert(!(damageDefendersLife && infect));

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
    bool? lifelink,
    bool? damageDefendersLife,
    bool? infect,
  }) => CommanderSettings(
    lifelink: lifelink ?? this.lifelink,
    damageDefendersLife: damageDefendersLife ?? this.damageDefendersLife,
    infect: infect ?? this.infect,
  );

  CommanderSettings toggleDamageDefendersLife() => copyWith(
    damageDefendersLife: !damageDefendersLife,
    infect: (!damageDefendersLife) ? false : null,
  );
  CommanderSettings toggleInfect() => copyWith(
    infect: !infect,
    damageDefendersLife: (!infect) ? false : null,
  );
  CommanderSettings toggleLifelink() => copyWith(
    lifelink: !lifelink,
  );


  //==============================
  // Persistence
  Map<String,dynamic> toJson() => <String,dynamic>{
    "lifelink": lifelink,
    "damageDefendersLife": damageDefendersLife,
    "infect": infect,
  };

  static CommanderSettings fromJson(Map<String,dynamic> json) => CommanderSettings(
    lifelink: json["lifelink"], 
    damageDefendersLife: json["damageDefendersLife"], 
    infect: json["infect"],
  );
}