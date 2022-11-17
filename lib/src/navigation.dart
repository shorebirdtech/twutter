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

class _ComposeMessageFloatingActionButton extends StatelessWidget {
  const _ComposeMessageFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      tooltip: 'Compose Message',
      child: const Icon(Icons.mail),
    );
  }
}

class _RootNavigationState extends State<RootNavigation> {
  int _selectedScreenIndex = 0;

  final List<Screen> _screens = const <Screen>[
    Screen(
      title: "Timeline",
      body: Timeline(),
      appBarTitleOverride: Icon(Icons.flutter_dash),
      floatingActionButton: _ComposeFloatingActionButton(),
      navigationIcon: Icon(Icons.home),
    ),
    Screen(
      title: "Search",
      body: _Placeholder("Search"),
      floatingActionButton: _ComposeFloatingActionButton(),
      navigationIcon: Icon(Icons.search),
    ),
    Screen(
      title: "Notifications",
      body: _Placeholder("Notifications"),
      floatingActionButton: _ComposeFloatingActionButton(),
      navigationIcon: Icon(Icons.notifications),
    ),
    Screen(
      title: "Messages",
      body: _Placeholder("Messages"),
      floatingActionButton: _ComposeMessageFloatingActionButton(),
      navigationIcon: Icon(Icons.mail),
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
        toolbarHeight: LayoutConfig.appBarHeight,
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
