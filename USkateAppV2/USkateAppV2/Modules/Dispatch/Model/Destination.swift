//
//  Destination.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 24.11.2025.
//

enum Destination {
    case loading
    case content(name: String)
    case deepLink
    case authorization
    case error(text: String)
}
