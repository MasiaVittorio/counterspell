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
    String object;
    String id;
    String code;
    String mtgoCode;
    int tcgplayerId;
    String name;
    String uri;
    String scryfallUri;
    String searchUri;
    String releasedAt;
    String setType;
    int cardCount;
    bool digital;
    bool foilOnly;
    String blockCode;
    String block;
    String iconSvgUri;

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

    factory MtgSet.fromJson(Map<String, dynamic> json) => new MtgSet(
        object: json["object"] == null ? null : json["object"],
        id: json["id"] == null ? null : json["id"],
        code: json["code"] == null ? null : json["code"],
        mtgoCode: json["mtgo_code"] == null ? null : json["mtgo_code"],
        tcgplayerId: json["tcgplayer_id"] == null ? null : json["tcgplayer_id"],
        name: json["name"] == null ? null : json["name"],
        uri: json["uri"] == null ? null : json["uri"],
        scryfallUri: json["scryfall_uri"] == null ? null : json["scryfall_uri"],
        searchUri: json["search_uri"] == null ? null : json["search_uri"],
        releasedAt: json["released_at"] == null ? null : json["released_at"],
        setType: json["set_type"] == null ? null : json["set_type"],
        cardCount: json["card_count"] == null ? null : json["card_count"],
        digital: json["digital"] == null ? null : json["digital"],
        foilOnly: json["foil_only"] == null ? null : json["foil_only"],
        blockCode: json["block_code"] == null ? null : json["block_code"],
        block: json["block"] == null ? null : json["block"],
        iconSvgUri: json["icon_svg_uri"] == null ? null : json["icon_svg_uri"],
    );

    Map<String, dynamic> toJson() => {
        "object": object == null ? null : object,
        "id": id == null ? null : id,
        "code": code == null ? null : code,
        "mtgo_code": mtgoCode == null ? null : mtgoCode,
        "tcgplayer_id": tcgplayerId == null ? null : tcgplayerId,
        "name": name == null ? null : name,
        "uri": uri == null ? null : uri,
        "scryfall_uri": scryfallUri == null ? null : scryfallUri,
        "search_uri": searchUri == null ? null : searchUri,
        "released_at": releasedAt == null ? null : releasedAt,
        "set_type": setType == null ? null : setType,
        "card_count": cardCount == null ? null : cardCount,
        "digital": digital == null ? null : digital,
        "foil_only": foilOnly == null ? null : foilOnly,
        "block_code": blockCode == null ? null : blockCode,
        "block": block == null ? null : block,
        "icon_svg_uri": iconSvgUri == null ? null : iconSvgUri,
    };
}
