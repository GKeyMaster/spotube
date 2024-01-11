import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';

import 'package:skeletonizer/skeletonizer.dart';

class ShimmerLyrics extends HookWidget {
  const ShimmerLyrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 30,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final texts = [
            "Lorem ipsum",
            "consectetur.",
            "Sed",
            "Sed non risus",
          ]..shuffle();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final text in texts) ...[
                Text(text),
                if (text != texts.last) const Gap(10),
              ],
            ],
          );
        },
      ),
    );
  }
}
