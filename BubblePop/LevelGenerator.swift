import Foundation

enum LevelGenerator {
    static func generate100() -> [Level] {
        var levels: [Level] = []

        for i in 1...100 {
            // Buckets of 10 to change flavor
            let bucket = (i - 1) / 10
            let posInBucket = (i - 1) % 10

            var target: Int? = nil
            var timeLimit: Int? = 60
            var lives = 3
            var redChance = 0.06
            var specials = true
            var name = "Level \(i)"
            var blurb = "Tap bubbles!"

            switch bucket {
            case 0: // 1–10: gentle intro, time-attack
                target = 10 + posInBucket * 3     // 10 → 37
                timeLimit = 25 + posInBucket * 2  // 25 → 43
                redChance = 0.03 + Double(posInBucket) * 0.004
                blurb = "Time-Attack: Tap \(target!) bubbles in \(timeLimit!)s."
            case 1: // 11–20: faster reds, same lives
                target = 18 + posInBucket * 3
                timeLimit = 24 + posInBucket * 2
                redChance = 0.05 + Double(posInBucket) * 0.006
                blurb = "Speed: Faster reds. Get \(target!) taps in \(timeLimit!)s!"
            case 2: // 21–30: accuracy—1 life for 10th
                target = 20 + posInBucket * 4
                timeLimit = 22 + posInBucket * 2
                redChance = 0.06 + Double(posInBucket) * 0.007
                lives = posInBucket == 9 ? 1 : 2
                blurb = "Accuracy: \(lives) life. Hit \(target!) in \(timeLimit!)s."
            case 3: // 31–40: survival—no timer, fixed taps, 1 life at end
                target = 25 + posInBucket * 3
                timeLimit = posInBucket == 9 ? nil : 20 + posInBucket * 2
                lives = posInBucket >= 6 ? 1 : 2
                redChance = 0.07 + Double(posInBucket) * 0.007
                if let t = timeLimit {
                    blurb = "Survive: \(lives) life. Score \(target!) before \(t)s."
                } else {
                    blurb = "Survive: \(lives) life. Score \(target!) — no timer!"
                }
            case 4: // 41–50: specials off (focus), tighter time
                target = 28 + posInBucket * 3
                timeLimit = 22 + posInBucket * 2
                specials = false
                redChance = 0.08 + Double(posInBucket) * 0.006
                blurb = "Focus: No powerups. \(target!) taps in \(timeLimit!)s."
            case 5: // 51–60: chaos, more reds but 3 lives
                target = 30 + posInBucket * 4
                timeLimit = 24 + posInBucket * 2
                lives = 3
                redChance = 0.10 + Double(posInBucket) * 0.008
                blurb = "Chaos: Reds abound! \(target!) in \(timeLimit!)s."
            case 6: // 61–70: endurance—long time, higher target
                target = 45 + posInBucket * 4
                timeLimit = 35 + posInBucket * 2
                redChance = 0.09 + Double(posInBucket) * 0.005
                blurb = "Endurance: \(target!) taps in \(timeLimit!)s."
            case 7: // 71–80: minimal lives, short time
                target = 40 + posInBucket * 3
                timeLimit = 20 + posInBucket * 2
                lives = 1
                redChance = 0.11 + Double(posInBucket) * 0.007
                blurb = "One-Life: \(target!) in \(timeLimit!)s. Don’t miss!"
            case 8: // 81–90: survival + specials on
                target = 45 + posInBucket * 3
                timeLimit = posInBucket % 3 == 0 ? nil : (22 + posInBucket * 2)
                lives = posInBucket >= 5 ? 1 : 2
                redChance = 0.12 + Double(posInBucket) * 0.007
                specials = true
                if let t = timeLimit {
                    blurb = "Survival+: \(lives) life. \(target!) before \(t)s."
                } else {
                    blurb = "Survival+: \(lives) life. \(target!) — no timer!"
                }
            default: // 91–100: final exam
                target = 60 + posInBucket * 4
                timeLimit = 28 + posInBucket * 2
                lives = posInBucket >= 5 ? 1 : 2
                redChance = 0.14 + Double(posInBucket) * 0.008
                specials = true
                blurb = "Final: \(lives) life. \(target!) taps in \(timeLimit!)s."
            }

            let lvl = Level(
                id: i,
                name: name,
                targetTaps: target,
                timeLimit: timeLimit,
                lives: lives,
                redChance: redChance,
                enableSpecials: specials,
                blurb: blurb
            )
            levels.append(lvl)
        }

        return levels
    }
}
