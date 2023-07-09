part of 'package:siraf3/screens/estate_profile/estate_profile_screen.dart';

extension ProfileDetail on _EstateProfileScreen {
  Widget profileDetail(estateProfileModel.EstateProfile estateProfile) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - (Scaffold.of(scaffoldContext).appBarMaxHeight ?? 0) - 170,
      ),
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: ListView(
        children: [
          Text(
            estateProfile.description ?? "",
            style: TextStyle(
              color: Themes.textGrey,
              fontSize: 11,
            ),
          ),
          //todo:: show video thumbnail
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: AspectRatio(
              aspectRatio: 2.1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  image: NetworkImage("https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: estateProfile.images?.length ?? 0,
              itemBuilder: (context, i) => estateImageItem(estateProfile.images![i]),
            ),
          ),
          if ((estateProfile.consultants?.length ?? 0) > 0) divider(),
          if ((estateProfile.consultants?.length ?? 0) > 0)
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
          if ((estateProfile.consultants?.length ?? 0) > 0)
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
