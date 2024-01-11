import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart' hide Offset;
import 'package:spotube/collections/spotube_icons.dart';

import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/hooks/utils/use_debounce.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_state.dart';
import 'package:spotube/services/sourced_track/models/source_info.dart';
import 'package:spotube/services/sourced_track/models/video_info.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/services/sourced_track/sources/youtube.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class SiblingTracksSheet extends HookConsumerWidget {
  final bool floating;
  const SiblingTracksSheet({
    Key? key,
    this.floating = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final playlistNotifier = ref.watch(ProxyPlaylistNotifier.notifier);
    final preferences = ref.watch(userPreferencesProvider);

    final isSearching = useState(false);
    final searchMode = useState(preferences.searchMode);

    final title = ServiceUtils.getTitle(
      playlist.activeTrack?.name ?? "",
      artists:
          playlist.activeTrack?.artists?.map((e) => e.name!).toList() ?? [],
      onlyCleanArtist: true,
    ).trim();

    final defaultSearchTerm =
        "$title - ${TypeConversionUtils.artists_X_String<Artist>(playlist.activeTrack?.artists ?? [])}";
    final searchController = useTextEditingController(
      text: defaultSearchTerm,
    );

    final searchTerm = useDebounce<String>(
      useValueListenable(searchController).text,
    );

    final controller = useScrollController();

    final searchRequest = useMemoized(() async {
      if (searchTerm.trim().isEmpty) {
        return <SourceInfo>[];
      }

      final results = await youtubeClient.search.search(searchTerm.trim());

      return await Future.wait(
        results.map(YoutubeVideoInfo.fromVideo).mapIndexed((i, video) async {
          final siblingType = await YoutubeSourcedTrack.toSiblingType(i, video);
          return siblingType.info;
        }),
      );
    }, [
      searchTerm,
      searchMode.value,
    ]);

    final siblings = useMemoized(
      () => playlist.isFetching == false
          ? [
              (playlist.activeTrack as SourcedTrack).sourceInfo,
              ...(playlist.activeTrack as SourcedTrack).siblings,
            ]
          : <SourceInfo>[],
      [playlist.isFetching, playlist.activeTrack],
    );

    final borderRadius = floating
        ? BorderRadius.circular(10)
        : const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          );

    useEffect(() {
      if (playlist.activeTrack is SourcedTrack &&
          (playlist.activeTrack as SourcedTrack).siblings.isEmpty) {
        playlistNotifier.populateSibling();
      }
      return null;
    }, [playlist.activeTrack]);

    final itemBuilder = useCallback(
      (SourceInfo sourceInfo) {
        return ListTile(
          title: Text(sourceInfo.title),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: UniversalImage(
              path: sourceInfo.thumbnail,
              height: 60,
              width: 60,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          trailing: Text(sourceInfo.duration.toHumanReadableString()),
          subtitle: Text(sourceInfo.artist),
          enabled: playlist.isFetching != true,
          selected: playlist.isFetching != true &&
              sourceInfo.id ==
                  (playlist.activeTrack as SourcedTrack).sourceInfo.id,
          selectedTileColor: theme.popupMenuTheme.color,
          onTap: () {
            if (playlist.isFetching == false &&
                sourceInfo.id !=
                    (playlist.activeTrack as SourcedTrack).sourceInfo.id) {
              playlistNotifier.swapSibling(sourceInfo);
              Navigator.of(context).pop();
            }
          },
        );
      },
      [playlist.isFetching, playlist.activeTrack, siblings],
    );

    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: ClipRRect(
        borderRadius: borderRadius,
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12.0,
            sigmaY: 12.0,
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Container(
              height: isSearching.value && mediaQuery.smAndDown
                  ? mediaQuery.size.height - 50
                  : mediaQuery.size.height * .6,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: theme.colorScheme.surfaceVariant.withOpacity(.5),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  centerTitle: true,
                  title: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: !isSearching.value
                        ? Text(
                            context.l10n.alternative_track_sources,
                            style: theme.textTheme.headlineSmall,
                          )
                        : TextField(
                            autofocus: true,
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: context.l10n.search,
                              hintStyle: theme.textTheme.headlineSmall,
                              border: InputBorder.none,
                            ),
                            style: theme.textTheme.headlineSmall,
                          ),
                  ),
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  actions: [
                    if (!isSearching.value)
                      IconButton(
                        icon: const Icon(SpotubeIcons.search, size: 18),
                        onPressed: () {
                          isSearching.value = true;
                        },
                      )
                    else ...[
                      if (preferences.audioSource == AudioSource.piped)
                        PopupMenuButton(
                          icon: const Icon(SpotubeIcons.filter, size: 18),
                          onSelected: (SearchMode mode) {
                            searchMode.value = mode;
                          },
                          initialValue: searchMode.value,
                          itemBuilder: (context) => SearchMode.values
                              .map(
                                (e) => PopupMenuItem(
                                  value: e,
                                  child: Text(e.label),
                                ),
                              )
                              .toList(),
                        ),
                      IconButton(
                        icon: const Icon(SpotubeIcons.close, size: 18),
                        onPressed: () {
                          isSearching.value = false;
                        },
                      ),
                    ]
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: InterScrollbar(
                      controller: controller,
                      child: switch (isSearching.value) {
                        false => ListView.builder(
                            controller: controller,
                            itemCount: siblings.length,
                            itemBuilder: (context, index) =>
                                itemBuilder(siblings[index]),
                          ),
                        true => FutureBuilder(
                            future: searchRequest,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              } else if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              return InterScrollbar(
                                controller: controller,
                                child: ListView.builder(
                                  controller: controller,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) =>
                                      itemBuilder(snapshot.data![index]),
                                ),
                              );
                            },
                          ),
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
