import 'package:flutter/material.dart';
import 'package:twutter/src/view/config.dart';

import '../globals.dart';
import 'flap.dart';

// Is this just AsyncSnapshot<List<Flap>>?
// Connection.of(context).latestFlapsSince(0)
// connection.getLastestFlaps -> Stream<List<Flap>>
// then you can have a generic converter from Stream<Foo> to AsyncSnapshot<Foo> (which we call StreamBuilder).

// Needed in the "handle-event" upwards phase.
// Actions.of(context).refreshTimeline()
// --- or ---
// Actions.of(context).add(RefreshTimeline())

// extension TimelineActions on Actions {
//   xxxx
// }

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
    // This should show always show cached flaps?
    // And status of current fetch request?
    // CachedFlap would have the User always associated?
    // Where is the scroll position cached?
    var globals = Globals.of(context);
    return SizedBox(
      width: LayoutConfig.timelineWidth,
      child: ValueListenableBuilder<List<CachedFlap>>(
        valueListenable: globals.cachedFlaps,
        builder: (context, cachedFlaps, child) {
          if (cachedFlaps.isEmpty) {
            return const _EmptyTimeline();
          }
          return ListView.separated(
            itemCount: cachedFlaps.length,
            itemBuilder: (context, index) =>
                FlapView(cachedFlap: cachedFlaps[index]),
            separatorBuilder: (context, index) => const Divider(),
            physics: const AlwaysScrollableScrollPhysics(),
          );
        },
      ),
    );
  }
}
