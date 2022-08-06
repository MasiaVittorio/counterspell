// ignore_for_file: constant_identifier_names

import 'card.dart';
import 'package:flutter/material.dart';

const Color MTG_W_COLOR = Colors.yellow;
const Color MTG_U_COLOR = Colors.blue;
const Color MTG_B_COLOR = Colors.black;
const Color MTG_R_COLOR = Colors.red;
const Color MTG_G_COLOR = Colors.green;
const Color MTG_C_COLOR = Color(0xFFE0E0E0);

const Map<MtgColor, Color> MTG_TO_COLORS = {
  MtgColor.W : MTG_W_COLOR,
  MtgColor.U : MTG_U_COLOR,
  MtgColor.B : MTG_B_COLOR,
  MtgColor.R : MTG_R_COLOR,
  MtgColor.G : MTG_G_COLOR,
};

const GOLD_MULTICOLOR = Color(0xFFC6AA64);
const GOLD_RARE = Color(0xFFC6AA64);

const Map<MtgColor, Color> MTG_TO_COLORS_BKG = {
  MtgColor.W : Colors.white,
  MtgColor.U : MTG_U_COLOR,
  MtgColor.B : MTG_B_COLOR,
  MtgColor.R : Color(0xFFD32F2F),
  MtgColor.G : MTG_G_COLOR,
};

const Map<MtgColor, Color> MANA_COLORS_BKG = {
  MtgColor.W : Color(0xFFFFFED8),
  MtgColor.U : Color(0xFFA9DCEF),
  MtgColor.B : Color(0xFFB3ADAF),
  MtgColor.R : Color(0xFFEEA489),
  MtgColor.G : Color(0xFF93CBA4),
};
const Color MANA_COLORLESS = Color(0xFFCAC3C0);
const Color MANA_NUMBERS = Color(0xFFCAC5C0);

String colorsToName(Set<MtgColor> colors){
  if(colors.isEmpty){
    return "Colorless";
  }
  else if (colors.length == 1) {
    if(colors.contains(MtgColor.W)) return "Mono White";
    if(colors.contains(MtgColor.U)) return "Mono Blue";
    if(colors.contains(MtgColor.B)) return "Mono Black";
    if(colors.contains(MtgColor.R)) return "Mono Red";
    if(colors.contains(MtgColor.G)) return "Mono Green";
  }
  else if (colors.length == 2) {
    if(colors.containsAll([MtgColor.W, MtgColor.U])) return "Azorius";
    if(colors.containsAll([MtgColor.W, MtgColor.B])) return "Orzhov";
    if(colors.containsAll([MtgColor.W, MtgColor.R])) return "Boros";
    if(colors.containsAll([MtgColor.W, MtgColor.G])) return "Selesnya";

    if(colors.containsAll([MtgColor.U, MtgColor.B])) return "Dimir";
    if(colors.containsAll([MtgColor.U, MtgColor.R])) return "Izzet";
    if(colors.containsAll([MtgColor.U, MtgColor.G])) return "Simic";
    
    if(colors.containsAll([MtgColor.B, MtgColor.R])) return "Rakdos";
    if(colors.containsAll([MtgColor.B, MtgColor.G])) return "Golgari";
    
    if(colors.containsAll([MtgColor.R, MtgColor.G])) return "Gruul";
  }
  else if (colors.length == 3) {
    if(colors.containsAll([MtgColor.G, MtgColor.W, MtgColor.U,])) return "Bant";
    if(colors.containsAll([MtgColor.W, MtgColor.U, MtgColor.B,])) return "Esper";
    if(colors.containsAll([MtgColor.U, MtgColor.B, MtgColor.R,])) return "Grixis";
    if(colors.containsAll([MtgColor.B, MtgColor.R, MtgColor.G,])) return "Jund";
    if(colors.containsAll([MtgColor.R, MtgColor.G, MtgColor.W,])) return "Naya";

    if(colors.containsAll([MtgColor.U, MtgColor.R, MtgColor.W,])) return "Jeskai";
    if(colors.containsAll([MtgColor.R, MtgColor.W, MtgColor.B,])) return "Mardu";
    if(colors.containsAll([MtgColor.B, MtgColor.G, MtgColor.U,])) return "Sultai";
    if(colors.containsAll([MtgColor.G, MtgColor.U, MtgColor.R,])) return "Temur";
    if(colors.containsAll([MtgColor.W, MtgColor.B, MtgColor.G,])) return "Azban";
  }
  else if (colors.length == 4) {
    if(colors.contains(MtgColor.W) == false) return "Chaos";
    if(colors.contains(MtgColor.U) == false) return "Aggression";
    if(colors.contains(MtgColor.B) == false) return "Altruism";
    if(colors.contains(MtgColor.R) == false) return "Growth";
    if(colors.contains(MtgColor.G) == false) return "Artifice";
  }
  else if (colors.length == 5) {
    return "Domain";
  } 

  return "Color Name";
}

String colorsToStringApi(Set<MtgColor> colors){
  if(colors.isEmpty){
    return "colorless";
  }

  final map = {
    MtgColor.W: 'w',
    MtgColor.U: 'u',
    MtgColor.B: 'b',
    MtgColor.R: 'r',
    MtgColor.G: 'g',
  };

  return [
    for(final c in colors)
      map[c]
  ].join();
}

