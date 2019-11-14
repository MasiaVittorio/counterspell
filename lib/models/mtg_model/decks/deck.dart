import '../card.dart';

class MtgDeck{
  //boards
  Map<String, MtgCard> main;
  Map<String, MtgCard> sideBoard;
  Map<String, MtgCard> maybeBoard;
  
  //how much a card is good in this deck from 1 to 5
  Map<String, int> votes;

  //cardId => list<tag>
  Map<String,List<String>> tags;


  
  //=========================
  // Tag Cards ==============

  void tag(MtgCard card, String tag){
    tags[card.id] = (tags[card.id] ?? [])
      ..add(tag..replaceAll("+", ""));
  }

  void unTag(MtgCard card, String tag){
    tags[card.id] = (tags[card.id] ?? [])
      ..remove(tag);
  }

  static Map<String,List<MtgCard>> groupTags(
    Map<String,MtgCard> cards,  

    //card Id => tags
    Map<String,List<String>> tags
  ){
    //tag (or tags) => cards
    Map<String,List<MtgCard>> result = <String,List<MtgCard>>{};

    for(final pooledCardEntry in cards.entries){
      final id = pooledCardEntry.key;
      final c = pooledCardEntry.value;
      final List<String> ts = tags[id];
      final t = ts.join(" + ");
      result[t] = (result[t] ?? [])..add(c);
    }

    return result;

  }

  Map<String,List<MtgCard>> groupTagsMain() => groupTags(this.main, this.tags);
  Map<String,List<MtgCard>> groupTagsSide() => groupTags(this.sideBoard, this.tags);
  Map<String,List<MtgCard>> groupTagsMaybe() => groupTags(this.maybeBoard, this.tags);

  static Map<String,List<MtgCard>> groupTypes(List<MtgCard> cards){
    Map<String,List<MtgCard>> result = <String,List<MtgCard>>{};
    for(final card in cards){
      for(final type in _types.entries){
        for(final t in type.value){
          if(card.typeLine.contains(t)){
            result[type.key] = (result[type.key] ?? [])..add(card);
          }
        }
      }
    }
    return result;
  }
  static const Map<String,List<String>> _types = {  
    "Creature": ["Creature"],
    "Artifact": ["Artifact"],
    "Land": ["Land"],
    "Enchantment": ["Enchantment"],
    "Spell": ["Instant", "Sorcery"],
    "Planeswalker": ["Planeswalker"],
  };

  Map<String,List<MtgCard>> groupTypesMain() => groupTypes(this.main.values);
  Map<String,List<MtgCard>> groupTypesSide() => groupTypes(this.sideBoard.values);
  Map<String,List<MtgCard>> groupTypesMaybe() => groupTypes(this.maybeBoard.values);

  static Map<String,List<MtgCard>> groupVote(Map<String, int> votes, List<MtgCard> cards){
    Map<String,List<MtgCard>> result = <String,List<MtgCard>>{
      "5/5": [],
      "4/5": [],
      "3/5": [],
      "2/5": [],
      "1/5": [],
      "0/5": [],
    };

    for(final card in cards){
      String vote = (votes[card.id] ?? 0).toString() + "/5";
      result[vote] = (result[vote] ?? [])..add(card);
    }

    return result;
  }

  Map<String,List<MtgCard>> groupVoteMain() => groupVote(this.votes, this.main.values);
  Map<String,List<MtgCard>> groupVoteSide() => groupVote(this.votes, this.sideBoard.values);
  Map<String,List<MtgCard>> groupVoteMaybe() => groupVote(this.votes, this.maybeBoard.values);




  //=========================
  // Add Cards =============

  void toMain(List<MtgCard> cards){
    for(final card in cards)
      this.main[card.id] = card;
  }
  void toMaybeboard(List<MtgCard> cards){
    for(final card in cards)
      this.maybeBoard[card.id] = card;
  }
  void toSideboard(List<MtgCard> cards){
    for(final card in cards)
      this.sideBoard[card.id] = card;
  }



  //=========================
  // Move Cards =============

  void sideToMain(String key){
    if(!sideBoard.containsKey(key)) return;

    main[key] = sideBoard[key];
    sideBoard.remove(key);
  }
  void sideToMaybe(String key){
    if(!sideBoard.containsKey(key)) return;

    maybeBoard[key] = sideBoard[key];
    sideBoard.remove(key);
  }

  void mainToSide(String key){
    if(!main.containsKey(key)) return;

    sideBoard[key] = main[key];
    main.remove(key);
  }
  void mainToMaybe(String key){
    if(!main.containsKey(key)) return;

    maybeBoard[key] = main[key];
    main.remove(key);
  }

  void maybeToMain(String key){
    if(!maybeBoard.containsKey(key)) return;

    main[key] = maybeBoard[key];
    maybeBoard.remove(key);
  }
  void maybeToSide(String key){
    if(!maybeBoard.containsKey(key)) return;

    sideBoard[key] = maybeBoard[key];
    maybeBoard.remove(key);
  }
}