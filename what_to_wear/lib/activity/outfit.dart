import 'dart:collection';

import 'package:what_to_wear/activity/widgets/intensity_widget.dart';

enum OutfitPartType {
  singlet,
  tshirt,
  bluzka,
  ortalion,
  kurtka,
  szorty,
  leginsy,
  ocieplaneLeginsy,
  kaszkiet,
  opaska,
  czapka,
  komin,
  rekawiczki
}

class OutfitPart {
  OutfitPart({required this.name});
  String name;
  bool isUsed = false;

  void setIsUsed(bool isUsed) {
    this.isUsed = isUsed;
  }

  @override
  String toString() {
    return 'OutfitPart(name: $name, isUsed: $isUsed)';
  }
}

class Outfit {
  late num runningApparentTemperature;
  late LinkedHashMap<OutfitPartType, OutfitPart> clothesMap;
  late List<OutfitPart> clohesList;

  Outfit(num apparentTemperature, ActivityIntensity? intensity,
      num cloudsPercentage, num precipitationChance, num hour) {
    _calculateRunningApparentTemperature(apparentTemperature, intensity);
    _prepareClothesMap();
    _determineUsedClothes(
        apparentTemperature, cloudsPercentage, precipitationChance, hour);
    clohesList = List.of(clothesMap.values.where((element) => element.isUsed));
  }

  @override
  String toString() {
    return 'Outfit(runningApparentTemperature: $runningApparentTemperature)';
  }

  void _calculateRunningApparentTemperature(
      num apparentTemperature, ActivityIntensity? intensity) {
    switch (intensity) {
      case ActivityIntensity.low:
        runningApparentTemperature = apparentTemperature + 1;
        break;
      case ActivityIntensity.medium:
        runningApparentTemperature = apparentTemperature + 2;
        break;
      case ActivityIntensity.high:
        runningApparentTemperature = apparentTemperature + 4;
        break;
      default:
        runningApparentTemperature = apparentTemperature;
        break;
    }
  }

  void _prepareClothesMap() {
    clothesMap = LinkedHashMap<OutfitPartType, OutfitPart>();

    clothesMap[OutfitPartType.singlet] = OutfitPart(name: 'Singlet');
    clothesMap[OutfitPartType.tshirt] = OutfitPart(name: 'T-shirt');
    clothesMap[OutfitPartType.bluzka] = OutfitPart(name: 'Bluzka');
    clothesMap[OutfitPartType.ortalion] = OutfitPart(name: 'Ortalion');
    clothesMap[OutfitPartType.kurtka] = OutfitPart(name: 'Kurtka');

    clothesMap[OutfitPartType.szorty] = OutfitPart(name: 'Szorty');
    clothesMap[OutfitPartType.leginsy] = OutfitPart(name: 'Leginsy');
    clothesMap[OutfitPartType.ocieplaneLeginsy] =
        OutfitPart(name: 'Ocieplane leginsy');

    clothesMap[OutfitPartType.kaszkiet] = OutfitPart(name: 'Kaszkiet');
    clothesMap[OutfitPartType.opaska] = OutfitPart(name: 'Opaska');
    clothesMap[OutfitPartType.czapka] = OutfitPart(name: 'Czapka');
    clothesMap[OutfitPartType.komin] = OutfitPart(name: 'Komin');
    clothesMap[OutfitPartType.rekawiczki] = OutfitPart(name: 'Rękawiczki');
  }

  void _determineUsedClothes(num apparentTemperature, num cloudsPercentage,
      num precipitationChance, num hour) {
    if (runningApparentTemperature >= 25) {
      clothesMap[OutfitPartType.singlet]!.setIsUsed(true);
      clothesMap[OutfitPartType.szorty]!.setIsUsed(true);
    } else if (runningApparentTemperature >= 20) {
      clothesMap[OutfitPartType.tshirt]!.setIsUsed(true);
      clothesMap[OutfitPartType.szorty]!.setIsUsed(true);
    } else if (runningApparentTemperature >= 16) {
      clothesMap[OutfitPartType.bluzka]!.setIsUsed(true);
      clothesMap[OutfitPartType.szorty]!.setIsUsed(true);
    } else if (runningApparentTemperature >= 10) {
      clothesMap[OutfitPartType.bluzka]!.setIsUsed(true);
      clothesMap[OutfitPartType.leginsy]!.setIsUsed(true);
    } else if (runningApparentTemperature >= 5) {
      clothesMap[OutfitPartType.tshirt]!.setIsUsed(true);
      clothesMap[OutfitPartType.bluzka]!.setIsUsed(true);
      clothesMap[OutfitPartType.ortalion]!.setIsUsed(true);
      clothesMap[OutfitPartType.leginsy]!.setIsUsed(true);
      clothesMap[OutfitPartType.opaska]!.setIsUsed(true);
      clothesMap[OutfitPartType.komin]!.setIsUsed(true);
    } else if (runningApparentTemperature >= -5) {
      clothesMap[OutfitPartType.tshirt]!.setIsUsed(true);
      clothesMap[OutfitPartType.bluzka]!.setIsUsed(true);
      clothesMap[OutfitPartType.kurtka]!.setIsUsed(true);
      clothesMap[OutfitPartType.leginsy]!.setIsUsed(true);
      clothesMap[OutfitPartType.rekawiczki]!.setIsUsed(true);
      clothesMap[OutfitPartType.opaska]!.setIsUsed(true);
      clothesMap[OutfitPartType.komin]!.setIsUsed(true);
    } else {
      clothesMap[OutfitPartType.tshirt]!.setIsUsed(true);
      clothesMap[OutfitPartType.bluzka]!.setIsUsed(true);
      clothesMap[OutfitPartType.kurtka]!.setIsUsed(true);
      clothesMap[OutfitPartType.ocieplaneLeginsy]!.setIsUsed(true);
      clothesMap[OutfitPartType.rekawiczki]!.setIsUsed(true);
      clothesMap[OutfitPartType.czapka]!.setIsUsed(true);
      clothesMap[OutfitPartType.komin]!.setIsUsed(true);
    }

    // zamiana bluzki na ortalion, jeśli jest duża szansa na opady
    if (clothesMap[OutfitPartType.bluzka]!.isUsed &&
        !clothesMap[OutfitPartType.ortalion]!.isUsed &&
        !clothesMap[OutfitPartType.kurtka]!.isUsed &&
        precipitationChance >= 80) {
      clothesMap[OutfitPartType.bluzka]!.setIsUsed(false);
      clothesMap[OutfitPartType.tshirt]!.setIsUsed(true);
      clothesMap[OutfitPartType.ortalion]!.setIsUsed(true);
    }

    // dodanie kaszkietu
    if (apparentTemperature >= 20 &&
        cloudsPercentage <= 20 &&
        hour >= 9 &&
        hour <= 17) {
      clothesMap[OutfitPartType.kaszkiet]!.setIsUsed(true);
    }
  }
}
