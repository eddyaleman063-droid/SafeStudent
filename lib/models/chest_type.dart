import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sagen/l10n/app_localizations.dart';

@JsonEnum()
enum ChestType {
  bronze,
  silver,
  gold,
  legendary;

  String get label {
    switch (this) {
      case ChestType.bronze: return 'Bronce';
      case ChestType.silver: return 'Plata';
      case ChestType.gold: return 'Oro';
      case ChestType.legendary: return 'Legendario';
    }
  }

  String localizedLabel(AppLocalizations l) {
    switch (this) {
      case ChestType.bronze: return l.chestTypeBronze;
      case ChestType.silver: return l.chestTypeSilver;
      case ChestType.gold: return l.chestTypeGold;
      case ChestType.legendary: return l.chestTypeLegendary;
    }
  }

  Color get color {
    switch (this) {
      case ChestType.bronze: return const Color(0xFF8D6E63);
      case ChestType.silver: return const Color(0xFF9E9E9E);
      case ChestType.gold: return const Color(0xFFFFB300);
      case ChestType.legendary: return const Color(0xFF7C4DFF);
    }
  }

  Color get glowColor {
    switch (this) {
      case ChestType.bronze: return const Color(0xFF8D6E63);
      case ChestType.silver: return const Color(0xFFB0BEC5);
      case ChestType.gold: return const Color(0xFFFFB300);
      case ChestType.legendary: return const Color(0xFFB388FF);
    }
  }

  Color get gemColor {
    switch (this) {
      case ChestType.bronze: return const Color(0xFFFF8F00);
      case ChestType.silver: return const Color(0xFF80DEEA);
      case ChestType.gold: return const Color(0xFFFFD700);
      case ChestType.legendary: return const Color(0xFFCE93D8);
    }
  }
}
