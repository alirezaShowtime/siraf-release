import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/agency_profile/answer_item.dart';
import 'package:siraf3/screens/agency_profile/event_listeners.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/my_text_icon_button.dart';

import 'agency_profile_screen.dart';

extension CommentItem on AgencyProfileScreenState {
  Widget commentItem(Map<String, dynamic> comment) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Avatar(
                    size: 40,
                    imagePath:
                        "https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png",
                  ),
                  SizedBox(width: 10),
                  Text(
                    comment["user"]["username"],
                    style: TextStyle(
                      color: Themes.textGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  RatingBar.builder(
                    initialRating: comment["star"],
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 0.25),
                    itemBuilder: (context, _) =>
                        icon(Icons.star, color: Colors.amber),
                    itemSize: 10,
                    onRatingUpdate: (double value) {},
                    updateOnDrag: false,
                    ignoreGestures: true,
                    unratedColor: Colors.grey.shade300,
                  ),
                  Text(
                    comment["date"],
                    style: TextStyle(
                      color: Themes.textGrey,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: 40,
            ),
            padding: const EdgeInsets.only(right: 5, top: 10, bottom: 10),
            child: Text(
              // comment["comment"],
              "oiskdi ko kasdoksofk podfkdpo kf oidkoik oikdksfds f0dkf 0o9sfkd90sfkd90kf0d9skf d90sfkds90 fkd90sfkd90s fk d9dsfd9sfj89ke90ewjo9j 90jfoej r90ejr poj90j9efjo pjds90ocpj 90[jfo lmj 0jmf[9ejolmj9ko90j opfj90 joinj0iokj0 kj90 joijoij 90j [90jpo cmj0fj0inm0injf[ij[o0 k0[mnj0[oinj90in0[njklopmkcofe",
              style: TextStyle(
                color: Themes.textGrey,
                fontSize: 11,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MyTextIconButton(
                    onPressed: () => like(comment),
                    icon: icon(Icons.thumb_up_alt_outlined, size: 15),
                    text: "122",
                    rippleColor: Themes.text,
                  ),
                  MyTextIconButton(
                    onPressed: () => dislike(comment),
                    icon: icon(Icons.thumb_down_alt_outlined, size: 15),
                    text: "1",
                    rippleColor: Themes.text,
                  ),
                ],
              ),
              MyTextButton(
                rippleColor: Themes.text,
                padding: EdgeInsets.zero,
                onPressed: () => answer(comment),
                child: Text(
                  "پاسخ",
                  style: TextStyle(
                    color: Themes.text,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (comment["answers"] != null &&
              (comment["answers"] as List).length > 0)
            Column(
              children: (comment["answers"] as List)
                  .map((answer) => answerItem(answer))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
