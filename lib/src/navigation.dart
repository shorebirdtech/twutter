import 'package:flutter/material.dart';
import 'package:twutter/src/view/avatar.dart';
import 'package:twutter/src/view/config.dart';
import 'model/model.dart';
import 'view/timeline.dart';

class RootNavigation extends StatefulWidget {
  const RootNavigation({super.key});

  @override
  State<RootNavigation> createState() => _RootNavigationState();
}

class Screen {
  final String title;
  final Widget? appBarTitleOverride;
  final Widget body;
  final Widget floatingActionButton;
  final Icon navigationIcon;

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

class _RootNavigationState extends State<RootNavigation> {
  int _selectedScreenIndex = 0;

  static FloatingActionButton composeButton = FloatingActionButton(
    onPressed: () {},
    tooltip: 'Compose',
    child: const Icon(Icons.add),
  );

  static final List<Screen> _screens = <Screen>[
    Screen(
      title: "Timeline",
      body: const Timeline(),
      appBarTitleOverride: const Icon(Icons.flutter_dash),
      floatingActionButton: composeButton,
      navigationIcon: const Icon(Icons.home),
    ),
    Screen(
      title: "Search",
      body: const _Placeholder("Search"),
      floatingActionButton: composeButton,
      navigationIcon: const Icon(Icons.search),
    ),
    Screen(
      title: "Notifications",
      body: const _Placeholder("Notifications"),
      floatingActionButton: composeButton,
      navigationIcon: const Icon(Icons.notifications),
    ),
    Screen(
      title: "Messages",
      body: const _Placeholder("Messages"),
      floatingActionButton: composeButton,
      navigationIcon: const Icon(Icons.mail),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  Screen get selectedScreen => _screens[_selectedScreenIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        // FIXME: This Padding is a hack to shrink the CircleAvatar.
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(
              LayoutConfig.timelineHorizontalPadding, 0, 20, 0),
          child: AvatarView(user: model.me!),
        ), // Decide what logged out behavior is?
        title: selectedScreen.appBarTitle,
        centerTitle: true,
      ),
      body: selectedScreen.body,
      floatingActionButton: selectedScreen.floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        items: _screens
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
