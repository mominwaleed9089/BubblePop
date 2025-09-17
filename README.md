[README.md](https://github.com/user-attachments/files/22383245/README.md)
# BubblePop

A fast, minimalist SwiftUI hyper-casual tap game that tests reaction time while rewarding the fidgeting itch to do something. Pop balls, stack points, unlock styles. Built and authored by **Momin Waleed**. This Project was a course project that was initiated with co-author **Fajar Sajid** and has been a passion project for the past year now completed to a somewhat completionary state. More updates will be brought later on improving the now current variant of the app.

## Features
-  **One-tap gameplay** with snappy feedback
-  **Ball selector** — pick different ball styles
-  **Theme/background picker**
-  **Settings mini-panel** with mute toggle for pop sounds
-  **Points as in-game currency** (persists locally)
-  **Risk mode** (spicier spawns & timing)
-  Local save for scores/preferences (no login required)

> Credit is embedded in the codebase and app bundle (see `AuthorInfo.swift` and `Info.plist` → `AuthorName`).

---

## Tech Stack
- **Language:** Swift 5+
- **UI:** SwiftUI
- **Minimum iOS:** 16.0 (adjust in target settings if needed)
- **IDE:** Xcode 15+

---

## Getting Started

### 1) Clone
```bash
# HTTPS
git clone https://github.com/mominwaleed9089/BubblePop.git
cd BubblePop

# or SSH
# git clone git@github.com:mominwaleed9089/BubblePop.git
```

### 2) Open & Run
1. Open `BubblePop.xcodeproj` in Xcode  
2. Select an iPhone simulator (e.g., iPhone 15)  
3. Press **Run** (⌘R)

---

## Project Structure (high-level)

```
BubblePop/
├── BubblePopApp.swift          // App entry point
├── Models/
│   ├── Ball.swift              // Ball struct
│   ├── BallType.swift          // Enum + extensions (colors, icons)
│   ├── GameMode.swift          // Enum: normal, risk
│   ├── Level.swift             // (Future: time trial levels)
│   └── PlayerProgress.swift    // Persistence, unlocks, high scores
│
├── Engine/
│   ├── GameEngine.swift        // Game loop, spawning, scoring, lives
│   └── AudioManager.swift      // Sound playback
│
├── Views/
│   ├── RootView.swift          // Main menu with neon UI + tips
│   ├── ModeSelectView.swift    // Choose Normal / Risk+
│   ├── GameView.swift          // Hosts live game session
│   ├── BallView.swift          // Renders bubbles / icons
│   ├── HUDView.swift           // Top HUD (score, timer, lives, pause)
│   ├── PauseOverlay.swift      // Floating pause menu
│   ├── GameOverOverlay.swift   // Clean end screen
│   ├── AchievementsShopView.swift // Unlock balls & backgrounds
│   └── TipRotator.swift        // Bottom tip text rotator
│
├── Resources/
│   ├── Assets.xcassets/        // App icon, colors, sound files
│   │   ├── sound1.mp3
│   │   ├── sound2.mp3
│   │   ├── sound3.mp3
│   │   ├── bomb.mp3
│   │   ├── point1.mp3
│   │   ├── time1.mp3
│   │   └── life1.mp3
│   └── LaunchScreen.storyboard // Optional custom launch
│
├── Utilities/
│   ├── Palette.swift           // Color palettes & backgrounds
│   └── Extensions.swift        // Array[safe:], Color(hex:)
│
└── README.md                   // Project info, setup, gameplay description

```

---

```

### Sounds
Drop three `.wav` or `.mp3` files into `BubblePop/Audio/` and replace the placeholders in the sound loader.

### Balls & Backgrounds
- Add images into `Assets.xcassets` (e.g., `BallRed`, `BallBlue`, `BGPurple`, …)
- Need to code the images in so it works with the GameEngine.
- Update the arrays in the selector view to include your new asset names.

### Settings / Persistence
- Mute state, selected ball/background, and points are stored with `UserDefaults`.  
- If you reset the app or delete it, local points/settings reset by design.

---

## Build & Deployment

- **Signing:** Use your Apple Developer account for device builds / TestFlight.  
- **Bundle ID:** Set in target → *General* → *Bundle Identifier*.  
- **Versioning:** Bump `Marketing Version` and `Build` in target settings before releases.

---

## Roadmap
- Haptics & particle effects  
- Game Center leaderboards  
- Daily challenges / streak bonuses  
- iPad & Mac (Catalyst) layouts

---

## Contributing
Issues and pull requests are welcome.  
Please keep PRs focused and include a brief demo (screens/GIF).

---

## License
This project is licensed under the **GNU GENERAL PUBLIC LICENSE v3** – see [`LICENSE`](./LICENSE) for details.

---

## Credits
**Author:** Momin Waleed  
**Co-Author:** Fajar Sajid

Code headers and bundle metadata include author attribution.

---

