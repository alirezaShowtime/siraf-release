part of 'agent_profile_screen.dart';

extension Widgets on _AgentProfileScreen {
  Widget agencyImageItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          image: NetworkImage("https://blog.logrocket.com/wp-content/uploads/2021/04/10-best-Tailwind-CSS-component-and-template-collections.png"),
          height: 50,
          width: 70,
          fit: BoxFit.fill,
          loadingBuilder: (context, child, progressEvent) {
            if (progressEvent == null) return child;
            return Container(
              height: 50,
              width: 70,
              color: Colors.grey.shade200,
            );
          },
        ),
      ),
    );
  }

  Widget fileItem(File file) => FileHorizontalItem(file: file);

  Widget retryWidget(context, String message) {
    return Center(
      child: TryAgain(
        onPressed: () => retry(context),
        message: message,
      ),
    );
  }
}
