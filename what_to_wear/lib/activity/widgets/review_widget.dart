import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:what_to_wear/activity/activity_overview.dart';
import 'package:what_to_wear/activity/outfit.dart';
import 'package:what_to_wear/activity/weather_service.dart';
import 'package:what_to_wear/activity/widgets/intensity_widget.dart';

class ActivityReviewWidget extends StatelessWidget {
  ActivityReviewWidget(
      {Key? key, required this.forecastRating, required this.outfitRating})
      : super(key: key);
  double? forecastRating;
  double? outfitRating;

  double getRating(double? rating) {
    if (rating == null) {
      return 0;
    } else {
      return rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 3,
          child: DecoratedBox(
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(
            'WYSTAWIONA OCENA',
            style: TextStyle(
              fontSize: 20.0,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const Text(
              "Prognoza pogody: ",
              style: TextStyle(fontSize: 18),
            ),
            RatingBar.builder(
              initialRating: getRating(forecastRating),
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 20,
              ignoreGestures: true,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (double value) {},
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            const Text(
              "Dobór stroju: ",
              style: TextStyle(fontSize: 18),
            ),
            RatingBar.builder(
              initialRating: getRating(outfitRating),
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 20,
              ignoreGestures: true,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (double value) {},
            ),
          ],
        ),
      ],
    );
  }
}
