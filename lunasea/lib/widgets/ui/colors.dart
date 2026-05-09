import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';

class LunaColours {
  /// Core accent colour — bright highlight, derived from the active Wada
  /// theme's `secondary` (the "moon" colour in the icon).
  static Color get accent => WadaTheme.active.palette.secondary;

  /// Core primary colour (background canvas) — Wada `background`.
  static Color get primary => WadaTheme.active.palette.background;

  /// Core secondary colour (appbar, bottom bar, cards, dialogs) —
  /// Wada `surface` (slight lift over background).
  static Color get secondary => WadaTheme.active.palette.surface;

  /// Wada `primary` — used for the wave-coloured details (logo overlays,
  /// secondary chrome). Only available through the themed palette.
  static Color get wadaPrimary => WadaTheme.active.palette.primary;

  /// Wada `accent` — soft wordmark / focus-ring colour, lighter than
  /// [accent].
  static Color get wadaAccent => WadaTheme.active.palette.accent;

  /// List of LunaSea colours in order that they should appear in a list.
  ///
  /// Use [byListIndex] to fetch the colour at any index. Built lazily because
  /// [accent] is no longer a compile-time constant.
  static List<Color> get _listColorIcons => [
        blue,
        accent,
        red,
        orange,
        purple,
        blueGrey,
      ];

  static const Color blue = Color(0xFF00A8E8);
  static const Color blueGrey = Color(0xFF848FA5);
  static const Color grey = Color(0xFFBBBBBB);
  static const Color orange = Color(0xFFFF9000);
  static const Color purple = Color(0xFF9649CB);
  static const Color red = Color(0xFFF71735);

  /// Shades of White
  static const Color white = Color(0xFFFFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);

  /// Returns the correct colour for a graph by what layer it is on the graph canvas.
  Color byGraphLayer(int index) {
    switch (index) {
      case 0:
        return LunaColours.accent;
      case 1:
        return LunaColours.purple;
      case 2:
        return LunaColours.blue;
      default:
        return byListIndex(index);
    }
  }

  /// Return the correct colour for a list.
  /// If the index is greater than the list of colour's length, uses modulus to loop list.
  Color byListIndex(int index) {
    final list = _listColorIcons;
    return list[index % list.length];
  }
}

extension LunaColor on Color {
  Color disabled([bool condition = true]) {
    if (condition) return this.withOpacity(LunaUI.OPACITY_DISABLED);
    return this;
  }

  Color enabled([bool condition = true]) {
    if (condition) return this;
    return this.withOpacity(LunaUI.OPACITY_DISABLED);
  }

  Color selected([bool condition = true]) {
    if (condition) return this.withOpacity(LunaUI.OPACITY_SELECTED);
    return this;
  }

  Color dimmed() => this.withOpacity(LunaUI.OPACITY_DIMMED);
}
