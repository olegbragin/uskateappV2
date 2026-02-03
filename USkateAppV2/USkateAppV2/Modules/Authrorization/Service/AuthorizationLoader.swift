//
//  AuthorizationLoad.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 07.12.2025.
//

struct AuthorizationLoader {
    let service = KeychainService()
    func authorize(with data: AuthorizationInputData) {
        service?.set(value: "Oleg", for: Constants.kSecureToken)
    }
}
