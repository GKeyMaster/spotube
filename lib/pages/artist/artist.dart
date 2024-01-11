import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/artist/artist_album_list.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/pages/artist/section/footer.dart';
import 'package:spotube/pages/artist/section/header.dart';
import 'package:spotube/pages/artist/section/related_artists.dart';
import 'package:spotube/pages/artist/section/top_tracks.dart';
import 'package:spotube/services/queries/queries.dart';

class ArtistPage extends HookConsumerWidget {
  final String artistId;
  final logger = getLogger(ArtistPage);
  ArtistPage(this.artistId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final scrollController = useScrollController();
    final theme = Theme.of(context);

    final artistQuery = useQueries.artist.get(ref, artistId);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: const PageWindowTitleBar(
          leading: BackButton(),
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Builder(builder: (context) {
          if (artistQuery.hasError) {
            return Center(child: Text(artistQuery.error.toString()));
          }
          return Skeletonizer(
            enabled: artistQuery.isLoading,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: ArtistPageHeader(artistId: artistId),
                  ),
                ),
                const SliverGap(50),
                ArtistPageTopTracks(artistId: artistId),
                const SliverGap(50),
                SliverToBoxAdapter(child: ArtistAlbumList(artistId)),
                const SliverGap(20),
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      context.l10n.fans_also_like,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                ),
                SliverSafeArea(
                  sliver: ArtistPageRelatedArtists(artistId: artistId),
                ),
                if (artistQuery.data != null)
                  SliverSafeArea(
                    top: false,
                    sliver: SliverToBoxAdapter(
                      child: ArtistPageFooter(artist: artistQuery.data!),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
