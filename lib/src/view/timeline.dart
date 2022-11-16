import 'package:flutter/material.dart';
import 'package:twutter/src/view/config.dart';

import '../model/model.dart';
import 'flap.dart';

class Timeline extends StatelessWidget {
  const Timeline({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: LayoutConfig.timelineWidth,
      child: ListView.separated(
        itemBuilder: ((context, index) {
          return FlapView(flap: model.latestFlaps[index]);
        }),
        itemCount: model.latestFlaps.length,
        separatorBuilder: (context, index) => const Divider(),
        physics: const AlwaysScrollableScrollPhysics(),
      ),
    );
  }
}
