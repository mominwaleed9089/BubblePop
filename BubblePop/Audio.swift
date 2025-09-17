import Foundation
import AVFoundation
import UIKit

final class AudioManager {
    static let shared = AudioManager()

    private let session = AVAudioSession.sharedInstance()

    // MARK: Pops (round-robin)
    private var pops: [AVAudioPlayer] = []
    private var nextIndex = 0

    // MARK: Specials
    private var bombPlayer: AVAudioPlayer?
    private var swooshPlayer: AVAudioPlayer?
    private var tickPlayer: AVAudioPlayer?
    private var goldPlayer: AVAudioPlayer?

    // ====== CHANGE THESE BASE NAMES TO MATCH YOUR FILES (no extension) ======
    private let popBaseNames   = ["sound1", "sound2", "sound3"] // your 3 pops
    private let bombBaseName   = "bomb1"     // e.g., bomb.mp3 / bomb.wav
    private let swooshBaseName = "point1"   // e.g., swoosh.mp3 / swoosh.wav
    private let tickBaseName   = "time1"     // e.g., tick.mp3 / tick.caf
    private let goldBaseName   = "life1"
    // ========================================================================

    // We’ll try these extensions in order for every file:
    private let tryExtensions = ["mp3", "wav", "caf"]

    private init() {
        configureSession()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appBecameActive),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        preloadAll()
    }

    @objc private func appBecameActive() {
        // Ensure session stays active after interruptions
        try? session.setActive(true)
    }

    private func configureSession() {
        do {
            // .playback → plays even if hardware silent switch is ON
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("🔇 Audio session error:", error)
        }
    }

    private func preloadAll() {
        preloadPops()
        bombPlayer   = loadOne(base: bombBaseName)
        swooshPlayer = loadOne(base: swooshBaseName)
        tickPlayer   = loadOne(base: tickBaseName)
        goldPlayer   = loadOne(base: goldBaseName)
    }

    // MARK: Loaders

    private func preloadPops() {
        pops.removeAll()
        for base in popBaseNames {
            if let player = loadOne(base: base) {
                pops.append(player)
            } else {
                print("⚠️ Pop file not found for base name:", base, "(tried: \(tryExtensions.joined(separator: ",")))")
            }
        }
        if pops.isEmpty { print("❗No pop sounds preloaded. Check filenames & target membership.") }
    }

    /// Try multiple extensions until one loads.
    private func loadOne(base: String) -> AVAudioPlayer? {
        for ext in tryExtensions {
            if let url = Bundle.main.url(forResource: base, withExtension: ext) {
                do {
                    let p = try AVAudioPlayer(contentsOf: url)
                    p.prepareToPlay()
                    p.volume = 1.0
                    print("✅ Loaded sound:", base + "." + ext)
                    return p
                } catch {
                    print("⚠️ Failed to load \(base).\(ext):", error)
                }
            }
        }
        print("❌ Missing sound in bundle for base:", base, "(extensions tried: \(tryExtensions))")
        return nil
    }

    // MARK: Playback API (same signatures you’re using)

    func playRandomPop(muted: Bool) {
        guard !muted, !pops.isEmpty else { return }
        nextIndex = (nextIndex + 1) % pops.count
        let player = pops[nextIndex]
        player.currentTime = 0
        player.play()
    }

    func playBomb(muted: Bool) {
        guard !muted, let p = bombPlayer else { return }
        p.currentTime = 0
        p.play()
    }

    func playSwoosh(muted: Bool) {
        guard !muted, let p = swooshPlayer else { return }
        p.currentTime = 0
        p.play()
    }

    func playTick(muted: Bool) {
        guard !muted, let p = tickPlayer else { return }
        p.currentTime = 0
        p.play()
    }
    func playGold(muted: Bool) {   // 🔔 new
           guard !muted, let p = goldPlayer else { return }
           p.currentTime = 0
           p.play()
       }

    // Legacy
    func playSound() {
        playRandomPop(muted: false)
    }
}
