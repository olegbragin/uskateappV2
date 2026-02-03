//
//  DispatchViewModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 07.12.2025.
//
import Foundation
import Combine

struct AuthNotificationItem: Identifiable {
    let id = UUID()
    let text: String
}

final class DispatchViewModel: ObservableObject {
    @Published var auth: AuthNotificationItem? = nil
    
    private let connectivityProvider: WatchConnectivityProvider
    private var subscriptions: Set<AnyCancellable> = []
    
    init(
        watchConnectivityProvider: WatchConnectivityProvider = WatchConnectivityProvider()
    ) {
        self.connectivityProvider = watchConnectivityProvider
        bind()
    }
    
    func bind() {
        connectivityProvider.connect()
        connectivityProvider
            .$notification
            .sink { [weak self] notification in
                guard let notificationText = notification?.text else { return }
                self?.auth = AuthNotificationItem(text: notificationText)
            }
            .store(in: &subscriptions)
    }
}
