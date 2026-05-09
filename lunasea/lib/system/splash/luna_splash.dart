import 'package:flutter/material.dart';

import 'package:lunasea/widgets/ui/wada_theme.dart';

/// Themed splash overlay shown briefly on cold start.
///
/// The native iOS LaunchScreen is baked at compile time and cannot follow
/// the user-selected Wada theme — it shows a neutral solid colour. As soon
/// as Flutter starts and Hive is initialised, this widget overlays the
/// router with the branding of the active theme so the boot sequence ends
/// in the user's chosen palette rather than the static one shipped with
/// the binary.
class LunaSplash extends StatelessWidget {
  const LunaSplash({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = WadaTheme.active;
    return Material(
      color: theme.palette.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Image.asset(
            theme.brandingFullAsset,
            width: 280,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
