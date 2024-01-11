import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/links/hyper_link.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/controllers/use_package_info.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

final _licenseProvider = FutureProvider<String>((ref) async {
  return await rootBundle.loadString("LICENSE");
});

class AboutSpotube extends HookConsumerWidget {
  const AboutSpotube({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final packageInfo = usePackageInfo();
    final license = ref.watch(_licenseProvider);
    final theme = Theme.of(context);

    const colon = Text(":");

    return Scaffold(
      appBar: PageWindowTitleBar(
        leading: const BackButton(),
        title: Text(context.l10n.about_spotube),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Assets.spotubeLogoPng.image(
                height: 200,
                width: 200,
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      context.l10n.spotube_description,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    Table(
                      columnWidths: const {
                        0: FixedColumnWidth(95),
                        1: FixedColumnWidth(10),
                        2: IntrinsicColumnWidth(),
                      },
                      children: [
                        TableRow(
                          children: [
                            Text(context.l10n.founder),
                            colon,
                            Hyperlink(
                              context.l10n.kingkor_roy_tirtho,
                              "https://github.com/KRTirtho",
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(context.l10n.version),
                            colon,
                            Text("v${packageInfo.version}")
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(context.l10n.build_number),
                            colon,
                            Text(packageInfo.buildNumber.replaceAll(".", " "))
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(context.l10n.repository),
                            colon,
                            const Hyperlink(
                              "github.com/KRTirtho/spotube",
                              "https://github.com/KRTirtho/spotube",
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(context.l10n.license),
                            colon,
                            const Hyperlink(
                              "BSD-4-Clause",
                              "https://raw.githubusercontent.com/KRTirtho/spotube/master/LICENSE",
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Text(context.l10n.bug_issues),
                            colon,
                            const Hyperlink(
                              "github.com/KRTirtho/spotube/issues",
                              "https://github.com/KRTirtho/spotube/issues",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => launchUrl(
                    Uri.parse("https://discord.gg/uJ94vxB6vg"),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: const UniversalImage(
                    path:
                        "https://discord.com/api/guilds/1012234096237350943/widget.png?style=banner2",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                runSpacing: 20,
                spacing: 20,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        launchUrl(
                          Uri.parse("https://www.buymeacoffee.com/krtirtho"),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SvgPicture.network(
                        "https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=krtirtho&button_colour=FF5F5F&font_colour=ffffff&font_family=Inter&outline_colour=000000&coffee_colour=FFDD00",
                        height: 45,
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        launchUrl(
                          Uri.parse(
                            "https://opencollective.com/spotube",
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Image.network(
                        "https://opencollective.com/spotube/donate/button.png?color=blue",
                        height: 45,
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        launchUrl(
                          Uri.parse("https://patreon.com/krtirtho"),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Image.network(
                        "https://user-images.githubusercontent.com/61944859/180249027-678b01b8-c336-451e-b147-6d84a5b9d0e7.png",
                        height: 45,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.made_with,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
              Text(
                context.l10n.copyright(DateTime.now().year),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 20),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 750),
                child: SafeArea(
                  child: license.when(
                    data: (data) {
                      return Text(
                        data,
                        style: theme.textTheme.bodySmall,
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    error: (e, s) {
                      return Text(
                        e.toString(),
                        style: theme.textTheme.bodySmall,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
