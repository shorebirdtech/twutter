import 'package:flutter/material.dart';
import 'package:twutter/src/view/avatar.dart';
import 'package:twutter/src/view/config.dart';

import '../model/model.dart';
import '../view/notifications.dart';
import '../view/timeline.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class Screen {
  final String title;
  final Widget? appBarTitleOverride;
  final Widget body;
  final Widget floatingActionButton;
  final Widget navigationIcon;

  const Screen({
    required this.title,
    this.appBarTitleOverride,
    required this.body,
    required this.floatingActionButton,
    required this.navigationIcon,
  });

  Widget get appBarTitle => appBarTitleOverride ?? Text(title);
}

class _Placeholder extends StatelessWidget {
  final String title;

  const _Placeholder(this.title);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    );
  }
}

class _ComposeFloatingActionButton extends StatelessWidget {
  const _ComposeFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed("/compose");
      },
      tooltip: 'Compose',
      child: const Icon(Icons.add),
    );
  }
}

// class _ComposeMessageFloatingActionButton extends StatelessWidget {
//   const _ComposeMessageFloatingActionButton();

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () {},
//       tooltip: 'Compose Message',
//       child: const Icon(Icons.mail),
//     );
//   }
// }

class _UnreadBadgePainter extends CustomPainter {
  _UnreadBadgePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue;
    canvas.drawCircle(
        Offset(size.width * 7 / 8, size.height * 1 / 8), size.width / 8, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BadgedIcon extends StatelessWidget {
  final IconData iconData;
  final bool hasBadge;

  const BadgedIcon(this.iconData, {super.key, required this.hasBadge});

  @override
  Widget build(BuildContext context) {
    if (hasBadge) {
      return CustomPaint(
          foregroundPainter: _UnreadBadgePainter(), child: Icon(iconData));
    }
    return Icon(iconData);
  }
}

class _HomeState extends State<Home> {
  int _selectedScreenIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("cache: $authenticatedCache");
    if (authenticatedCache == null) {
      return const _Placeholder("Not logged in?");
    }
    var cache = authenticatedCache!;

    final List<Screen> screens = <Screen>[
      Screen(
        title: "Timeline",
        body: const Timeline(),
        appBarTitleOverride: const Icon(Icons.flutter_dash),
        floatingActionButton: const _ComposeFloatingActionButton(),
        navigationIcon: BadgedIcon(Icons.home, hasBadge: cache.hasUnreadFlaps),
      ),
      // const Screen(
      //   title: "Search",
      //   body: _Placeholder("Search"),
      //   floatingActionButton: _ComposeFloatingActionButton(),
      //   navigationIcon: Icon(Icons.search),
      // ),
      const Screen(
        title: "Notifications",
        body: Notifications(),
        floatingActionButton: _ComposeFloatingActionButton(),
        navigationIcon: Icon(Icons.notifications),
      ),
      // Screen(
      //   title: "Messages",
      //   body: const _Placeholder("Messages"),
      //   floatingActionButton: const _ComposeMessageFloatingActionButton(),
      //   navigationIcon: BadgedIcon(Icons.mail, hasBadge: cache.hasNewMessages),
      // ),
    ];

    var selectedScreen = screens[_selectedScreenIndex];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: LayoutConfig.appBarHeight,
        // FIXME: This Padding is a hack to shrink the CircleAvatar.
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(
              LayoutConfig.timelineHorizontalPadding, 0, 20, 0),
          child: AvatarView(user: cache.user),
        ), // Decide what logged out behavior is?
        title: selectedScreen.appBarTitle,
        centerTitle: true,
      ),
      body: selectedScreen.body,
      floatingActionButton: selectedScreen.floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        items: screens
            .map((e) =>
                BottomNavigationBarItem(icon: e.navigationIcon, label: e.title))
            .toList(),
        currentIndex: _selectedScreenIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
