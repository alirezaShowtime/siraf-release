import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

import 'agent_profile_screen.dart';

extension ProfileDetail on AgentProfileScreenState {
  Widget profileDetail() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height -
            (Scaffold.of(scaffoldContext).appBarMaxHeight ?? 0) -
            170,
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
            "fdkfdspf p[kfpdkl dk ofkp[ ko kk okokdoflk olkokpfkdsfldsfkdfodsfdoskofdsjiofdskfojsdffoidjsfiodf'dposfjoihjdoifdifjdsjifdfoidsjfdposjfdsofijdsoifdjsofidjsfdkf podmnsf fdkfdspf p[kfpdkl dk ofkp[ ko kk okokdoflk olkokpfkdsfldsfkdfodsfdoskofdsjiofdskfojsdffoidjsfiodf'dposfjoihjdoifdifjdsjifdfoidsjfdposjfdsofijdsoifdjsofidjsfdkf podmnsf fdkfdspf p[kfpdkl dk ofkp[ ko kk okokdoflk olkokpfkdsfldsfkdfodsfdoskofdsjiofdskfojsdffoidjsfiodf'dposfjoihjdoifdifjdsjifdfoidsjfdposjfdsofijdsoifdjsofidjsfdkf podmnsf ",
            style: TextStyle(
              color: Themes.textGrey,
              fontSize: 11,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: AspectRatio(
              aspectRatio: 2.1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                  image: NetworkImage(
                      "https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png"),
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
              // padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: 10,
              itemBuilder: (context, i) => agencyImageItem(),
            ),
          ),
        ],
      ),
    );
  }
}
