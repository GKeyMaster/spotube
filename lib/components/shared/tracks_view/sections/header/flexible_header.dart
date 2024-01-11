import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/playbutton_card.dart';
import 'package:spotube/components/shared/tracks_view/sections/header/header_actions.dart';
import 'package:spotube/components/shared/tracks_view/sections/header/header_buttons.dart';
import 'package:spotube/components/shared/tracks_view/track_view_props.dart';
import 'package:gap/gap.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/hooks/utils/use_palette_color.dart';

class TrackViewFlexHeader extends HookConsumerWidget {
  const TrackViewFlexHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final props = InheritedTrackView.of(context);
    final ThemeData(:colorScheme, :textTheme, :iconTheme) = Theme.of(context);
    final defaultTextStyle = DefaultTextStyle.of(context);
    final mediaQuery = MediaQuery.of(context);

    final description = useDescription(props.description);

    final palette = usePaletteColor(props.image, ref);

    return IconTheme(
      data: iconTheme.copyWith(color: palette.bodyTextColor),
      child: SliverLayoutBuilder(
        builder: (context, constrains) {
          final isExpanded = constrains.scrollOffset < 350;

          final headingStyle = (mediaQuery.mdAndDown
                  ? textTheme.headlineSmall
                  : textTheme.headlineMedium)
              ?.copyWith(
            color: palette.bodyTextColor,
          );
          return SliverAppBar(
            iconTheme: iconTheme.copyWith(
              color: palette.bodyTextColor,
              size: 16,
            ),
            actions: isExpanded
                ? []
                : [
                    const TrackViewHeaderActions(),
                    TrackViewHeaderButtons(compact: true, color: palette),
                  ],
            floating: false,
            pinned: true,
            expandedHeight: 450,
            automaticallyImplyLeading: DesktopTools.platform.isMobile,
            backgroundColor: palette.color,
            title: isExpanded ? null : Text(props.title, style: headingStyle),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(props.image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black45,
                          colorScheme.surface,
                        ],
                        begin: const FractionalOffset(0, 0),
                        end: const FractionalOffset(0, 1),
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: mediaQuery.mdAndDown
                                    ? mediaQuery.size.width
                                    : 800,
                              ),
                              child: Flex(
                                direction: mediaQuery.mdAndDown
                                    ? Axis.vertical
                                    : Axis.horizontal,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: UniversalImage(
                                      path: props.image,
                                      width: 200,
                                      height: 200,
                                      placeholder: Assets.albumPlaceholder.path,
                                    ),
                                  ),
                                  const Gap(20),
                                  Flexible(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: mediaQuery.mdAndDown
                                          ? CrossAxisAlignment.center
                                          : CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          props.title,
                                          style: headingStyle,
                                          textAlign: mediaQuery.mdAndDown
                                              ? TextAlign.center
                                              : TextAlign.start,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 10),
                                        if (description != null &&
                                            description.isNotEmpty)
                                          Text(
                                            description,
                                            style:
                                                defaultTextStyle.style.copyWith(
                                              color: palette.bodyTextColor,
                                            ),
                                            textAlign: mediaQuery.mdAndDown
                                                ? TextAlign.center
                                                : TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        const Gap(10),
                                        const TrackViewHeaderActions(),
                                        const Gap(10),
                                        TrackViewHeaderButtons(color: palette),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
