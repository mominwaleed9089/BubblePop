// SettingsStore.swift
import SwiftUI

final class SettingsStore: ObservableObject {
    @Published var isMuted: Bool {
        didSet { UserDefaults.standard.set(isMuted, forKey: "isMuted") }
    }

    init() {
        self.isMuted = UserDefaults.standard.bool(forKey: "isMuted")
    }
}
