import 'package:flutter/material.dart';

import 'package:lunasea/database/tables/lunasea.dart';

/// A 5-role colour palette for a Wada theme.
///
/// Roles are kept generic on purpose so callers can map them to whatever
/// surface or text they need:
///
/// * [background] — deepest dark; canvas / drawer / icon background
/// * [primary]    — mid-tone (the "wave" colour in the icon)
/// * [secondary]  — bright accent (the "moon" colour in the icon, used as
///                  in-app accent / highlight)
/// * [accent]     — soft wordmark / focus-ring colour (lighter than secondary)
/// * [surface]    — slight lift over [background], for cards / appbar / sheets
class WadaPalette {
  final Color background;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color surface;

  const WadaPalette({
    required this.background,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.surface,
  });
}

/// Six themes inspired by Sanzo Wada's *A Dictionary of Color Combinations*.
///
/// Each entry pairs a [WadaPalette] with a slug used for Hive persistence
/// and as the directory name under `assets/themes/<slug>/`.
enum WadaTheme {
  indigoDusk(
    slug: 'indigo-dusk',
    name: 'Indigo Dusk',
    tagline: 'Indigo nuit + bleu poussiéreux',
    palette: WadaPalette(
      background: Color(0xFF1C2433),
      primary: Color(0xFF2C3E5C),
      secondary: Color(0xFF8FA8C4),
      accent: Color(0xFFCFD9E8),
      surface: Color(0xFF252E3F),
    ),
  ),
  ceruleanSand(
    slug: 'cerulean-sand',
    name: 'Cerulean & Sand',
    tagline: 'Céruléen vintage + sable doré',
    palette: WadaPalette(
      background: Color(0xFF152128),
      primary: Color(0xFF2D5A7A),
      secondary: Color(0xFFC7A875),
      accent: Color(0xFFDBCAA1),
      surface: Color(0xFF1B2A33),
    ),
  ),
  pineLinen(
    slug: 'pine-linen',
    name: 'Pine & Linen',
    tagline: 'Pin profond + lin avoine',
    palette: WadaPalette(
      background: Color(0xFF1C241E),
      primary: Color(0xFF2F4A3C),
      secondary: Color(0xFFBFB68A),
      accent: Color(0xFFD6CFAC),
      surface: Color(0xFF252F27),
    ),
  ),
  rustCeladon(
    slug: 'rust-celadon',
    name: 'Rust & Celadon',
    tagline: 'Rouille + céladon',
    palette: WadaPalette(
      background: Color(0xFF211814),
      primary: Color(0xFF9C4A2A),
      secondary: Color(0xFFA8C4A0),
      accent: Color(0xFFCFDCC4),
      surface: Color(0xFF2B201B),
    ),
  ),
  madderBone(
    slug: 'madder-bone',
    name: 'Madder & Bone',
    tagline: 'Garance vintage + os doré',
    palette: WadaPalette(
      background: Color(0xFF221814),
      primary: Color(0xFF8B3A2E),
      secondary: Color(0xFFD9B679),
      accent: Color(0xFFE7C896),
      surface: Color(0xFF2C201B),
    ),
  ),
  plumOchre(
    slug: 'plum-ochre',
    name: 'Plum & Ochre',
    tagline: 'Prune + ocre moutarde',
    palette: WadaPalette(
      background: Color(0xFF221820),
      primary: Color(0xFF4A2B3F),
      secondary: Color(0xFFC99458),
      accent: Color(0xFFDEB583),
      surface: Color(0xFF2D2129),
    ),
  );

  final String slug;
  final String name;
  final String tagline;
  final WadaPalette palette;

  const WadaTheme({
    required this.slug,
    required this.name,
    required this.tagline,
    required this.palette,
  });

  /// Default theme used as a fallback when the stored slug is unknown.
  static const WadaTheme fallback = WadaTheme.indigoDusk;

  /// Theme currently selected by the user (read live from Hive).
  static WadaTheme get active {
    final slug = LunaSeaDatabase.THEME_WADA.read();
    return fromSlug(slug);
  }

  /// Resolves a slug back to a theme; returns [fallback] for unknown values.
  static WadaTheme fromSlug(String? slug) {
    if (slug == null) return fallback;
    for (final t in values) {
      if (t.slug == slug) return t;
    }
    return fallback;
  }

  /// Asset paths that vary per theme. Mirror the `assets/themes/<slug>/`
  /// directory layout produced by the design exports.
  String get brandingFullAsset => 'assets/themes/$slug/branding_full.png';
  String get brandingLogoAsset => 'assets/themes/$slug/branding_logo.png';
  String get iconAsset => 'assets/themes/$slug/icon.png';
}
