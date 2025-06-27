//
//  Destination.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Foundation
import SwiftUI

protocol DestinationType: Hashable {
    associatedtype T: View
    @ViewBuilder var view: T { get }
    var name: String { get }
}

enum AppDestinationUIPilot: DestinationType {
    case home
    
    
    var name: String {
        return String(reflecting: view.self)
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
            case .home:
                HomeScreen().navigate(destination: AppDestinationUIPilot.self)
        }
    }
}
