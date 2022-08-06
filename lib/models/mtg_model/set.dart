// To parse this JSON data, do
//
//     final mtgSet = mtgSetFromJson(jsonString);

import 'dart:convert';

MtgSet mtgSetFromJson(String str) {
    final jsonData = json.decode(str);
    return MtgSet.fromJson(jsonData);
}

String mtgSetToJson(MtgSet data) {
    final dyn = data.toJson();
    return json.encode(dyn);
}

class MtgSet {
    String? object;
    String? id;
    String? code;
    String? mtgoCode;
    int? tcgplayerId;
    String? name;
    String? uri;
    String? scryfallUri;
    String? searchUri;
    String? releasedAt;
    String? setType;
    int? cardCount;
    bool? digital;
    bool? foilOnly;
    String? blockCode;
    String? block;
    String? iconSvgUri;

    MtgSet({
        this.object,
        this.id,
        this.code,
        this.mtgoCode,
        this.tcgplayerId,
        this.name,
        this.uri,
        this.scryfallUri,
        this.searchUri,
        this.releasedAt,
        this.setType,
        this.cardCount,
        this.digital,
        this.foilOnly,
        this.blockCode,
        this.block,
        this.iconSvgUri,
    });

    factory MtgSet.fromJson(Map<String, dynamic> json) => MtgSet(
        object: json["object"],
        id: json["id"],
        code: json["code"],
        mtgoCode: json["mtgo_code"],
        tcgplayerId: json["tcgplayer_id"],
        name: json["name"],
        uri: json["uri"],
        scryfallUri: json["scryfall_uri"],
        searchUri: json["search_uri"],
        releasedAt: json["released_at"],
        setType: json["set_type"],
        cardCount: json["card_count"],
        digital: json["digital"],
        foilOnly: json["foil_only"],
        blockCode: json["block_code"],
        block: json["block"],
        iconSvgUri: json["icon_svg_uri"],
    );

    Map<String, dynamic> toJson() => {
        "object": object,
        "id": id,
        "code": code,
        "mtgo_code": mtgoCode,
        "tcgplayer_id": tcgplayerId,
        "name": name,
        "uri": uri,
        "scryfall_uri": scryfallUri,
        "search_uri": searchUri,
        "released_at": releasedAt,
        "set_type": setType,
        "card_count": cardCount,
        "digital": digital,
        "foil_only": foilOnly,
        "block_code": blockCode,
        "block": block,
        "icon_svg_uri": iconSvgUri,
    };
}
