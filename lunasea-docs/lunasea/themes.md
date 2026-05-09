# Themes

LunaSea+ ships with a curated set of **six colour themes** inspired by Sanzo Wada's *A Dictionary of Color Combinations* (1933). Each theme bundles a coordinated palette and a matching logo — switching themes restyles the chrome, accent colour, dialogs, focus rings, splash, and the drawer header logo all at once.

{% hint style="info" %}
This is a LunaSea+ feature and is not present in the original LunaSea on the App Store. Themes only affect the in-app appearance — see *Limitations* below for what stays static.
{% endhint %}

## Available themes

| Theme | Tagline |
|---|---|
| **Indigo Dusk** *(default)* | Indigo nuit + bleu poussiéreux |
| **Cerulean & Sand** | Céruléen vintage + sable doré |
| **Pine & Linen** | Pin profond + lin avoine |
| **Rust & Celadon** | Rouille + céladon (signature Wada) |
| **Madder & Bone** | Garance vintage + os doré |
| **Plum & Ochre** | Prune + ocre moutarde |

Each theme defines five colour roles:

- `background` — deepest dark, used as the canvas, drawer and icon background
- `primary` — mid-tone, the "wave" colour in the icon
- `secondary` — bright accent, the "moon" colour, used as the in-app highlight
- `accent` — soft wordmark / focus-ring colour
- `surface` — slight lift over the background, for cards / app bar / dialogs

## Switching themes

Head to **Settings → General**, then scroll to the **Wada Themes** section. Tap any tile to switch instantly — the entire app rebuilds with the new palette and logo.

Your selection is persisted across launches.

## Compatibility with the AMOLED toggle

The Wada theme system is independent from the **AMOLED** toggle (also in **Settings → General → Appearance**). When AMOLED is enabled the chrome turns pure black for OLED screens, but accents, splash, drawer header logo, and the rest of the themed elements still follow the Wada theme you picked. The two settings layer cleanly.

## Limitations

The following stay static regardless of the active theme:

- **Home-screen icon** — baked at compile time. Currently set to **Rust & Celadon** for the LunaSea+ fork. Dynamic per-theme home-screen swap is on the roadmap (iOS Alternate Icons / Android activity-aliases).
- **Native launch screen** — the very first screen iOS / Android shows before Flutter starts is a neutral dark colour (`#1B1E27`). The themed splash takes over the moment Flutter mounts.
- **Service brand colours** — Lidarr stays green, Sonarr stays blue, Radarr stays yellow, etc. These are intentionally preserved so each service keeps its own visual identity in the drawer and app bar.
