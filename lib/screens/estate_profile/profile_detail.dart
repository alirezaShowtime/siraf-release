part of 'package:siraf3/screens/estate_profile/estate_profile_screen.dart';

extension ProfileDetail on _EstateProfileScreen {
  Widget profileDetail(estateProfileModel.EstateProfile estateProfile) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - (Scaffold.of(scaffoldContext).appBarMaxHeight ?? 0) - 190,
      ),
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          if (!estateProfile.description.isFill() || !estateProfile.video.isFill() || !estateProfile.images.isFill() || !estateProfile.consultants.isFill())
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                "جزییات بیشتر در دسترس نیست",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Themes.text,
                  fontFamily: "IranSansBold",
                  fontSize: 10,
                ),
              ),
            ),
          if (estateProfile.description.isFill())
            Text(
              estateProfile.description!,
              style: TextStyle(color: Themes.textGrey, fontSize: 11),
            ),
          if (estateProfile.video.isFill())
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: AspectRatio(
                aspectRatio: 2.1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FutureBuilder<Uint8List?>(
                    future: VideoThumbnail.thumbnailData(video: estateProfile.video!, imageFormat: ImageFormat.JPEG),
                    builder: (context, snapshot) {
                      return MyImage(
                        image: (snapshot.data == null ? NetworkImage("") : MemoryImage(snapshot.data!)) as ImageProvider,
                        errorWidget: MyImage.defaultErrorImageWidget(),
                        loadingWidget: MyImage.defaultLoadingImageWidget(),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
          if (estateProfile.images.isFill())
            Container(
              height: 60,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: estateProfile.images.length,
                itemBuilder: (context, i) => estateImageItem(estateProfile.images[i]),
              ),
            ),
          if (estateProfile.consultants.isFill()) divider(),
          if (estateProfile.consultants.isFill())
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: Text(
                "مشاورین ${estateProfile.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Themes.text,
                ),
              ),
            ),
          if (estateProfile.consultants.isFill())
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: estateProfile.consultants?.length ?? 0,
                itemBuilder: (context, i) => consultantItem(estateProfile.consultants![i]),
              ),
            ),
        ],
      ),
    );
  }
}
