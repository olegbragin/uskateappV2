//
//  DispatchViewModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 17.11.2025.
//
import Foundation
import Combine

final class DispatchViewModel: ObservableObject {
    
    @Published var desitnation: Destination = .loading
    
    private var userData: UserData = UserData(name: "")
    
    func fetchUserData() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.userData = UserData(name: "Oleg")
            self.desitnation = .content(name: self.userData.name)
        }
    }
}
