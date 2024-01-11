import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotube/components/shared/image/universal_image.dart';

final _paletteColorState = StateProvider<PaletteColor>(
  (ref) {
    return PaletteColor(Colors.grey[300]!, 0);
  },
);

PaletteColor usePaletteColor(String imageUrl, WidgetRef ref) {
  final context = useContext();
  final theme = Theme.of(context);
  final paletteColor = ref.watch(_paletteColorState);
  final mounted = useIsMounted();

  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final palette = await PaletteGenerator.fromImageProvider(
        UniversalImage.imageProvider(
          imageUrl,
          height: 50,
          width: 50,
        ),
      );
      if (!mounted()) return;
      final color = theme.brightness == Brightness.light
          ? palette.lightMutedColor ?? palette.lightVibrantColor
          : palette.darkMutedColor ?? palette.darkVibrantColor;
      if (color != null) {
        ref.read(_paletteColorState.notifier).state = color;
      }
    });
    return null;
  }, [imageUrl]);

  return paletteColor;
}

PaletteGenerator usePaletteGenerator(String imageUrl) {
  final palette = useState(PaletteGenerator.fromColors([]));
  final mounted = useIsMounted();

  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final newPalette = await PaletteGenerator.fromImageProvider(
        UniversalImage.imageProvider(
          imageUrl,
          height: 50,
          width: 50,
        ),
      );
      if (!mounted()) return;

      palette.value = newPalette;
    });
    return null;
  }, [imageUrl]);

  return palette.value;
}
