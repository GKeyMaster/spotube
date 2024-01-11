import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/utils/use_breakpoint_value.dart';
import 'package:spotube/hooks/utils/use_brightness_value.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class ArtistCard extends HookConsumerWidget {
  final Artist artist;
  const ArtistCard(this.artist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final backgroundImage = UniversalImage.imageProvider(
      TypeConversionUtils.image_X_UrlString(
        artist.images,
        placeholder: ImagePlaceholder.artist,
      ),
    );
    final isBlackListed = ref.watch(
      BlackListNotifier.provider.select(
        (blacklist) => blacklist.contains(
          BlacklistedElement.artist(artist.id!, artist.name!),
        ),
      ),
    );

    final radius = BorderRadius.circular(15);

    final double size = useBreakpointValue<double>(
      xs: 130,
      sm: 130,
      md: 150,
      others: 170,
    );

    return Container(
      width: size,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        shadowColor: theme.colorScheme.background,
        color: Color.lerp(
          theme.colorScheme.surfaceVariant,
          theme.colorScheme.surface,
          useBrightnessValue(.9, .7),
        ),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: isBlackListed
              ? const BorderSide(
                  color: Colors.red,
                  width: 2,
                )
              : BorderSide.none,
        ),
        child: InkWell(
            onTap: () {
              ServiceUtils.push(context, "/artist/${artist.id}");
            },
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: size,
                        ),
                        child: CircleAvatar(
                          backgroundImage: backgroundImage,
                          radius: size / 2,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50)),
                          child: Skeleton.ignore(
                            child: Text(
                              context.l10n.artist,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  AutoSizeText(
                    artist.name!,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
