part of 'agent_profile_screen.dart';

extension AnswerItem on _AgentProfileScreen {
  Widget answerItem(Map<String, dynamic> answer) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 4, left: 12, right: 12),
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200,
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
                    size: 25,
                    imagePath:
                        "https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png",
                  ),
                  SizedBox(width: 5),
                  Text(
                    answer["user"]["username"],
                    style: TextStyle(
                      color: Themes.textGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Text(
                answer["date"],
                style: TextStyle(
                  color: Themes.textGrey,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            answer["comment"],
            style: TextStyle(
              fontSize: 11,
              color: Themes.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
