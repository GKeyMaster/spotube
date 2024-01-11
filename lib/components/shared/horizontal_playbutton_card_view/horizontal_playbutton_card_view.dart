import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/components/album/album_card.dart';
import 'package:spotube/components/artist/artist_card.dart';
import 'package:spotube/components/playlist/playlist_card.dart';
import 'package:spotube/hooks/utils/use_breakpoint_value.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class HorizontalPlaybuttonCardView<T> extends HookWidget {
  final Widget title;
  final List<T> items;
  final VoidCallback onFetchMore;
  final bool isLoadingNextPage;
  final bool hasNextPage;

  const HorizontalPlaybuttonCardView({
    required this.title,
    required this.items,
    required this.hasNextPage,
    required this.onFetchMore,
    required this.isLoadingNextPage,
    Key? key,
  })  : assert(
          items is List<PlaylistSimple> ||
              items is List<Album> ||
              items is List<Artist>,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData(:textTheme) = Theme.of(context);
    final scrollController = useScrollController();
    final height = useBreakpointValue<double>(
      xs: 226,
      sm: 226,
      md: 236,
      others: 266,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle(
            style: textTheme.titleMedium!,
            child: title,
          ),
          SizedBox(
            height: height,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: items.isEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return AlbumCard(FakeData.albumSimple);
                      },
                    )
                  : InfiniteList(
                      scrollController: scrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: items.length,
                      onFetchData: onFetchMore,
                      loadingBuilder: (context) => Skeletonizer(
                            enabled: true,
                            child: AlbumCard(FakeData.albumSimple),
                          ),
                      isLoading: isLoadingNextPage,
                      hasReachedMax: !hasNextPage,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return switch (item.runtimeType) {
                          PlaylistSimple =>
                            PlaylistCard(item as PlaylistSimple),
                          Album => AlbumCard(item as Album),
                          Artist => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: ArtistCard(item as Artist),
                            ),
                          _ => const SizedBox.shrink(),
                        };
                      }),
            ),
          ),
        ],
      ),
    );
  }
}
