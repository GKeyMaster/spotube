import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/adaptive/adaptive_pop_sheet_list.dart';
import 'package:spotube/components/shared/dialogs/confirm_download_dialog.dart';
import 'package:spotube/components/shared/dialogs/playlist_add_track_dialog.dart';
import 'package:spotube/components/shared/tracks_view/track_view_props.dart';
import 'package:spotube/components/shared/tracks_view/track_view_provider.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_state.dart';

class TrackViewBodyOptions extends HookConsumerWidget {
  const TrackViewBodyOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final props = InheritedTrackView.of(context);
    final ThemeData(:textTheme) = Theme.of(context);

    ref.watch(downloadManagerProvider);
    final downloader = ref.watch(downloadManagerProvider.notifier);
    final playlistNotifier = ref.watch(ProxyPlaylistNotifier.notifier);
    final audioSource =
        ref.watch(userPreferencesProvider.select((s) => s.audioSource));

    final trackViewState = ref.watch(trackViewProvider(props.tracks));
    final selectedTracks = trackViewState.selectedTracks;

    return AdaptivePopSheetList(
      tooltip: context.l10n.more_actions,
      headings: [
        Text(
          context.l10n.more_actions,
          style: textTheme.bodyLarge,
        ),
      ],
      onSelected: (action) async {
        switch (action) {
          case "download":
            {
              final confirmed = audioSource == AudioSource.piped ||
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return const ConfirmDownloadDialog();
                    },
                  );
              if (confirmed != true) return;
              await downloader.batchAddToQueue(selectedTracks);
              trackViewState.deselectAll();
              break;
            }
          case "add-to-playlist":
            {
              if (context.mounted) {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return PlaylistAddTrackDialog(
                      openFromPlaylist: props.collectionId,
                      tracks: selectedTracks.toList(),
                    );
                  },
                );
              }
              break;
            }
          case "play-next":
            {
              playlistNotifier.addTracksAtFirst(selectedTracks);
              playlistNotifier.addCollection(props.collectionId);
              trackViewState.deselectAll();
              break;
            }
          case "add-to-queue":
            {
              playlistNotifier.addTracks(selectedTracks);
              playlistNotifier.addCollection(props.collectionId);
              trackViewState.deselectAll();
              break;
            }
          default:
        }
      },
      icon: const Icon(SpotubeIcons.moreVertical),
      children: [
        PopSheetEntry(
          value: "download",
          leading: const Icon(SpotubeIcons.download),
          enabled: selectedTracks.isNotEmpty,
          title: Text(
            context.l10n.download_count(selectedTracks.length),
          ),
        ),
        PopSheetEntry(
          value: "add-to-playlist",
          leading: const Icon(SpotubeIcons.playlistAdd),
          enabled: selectedTracks.isNotEmpty,
          title: Text(
            context.l10n.add_count_to_playlist(selectedTracks.length),
          ),
        ),
        PopSheetEntry(
          enabled: selectedTracks.isNotEmpty,
          value: "add-to-queue",
          leading: const Icon(SpotubeIcons.queueAdd),
          title: Text(
            context.l10n.add_count_to_queue(selectedTracks.length),
          ),
        ),
        PopSheetEntry(
          enabled: selectedTracks.isNotEmpty,
          value: "play-next",
          leading: const Icon(SpotubeIcons.lightning),
          title: Text(
            context.l10n.play_count_next(selectedTracks.length),
          ),
        ),
      ],
    );
  }
}
