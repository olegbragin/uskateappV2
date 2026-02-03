//
//  AuthorizationViewModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 07.12.2025.
//
import Combine

final class AuthorizationViewModel: ObservableObject {
    enum Route: Hashable {
        case none
        case content(data: String)
    }
    
    @Published var path: [Route] = []
    @Published var isLoading = false
    
    let loader: AuthorizationLoader
    let connectivityProvider: WatchConnectivityProvider
    
    init(
        loader: AuthorizationLoader,
        connectivityProvider: WatchConnectivityProvider
    ) {
        self.loader = loader
        self.connectivityProvider = connectivityProvider
    }
    
    func authorize() async {
        isLoading = true
        try? await Task.sleep(for: .seconds(7))
        loader.authorize(with: .init(username: "Oleg", passqword: "12345"))
        connectivityProvider.send(message: ["auth": "Oleg"])
        path.append(.content(data: "Oleg"))
        isLoading = false
    }
    
    func notify() {
        connectivityProvider.send(message: ["auth": "Oleg"])
    }
}
