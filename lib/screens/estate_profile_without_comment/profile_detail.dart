part of 'estate_profile_screen.dart';

extension ProfileDetail on _EstateProfileScreen {
  Widget profileDetail(EstateProfile estateProfile) {
    return Expanded(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!estateProfile.description.isFill() && !estateProfile.video.isFill() && !estateProfile.images.isFill() && !estateProfile.consultants.isFill())
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
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
              if (estateProfile.address.isFill())
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 14),
                  child: Text(
                    "آدرس : ${estateProfile.address ?? "??"}",
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: "IranSansMedium",
                    ),
                  ),
                ),
              if (estateProfile.telephoneNumber.isFill())
                Row(
                  children: [
                    Text(
                      "تلفن ثابت : ${estateProfile.telephoneNumber ?? "??"}",
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: "IranSansMedium",
                      ),
                    ),
                    InkWell(
                      onTap: () => callTo(estateProfile.telephoneNumber!),
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "تماس",
                          style: TextStyle(
                            fontSize: 10,
                            color: Themes.primary,
                            fontFamily: "IranSansBold",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (estateProfile.phoneNumber.isFill())
                InkWell(
                  onTap: () => callTo(estateProfile.phoneNumber!),
                  borderRadius: BorderRadius.circular(5),
                  child: Text(
                    "شماره مدیر : ${estateProfile.phoneNumber ?? "??"}",
                    style: TextStyle(fontSize: 11, fontFamily: "IranSansMedium", color: Themes.primary),
                  ),
                ),
              if (estateProfile.lat != null && estateProfile.long != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: SimpleMap(
                    lat: estateProfile.lat!,
                    long: estateProfile.long!,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              if (estateProfile.description.isFill())
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "توضیحات",
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: "IranSansBold",
                    ),
                  ),
                ),
              if (estateProfile.description.isFill())
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    estateProfile.description!,
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              if (estateProfile.video.isFill())
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: AspectRatio(
                    aspectRatio: 2.1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FutureBuilder<Uint8List?>(
                        future: VideoThumbnail.thumbnailData(video: estateProfile.video!, imageFormat: ImageFormat.PNG),
                        builder: (context, snapshot) {
                          return Stack(
                            children: [
                              MyImage(
                                image: (snapshot.data == null ? NetworkImage("") : MemoryImage(snapshot.data!)) as ImageProvider,
                                border: Border.all(color: Colors.grey.shade200, width: 1),
                                errorWidget: MyImage.defaultErrorImageWidget(),
                                loadingWidget: MyImage.defaultLoadingImageWidget(),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              Align(
                                child: VideoButton(
                                  icon: CupertinoIcons.play_fill,
                                  onTap: () => push(context, VideoScreen(videoUrl: estateProfile.video!)),
                                ),
                              ),
                            ],
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
                    itemBuilder: (context, i) => estateImageItem(estateProfile.images, index: i),
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
                      color: Themes.text,
                      fontSize: 13,
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
        ),
      ),
    );
  }
}
