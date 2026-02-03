//
//  KeychainService.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 01.12.2025.
//
import Valet

struct KeychainService {
    let loader: Valet

    init?() {
        guard let valetIdentifier = Identifier.init(nonEmpty: "secure.ios.uskateappv2") else { return nil }
        loader = Valet.valet(with: valetIdentifier, accessibility: .whenUnlocked)
    }
    
    func value(forKey key: String) -> String? {
        guard loader.canAccessKeychain() else { return nil }
        do {
            return try loader.string(forKey: key)
        } catch {
            return nil
        }
    }
    
    func set(value: String, for key: String) {
        guard loader.canAccessKeychain() else { return }
        do {
            try loader.setString(value, forKey: key)
        } catch {
            print(error)
        }
    }
}
