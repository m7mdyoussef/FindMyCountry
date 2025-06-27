//
//  Router.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

final class Router<T: Hashable>: ObservableObject {
    
    @Published public var path = NavigationPath()
    @Published public var pagesStack: Array<T> = []
    
    func  push(_ page: T) {
        path.append(page)
        pagesStack.append(page)
    }
    
    func pop() {
        if path.isEmpty { return }
        path.removeLast()
        pagesStack.removeLast()
    }
    
    func popTo(_ page: T) {
        var count = 0
        while let last = pagesStack.last, last != page {
            pagesStack.removeLast()
            count += 1
        }
        path.removeLast(count)
    }
}

extension View {
    func navigate<T: DestinationType>(destination: T.Type) -> some View {
        self.modifier(NavigationDestinationModifier<T>())
    }
}


struct NavigationDestinationModifier<T: DestinationType>: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content.navigationDestination(for: T.self) { value in
            value.view.navigationBarHidden(true)
        }
    }
}
