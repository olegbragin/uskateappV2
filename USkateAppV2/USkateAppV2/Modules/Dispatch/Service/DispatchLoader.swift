//
//  AuthenticationLoader.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 30.11.2025.
//

struct DispatchLoader {
    func fetchUserData() async -> Destination {
        guard
            let service = KeychainService(),
            let user = service.value(forKey: "user")
        else { return .authorization }
        return .content(name: user)
    }
}
