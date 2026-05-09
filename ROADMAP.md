# LunaSea — Roadmap de reprise

Projet archivé en avril 2025 (v11.0.0). Objectif : remettre l'app en état de marche pour usage perso, puis republier pour la communauté.

> **Contexte clé :**
> - Le cœur de l'app (pilotage Sonarr/Radarr/etc.) se connecte **directement** aux APIs locales — aucun serveur nécessaire pour cette partie.
> - Le notification service (Firebase + Redis) n'est utile **que** pour les push notifications. C'est optionnel.
> - Il n'y a **aucun test** dans le projet — chaque changement doit être validé manuellement.

---

## Phase 1 — Faire tourner l'app en local *(priorité absolue)*

> Objectif : avoir l'app qui compile et qui pilote Sonarr/Radarr sur un téléphone de dev.

- [x] Mettre à jour les dépendances Flutter (`flutter pub upgrade`)
- [x] Corriger les erreurs de compilation dues aux dépendances obsolètes
- [x] Régénérer les fichiers de code généré (`npm run generate`)
- [x] Vérifier que `flutter analyze` passe sans erreurs bloquantes
- [x] Tester le build en debug sur un appareil physique iOS
- [ ] Différencier visuellement l'app dev de l'app App Store originale :
  - [x] Renommer le display name → `LunaSea+` (`CFBundleDisplayName` dans `ios/Runner/Info.plist`)
  - [ ] Créer/adapter une icône custom (`assets/icon/icon.png` — 1024x1024)
  - [ ] Régénérer les icônes via `dart run flutter_launcher_icons`
- [ ] Valider la connexion à une instance Sonarr locale
- [ ] Valider la connexion à une instance Radarr locale
- [ ] Identifier les fonctionnalités visiblement cassées à l'usage

---

## Phase 2 — Audit et remise en conformité des APIs

> Objectif : s'assurer que l'app est compatible avec les versions actuelles des services supportés.

### Sonarr
- [ ] Vérifier la compatibilité avec **Sonarr v4** (l'API a changé significativement depuis v3)
- [ ] Tester toutes les routes principales : catalogue, détails série, recherche, queue, historique
- [ ] Corriger les endpoints cassés ou renommés

### Radarr
- [ ] Vérifier la compatibilité avec **Radarr v5**
- [ ] Tester toutes les routes principales : catalogue, détails film, recherche, queue, historique
- [ ] Corriger les endpoints cassés ou renommés

### Autres modules
- [ ] Lidarr — vérifier la version API supportée
- [ ] SABnzbd — vérifier la compatibilité
- [ ] NZBGet — vérifier la compatibilité (NZBGet est en fin de vie, à noter)
- [ ] Tautulli — vérifier la compatibilité

### Qualité générale
- [ ] Passer en revue les `TODO` et `FIXME` dans le code
- [ ] Mettre à jour `modal_bottom_sheet` (bloqué sur `3.0.0-pre`)
- [ ] Évaluer si d'autres dépendances majeures ont des breaking changes

---

## Phase 3 — Infrastructure de notifications *(optionnelle)*

> Objectif : remettre le système de push notifications en état pour les utilisateurs qui le souhaitent.
> Cette phase est indépendante — l'app fonctionne sans elle.

### Firebase
- [ ] Créer un nouveau projet Firebase
- [ ] Configurer Firebase Auth, Firestore, FCM, Storage, Cloud Functions
- [ ] Mettre à jour `lunasea-cloud-functions` : Node.js 14 → 18+, firebase-functions v3 → v4
- [ ] Déployer les Cloud Functions
- [ ] Mettre à jour les fichiers de config Firebase dans l'app Flutter (`google-services.json`, `GoogleService-Info.plist`)

### Notification service
- [ ] Mettre à jour `firebase-admin` v11 → v12
- [ ] Tester le service en local avec Docker
- [ ] Choisir un hébergement (Oracle Free Tier / Hetzner / autre)
- [ ] Déployer le service
- [ ] Mettre à jour les URLs dans l'app (`lib/system/webhooks.dart`)
- [ ] Tester le flux complet : webhook Sonarr → notification sur téléphone

---

## Phase 4 — Publication sur les stores

> Objectif : rendre l'app disponible publiquement.

### Prérequis légaux / branding
- [ ] Décider du nom de l'app (garder "LunaSea" ou renommer ?)
- [ ] Vérifier les conditions de la licence du projet original
- [ ] Préparer les assets store (screenshots, descriptions, icônes)

### iOS — App Store
- [ ] Souscrire à l'Apple Developer Program (99$/an)
- [ ] Configurer les certificats et profils de provisioning
- [ ] **Restaurer les capabilities iOS désactivées pour le dev perso :**
  - [ ] `com.apple.developer.networking.wifi-info` (nécessaire pour Wake on LAN)
  - [ ] `com.apple.developer.associated-domains` → `webcredentials:www.lunasea.app` (deep links)
  - [ ] Fichier concerné : `lunasea/ios/Runner/Runner.entitlements`
- [ ] Créer la fiche app sur App Store Connect
- [ ] Soumettre pour review Apple
- [ ] Mettre en place TestFlight pour les bêta-testeurs

### Android — Google Play
- [ ] Créer un compte Google Play Developer (25$ one-time)
- [ ] Configurer la signature de l'APK/AAB
- [ ] Créer la fiche app sur Google Play Console
- [ ] Soumettre l'app

---

## Phase 5 — Maintenance continue *(après publication)*

- [ ] Mettre en place un système de suivi des issues (GitHub Issues)
- [ ] Définir une politique de versioning et de releases
- [ ] Surveiller les évolutions des APIs Sonarr, Radarr, Lidarr, etc.
- [ ] Ajouter des tests (au moins pour la couche API)

---

## Journal de bord

| Date | Phase | Action |
|------|-------|--------|
| 2026-05-09 | — | État des lieux initial, création du CLAUDE.md et de cette roadmap |
| 2026-05-09 | Phase 1 | Installation Flutter 3.41.9 via FVM, CocoaPods via Homebrew |
| 2026-05-09 | Phase 1 | Migration `hive` → `hive_ce` (hive abandonné, conflit source_gen) |
| 2026-05-09 | Phase 1 | Mise à jour `environment_config` v3 → v4, `google_fonts` v6 → v8 |
| 2026-05-09 | Phase 1 | Génération des 519 fichiers `.g.dart` (Hive, JSON, Retrofit) |
| 2026-05-09 | Phase 1 | ✅ Build iOS debug réussi : `Runner.app` compilé |
| 2026-05-09 | Phase 1 | Désactivation des capabilities iOS non supportées par compte Apple gratuit (Wi-Fi Info + Associated Domains) — à restaurer en Phase 4 |
| 2026-05-09 | Phase 1 | Désactivation `ENABLE_USER_SCRIPT_SANDBOXING` dans `Runner.xcodeproj` (compatibilité Xcode 15+) |
| 2026-05-09 | Phase 1 | ✅ App lancée sur iPhone physique via `flutter run` |
| 2026-05-09 | Phase 1 | Renommage app → `LunaSea+` (CFBundleDisplayName) pour distinguer de l'app store |

