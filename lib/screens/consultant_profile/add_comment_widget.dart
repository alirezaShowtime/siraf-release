part of 'consultant_profile_screen.dart';

extension AddCommentWidget on _ConsultantProfileScreen {
  Widget addCommentWidget() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            "امتیاز شما",
            style: TextStyle(
              color: Themes.text,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: RatingBar.builder(
              initialRating: 0,
              minRating: 0,
              direction: Axis.horizontal,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, _) => icon(Icons.star, color: Colors.amber),
              itemSize: 35,
              onRatingUpdate: (double value) => rate = value,
              glow: false,
              unratedColor: Colors.grey.shade200,
            ),
          ),
          MyTextField(
            focusNode: focusNode,
            controller: commentController,
            maxLines: 8,
            minLines: 4,
            decoration: InputDecoration(
              labelText: "توضیحات",
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: MaterialButton(
              onPressed: () => sendCommentOrRate(widget.consultantId),
              color: Themes.primary,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: BlocBuilder(
                bloc: sendCommentRateBloc,
                builder: (context, state) {
                  if (state is ConsultantProfileCommentRateSending) {
                    return SizedBox(
                      width: 15,
                      height: 15,
                      child: SpinKitRing(color: Colors.white, size: 12, lineWidth: 2),
                    );
                  }
                  return Text(
                    "ثبت",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
