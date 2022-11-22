import 'package:flutter/material.dart';
import 'package:twutter/src/view/config.dart';

import '../model/flap.dart';
import '../state.dart';
import 'flap.dart';

// Is this just AsyncSnapshot<List<Flap>>?
// Connection.of(context).latestFlapsSince(0)
// connection.getLastestFlaps -> Stream<List<Flap>>
// then you can have a generic converter from Stream<Foo> to AsyncSnapshot<Foo> (which we call StreamBuilder).

class TimelineViewModel {
  final List<Flap> flaps;
  // Scroll state?
  final bool loading;
  final bool error;
  final VoidCallback onRefresh;

  factory TimelineViewModel.from(BuildContext context) {
    var state = Store.of(context);
    var cache = state.authenticatedCache!;
    return TimelineViewModel(
      flaps: cache.latestFlaps,
      loading: cache.isRefreshingTimeline,
      error: cache.lastTimelineError != null,
      onRefresh: state.actions.refreshTimeline,
    );
  }

  const TimelineViewModel({
    required this.flaps,
    required this.loading,
    required this.error,
    required this.onRefresh,
  });
}

// Needed in the "handle-event" upwards phase.
// Actions.of(context).refreshTimeline()
// --- or ---
// Actions.of(context).add(RefreshTimeline())

// extension TimelineActions on Actions {
//   xxxx
// }

class _EmptyTimeline extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyTimeline({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    // Twitter has some fancier text here:
    // https://twitter.com/hanumpra/status/1243762509556748289
    return Column(
      children: [
        ElevatedButton(
          onPressed: onRefresh,
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
  final TimelineViewModel viewModel;
  const Timeline({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: LayoutConfig.timelineWidth,
      child: viewModel.flaps.isEmpty
          ? _EmptyTimeline(onRefresh: viewModel.onRefresh)
          : ListView.separated(
              itemBuilder: ((context, index) {
                return FlapView(flap: viewModel.flaps[index]);
              }),
              itemCount: viewModel.flaps.length,
              separatorBuilder: (context, index) => const Divider(),
              physics: const AlwaysScrollableScrollPhysics(),
            ),
    );
  }
}
