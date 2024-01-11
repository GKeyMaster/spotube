import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/themed_button_tab_bar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/utils/use_custom_status_bar_color.dart';
import 'package:spotube/hooks/utils/use_palette_color.dart';
import 'package:spotube/pages/lyrics/plain_lyrics.dart';
import 'package:spotube/pages/lyrics/synced_lyrics.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class LyricsPage extends HookConsumerWidget {
  final bool isModal;
  const LyricsPage({Key? key, this.isModal = false}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    String albumArt = useMemoized(
      () => TypeConversionUtils.image_X_UrlString(
        playlist.activeTrack?.album?.images,
        index: (playlist.activeTrack?.album?.images?.length ?? 1) - 1,
        placeholder: ImagePlaceholder.albumArt,
      ),
      [playlist.activeTrack?.album?.images],
    );
    final palette = usePaletteColor(albumArt, ref);
    final mediaQuery = MediaQuery.of(context);

    useCustomStatusBarColor(
      palette.color,
      true,
      noSetBGColor: true,
    );

    final tabbar = ThemedButtonsTabBar(
      tabs: [
        Tab(text: "  ${context.l10n.synced}  "),
        Tab(text: "  ${context.l10n.plain}  "),
      ],
    );

    final auth = ref.watch(AuthenticationNotifier.provider);

    if (auth == null) {
      return Scaffold(
        appBar: !kIsMacOS && !isModal ? const PageWindowTitleBar() : null,
        body: const AnonymousFallback(),
      );
    }

    if (isModal) {
      return DefaultTabController(
        length: 2,
        child: SafeArea(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background.withOpacity(.4),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Container(
                    height: 7,
                    width: 150,
                    decoration: BoxDecoration(
                      color: palette.titleTextColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  AppBar(
                    leadingWidth: double.infinity,
                    leading: tabbar,
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: const Icon(SpotubeIcons.minimize),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SyncedLyrics(palette: palette, isModal: isModal),
                        PlainLyrics(palette: palette, isModal: isModal),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        bottom: mediaQuery.mdAndUp,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: !kIsMacOS
              ? PageWindowTitleBar(
                  backgroundColor: Colors.transparent,
                  title: tabbar,
                )
              : tabbar,
          body: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: UniversalImage.imageProvider(albumArt),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
              ),
            ),
            margin: const EdgeInsets.only(bottom: 10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: ColoredBox(
                color: palette.color.withOpacity(.7),
                child: SafeArea(
                  child: TabBarView(
                    children: [
                      SyncedLyrics(palette: palette, isModal: isModal),
                      PlainLyrics(palette: palette, isModal: isModal),
                    ],
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
