//
//  DispatchViewModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 17.11.2025.
//
import Combine

final class DispatchViewModel: ObservableObject {
    
    @Published var desitnation: Destination = .loading
    
    private var userData: UserData = UserData(name: "")
    private let loader: DispatchLoader
    private let connectivityProvider: WatchConnectivityProvider
    
    init(
        loader: DispatchLoader = DispatchLoader(),
        watchConnectivityProvider: WatchConnectivityProvider = WatchConnectivityProvider()
    ) {
        self.loader = loader
        self.connectivityProvider = watchConnectivityProvider
    }
    
    func fetchUserData() async {
        connectivityProvider.connect()
        try? await Task.sleep(for: .seconds(8))
        userData = UserData(name: "Oleg")
        desitnation = await loader.fetchUserData()
    }
}
