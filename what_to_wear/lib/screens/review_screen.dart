import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:what_to_wear/activity/activity_overview.dart';
import 'package:what_to_wear/activity/outfit.dart';
import 'package:what_to_wear/activity/weather_service.dart';
import 'package:what_to_wear/activity/widgets/intensity_widget.dart';

final CollectionReference _activities =
    FirebaseFirestore.instance.collection('activities');

typedef RatingCallback = void Function(
    double? forecastRating, double? outfitRating);

class ReviewScreen extends StatefulWidget {
  ReviewScreen({
    Key? key,
    required this.ratingCallback,
    required this.forecast,
    required this.outfit,
    required this.overview,
    required this.userId,
  }) : super(key: key);

  RatingCallback ratingCallback;
  double? forecastRating;
  double? outfitRating;
  WeatherForecast? forecast;
  Outfit? outfit;
  ActivityOverview? overview;
  String? userId;

  @override
  State<ReviewScreen> createState() => ReviewScreenState();
}

class ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ocena"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Jak oceniasz prognozę pogody?',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  widget.forecastRating = rating;
                  print("POGODA: " + rating.toString());
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Czy strój był odpowiednio dobrany?',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  widget.outfitRating = rating;
                  print("STROJ: " + rating.toString());
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                  onPressed: () async {
                    print(widget.overview.toString());
                    print(widget.forecast.toString());
                    print(widget.outfit.toString());
                    print(widget.userId.toString());
                    await _activities
                        .doc(widget.overview!.activityId)
                        .update(prepareActivityDocument(
                          widget.forecast,
                          widget.outfit,
                          widget.overview,
                          widget.forecastRating,
                          widget.outfitRating,
                          widget.userId,
                        ));
                    widget.ratingCallback(
                        widget.forecastRating, widget.outfitRating);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Wystawiono ocenę'),
                          duration: Duration(seconds: 1)),
                    );
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(
                            right: 10.0, top: 10.0, bottom: 10.0),
                        child: Text('Zapisz', style: TextStyle(fontSize: 24)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Map<String, Object?> prepareActivityDocument(
      WeatherForecast? forecast,
      Outfit? outfit,
      ActivityOverview? overview,
      double? forecastRating,
      double? outfitRating,
      String? userId) {
    return {
      "user_id": userId,
      "location": overview!.location,
      "date": overview.chosenDate,
      "intensity": getIntensityName(overview.intensity),
      "longitude": overview.longitude,
      "latitude": overview.latitude,
      "weather_description": forecast!.description,
      "temperature": forecast.temperature,
      "apparent_temperature": forecast.apparentTemperature,
      "wind": forecast.windSpeed,
      "clouds": forecast.cloudsPercentage,
      "weather_image_url": forecast.imageUrl,
      "precipitation_chance": forecast.precipitationChance,
      "running_apparent_temperature": outfit!.runningApparentTemperature,
      "singlet": outfit.clothesMap[OutfitPartType.singlet]?.isUsed,
      "tshirt": outfit.clothesMap[OutfitPartType.tshirt]?.isUsed,
      "bluzka": outfit.clothesMap[OutfitPartType.bluzka]?.isUsed,
      "ortalion": outfit.clothesMap[OutfitPartType.ortalion]?.isUsed,
      "kurtka": outfit.clothesMap[OutfitPartType.kurtka]?.isUsed,
      "szorty": outfit.clothesMap[OutfitPartType.szorty]?.isUsed,
      "leginsy": outfit.clothesMap[OutfitPartType.leginsy]?.isUsed,
      "ocieplaneLeginsy":
          outfit.clothesMap[OutfitPartType.ocieplaneLeginsy]?.isUsed,
      "opaska": outfit.clothesMap[OutfitPartType.opaska]?.isUsed,
      "czapka": outfit.clothesMap[OutfitPartType.czapka]?.isUsed,
      "komin": outfit.clothesMap[OutfitPartType.komin]?.isUsed,
      "kaszkiet": outfit.clothesMap[OutfitPartType.kaszkiet]?.isUsed,
      "rekawiczki": outfit.clothesMap[OutfitPartType.rekawiczki]?.isUsed,
      "forecast_rating": forecastRating,
      "outfit_rating": outfitRating,
      "reviewed": true,
    };
  }

  String getIntensityName(ActivityIntensity? intensity) {
    if (intensity == ActivityIntensity.low) {
      return "Niska";
    } else if (intensity == ActivityIntensity.high) {
      return "Wysoka";
    } else {
      return "Umiarkowana";
    }
  }
}
