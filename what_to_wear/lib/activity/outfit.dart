import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  OutfitPart(
      {required this.name,
      required this.iconFilename,
      required this.isAccessory});
  String name;
  bool isUsed = false;
  String iconFilename;
  bool isAccessory;

  void setIsUsed(bool isUsed) {
    this.isUsed = isUsed;
  }

  @override
  String toString() {
    return 'OutfitPart(name: $name, isUsed: $isUsed, iconFilename: $iconFilename, isAccessory: $isAccessory)';
  }
}

class Outfit {
  late num runningApparentTemperature;
  late LinkedHashMap<OutfitPartType, OutfitPart> clothesMap;
  late List<OutfitPart> basicClohesList;
  late List<OutfitPart> accesoriesList;

  Outfit(num apparentTemperature, ActivityIntensity? intensity,
      num cloudsPercentage, num precipitationChance, num hour) {
    _calculateRunningApparentTemperature(apparentTemperature, intensity);
    _prepareClothesMap();
    _determineUsedClothes(
        apparentTemperature, cloudsPercentage, precipitationChance, hour);
    basicClohesList = List.of(clothesMap.values
        .where((element) => (element.isUsed & !element.isAccessory)));
    accesoriesList = List.of(clothesMap.values
        .where((element) => (element.isUsed & element.isAccessory)));
  }

  Outfit.fromSnapshot(DocumentSnapshot snapshot) {
    runningApparentTemperature =
        snapshot['running_apparent_temperature'] as num;
    _prepareClothesMap();

    clothesMap[OutfitPartType.singlet]!.setIsUsed(snapshot['singlet'] as bool);
    clothesMap[OutfitPartType.tshirt]!.setIsUsed(snapshot['tshirt'] as bool);
    clothesMap[OutfitPartType.bluzka]!.setIsUsed(snapshot['bluzka'] as bool);
    clothesMap[OutfitPartType.ortalion]!
        .setIsUsed(snapshot['ortalion'] as bool);
    clothesMap[OutfitPartType.kurtka]!.setIsUsed(snapshot['kurtka'] as bool);
    clothesMap[OutfitPartType.szorty]!.setIsUsed(snapshot['szorty'] as bool);
    clothesMap[OutfitPartType.leginsy]!.setIsUsed(snapshot['leginsy'] as bool);
    clothesMap[OutfitPartType.ocieplaneLeginsy]!
        .setIsUsed(snapshot['ocieplaneLeginsy'] as bool);
    clothesMap[OutfitPartType.kaszkiet]!
        .setIsUsed(snapshot['kaszkiet'] as bool);
    clothesMap[OutfitPartType.czapka]!.setIsUsed(snapshot['czapka'] as bool);
    clothesMap[OutfitPartType.opaska]!.setIsUsed(snapshot['opaska'] as bool);
    clothesMap[OutfitPartType.rekawiczki]!
        .setIsUsed(snapshot['rekawiczki'] as bool);
    clothesMap[OutfitPartType.komin]!.setIsUsed(snapshot['komin'] as bool);

    basicClohesList = List.of(clothesMap.values
        .where((element) => (element.isUsed & !element.isAccessory)));
    accesoriesList = List.of(clothesMap.values
        .where((element) => (element.isUsed & element.isAccessory)));
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

    clothesMap[OutfitPartType.singlet] = OutfitPart(
        name: 'Singlet',
        iconFilename: 'assets/clothes/singlet.png',
        isAccessory: false);
    clothesMap[OutfitPartType.tshirt] = OutfitPart(
        name: 'T-shirt',
        iconFilename: 'assets/clothes/tshirt.png',
        isAccessory: false);
    clothesMap[OutfitPartType.bluzka] = OutfitPart(
        name: 'Bluzka',
        iconFilename: 'assets/clothes/bluzka.png',
        isAccessory: false);
    clothesMap[OutfitPartType.ortalion] = OutfitPart(
        name: 'Ortalion',
        iconFilename: 'assets/clothes/ortalion.png',
        isAccessory: false);
    clothesMap[OutfitPartType.kurtka] = OutfitPart(
        name: 'Kurtka',
        iconFilename: 'assets/clothes/kurtka.png',
        isAccessory: false);

    clothesMap[OutfitPartType.szorty] = OutfitPart(
        name: 'Szorty',
        iconFilename: 'assets/clothes/szorty.png',
        isAccessory: false);
    clothesMap[OutfitPartType.leginsy] = OutfitPart(
        name: 'Leginsy',
        iconFilename: 'assets/clothes/leginsy.png',
        isAccessory: false);
    clothesMap[OutfitPartType.ocieplaneLeginsy] = OutfitPart(
        name: 'Ocieplane leginsy',
        iconFilename: 'assets/clothes/ocieplane_leginsy.png',
        isAccessory: false);

    clothesMap[OutfitPartType.kaszkiet] = OutfitPart(
        name: 'Kaszkiet',
        iconFilename: 'assets/clothes/kaszkiet.png',
        isAccessory: true);
    clothesMap[OutfitPartType.opaska] = OutfitPart(
        name: 'Opaska',
        iconFilename: 'assets/clothes/opaska.png',
        isAccessory: true);
    clothesMap[OutfitPartType.czapka] = OutfitPart(
        name: 'Czapka',
        iconFilename: 'assets/clothes/czapka.png',
        isAccessory: true);
    clothesMap[OutfitPartType.komin] = OutfitPart(
        name: 'Komin',
        iconFilename: 'assets/clothes/komin.png',
        isAccessory: true);
    clothesMap[OutfitPartType.rekawiczki] = OutfitPart(
        name: 'R??kawiczki',
        iconFilename: 'assets/clothes/rekawiczki.png',
        isAccessory: true);
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

    // zamiana bluzki na ortalion, je??li jest du??a szansa na opady
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
