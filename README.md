[README.md](https://github.com/user-attachments/files/22383245/README.md)
# BubblePop

A fast, minimalist SwiftUI hyper-casual tap game. Pop balls, stack points, unlock styles. Built and authored by **Momin Waleed**. Project initiation with co-author **Fajar Sajid**.

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
├─ BubblePop.xcodeproj
├─ BubblePop/                # App target sources
│  ├─ App/                   # App entry (App.swift), routing
│  ├─ Game/                  # Game logic, spawn rules, timers
│  ├─ Views/                 # SwiftUI screens (Start, Game, Settings, About)
│  ├─ Audio/                 # Pop sounds (placeholders to drop in)
│  ├─ Resources/             # Info.plist, AUTHOR.txt etc...
│  └─ AuthorInfo.swift       # Author metadata (compiled into app)
├─ Assets.xcassets/          # App icon, balls, backgrounds
├─ README.md
├─ LICENSE
└─ AUTHOR.md
```

---

## Configuration & Customization

### Author (built-in)
- **Info.plist** → add custom key: `AuthorName = "Momin Waleed"`  
- **AuthorInfo.swift**:
```swift
public enum AuthorInfo {
    public static let authorName = "Momin Waleed"
    public static let authorContact = "mominwaleed9089@gmail.com" 
}
```

### Sounds
Drop three `.wav` or `.mp3` files into `BubblePop/Audio/` and replace the placeholders in the sound loader (look for the “// TODO: add pop sounds here” comment).

### Balls & Backgrounds
- Add images into `Assets.xcassets` (e.g., `BallRed`, `BallBlue`, `BGPurple`, …)  
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
- Accessibility pass (Dynamic Type, VoiceOver hints)  
- iPad & Mac (Catalyst) layouts

---

## Contributing
Issues and pull requests are welcome.  
Please keep PRs focused and include a brief demo (screens/GIF).

---

## License
This project is licensed under the **MIT License** – see [`LICENSE`](./LICENSE) for details.

---

## Credits
**Author:** Momin Waleed  
**Co-Author:** Fajar Sajid

Code headers and bundle metadata include author attribution.

---

