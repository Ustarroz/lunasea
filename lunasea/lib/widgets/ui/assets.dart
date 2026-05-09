import 'package:lunasea/widgets/ui/wada_theme.dart';

class LunaAssets {
  LunaAssets._();

  /// Branding splash (logo + wordmark) for the active Wada theme.
  static String get brandingFull => WadaTheme.active.brandingFullAsset;

  /// Branding logo (icon only) for the active Wada theme.
  static String get brandingLogo => WadaTheme.active.brandingLogoAsset;
}
