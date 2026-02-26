//
//  ContentModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 24.11.2025.
//

struct ContentModel {
    private let userName: String
    
    init(data: String) {
        self.userName = data
    }
    
    var greeting: String {
        "Greetings, %@!".localized(userName)
    }
}
