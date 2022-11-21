import 'package:flutter/material.dart';
import 'package:twutter/src/view/config.dart';

import '../model/model.dart';
import 'flap.dart';

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline();

  @override
  Widget build(BuildContext context) {
    // Twitter has some fancier text here:
    // https://twitter.com/hanumpra/status/1243762509556748289
    return Column(
      children: const [
        Text("Welcome to your timeline!",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Text("When you follow people, their Flaps will show up here.",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
      ],
    );
  }
}

class Timeline extends StatelessWidget {
  const Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: LayoutConfig.timelineWidth,
      child: cache.latestFlaps.isEmpty
          ? const _EmptyTimeline()
          : ListView.separated(
              itemBuilder: ((context, index) {
                return FlapView(flap: cache.latestFlaps[index]);
              }),
              itemCount: cache.latestFlaps.length,
              separatorBuilder: (context, index) => const Divider(),
              physics: const AlwaysScrollableScrollPhysics(),
            ),
    );
  }
}
