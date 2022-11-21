import 'package:flutter/material.dart';
import 'package:twutter/src/view/config.dart';

import '../state.dart';
import 'flap.dart';

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  void queueRefresh() {
    // Refresh status
    // In progress
    // Failed
    // Completed
  }

  @override
  Widget build(BuildContext context) {
    // Twitter has some fancier text here:
    // https://twitter.com/hanumpra/status/1243762509556748289
    return Column(
      children: [
        ElevatedButton(
          onPressed: queueRefresh,
          child: const Text("Refresh"),
        ),
        const Text("Welcome to your timeline!",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        const Text("When you follow people, their Flaps will show up here.",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
      ],
    );
  }
}

class Timeline extends StatelessWidget {
  const Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    var store = StoreState.of(context);
    var latestFlaps = store.authenticatedCache!.latestFlaps;
    return SizedBox(
      width: LayoutConfig.timelineWidth,
      child: latestFlaps.isEmpty
          ? const _EmptyTimeline()
          : ListView.separated(
              itemBuilder: ((context, index) {
                return FlapView(flap: latestFlaps[index]);
              }),
              itemCount: latestFlaps.length,
              separatorBuilder: (context, index) => const Divider(),
              physics: const AlwaysScrollableScrollPhysics(),
            ),
    );
  }
}
