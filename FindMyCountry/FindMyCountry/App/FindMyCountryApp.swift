//
//  FindMyCountryApp.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

@main
struct FindMyCountryApp: App {
    @StateObject private var loading = Loading()
    @StateObject var popupPresent = PopupPresent()
    @StateObject var rootRouter = Router<AppDestinationUIPilot>()
    
    var body: some Scene {
        WindowGroup {
            AppLoader{
                NavigationStack(path: $rootRouter.pagesStack) {
                    AppDestinationUIPilot.home.view
                        .ignoresSafeArea()
                }
                .environmentObject(rootRouter)
            }
            .environmentObject(popupPresent)
            .environmentObject(loading)
            .popup(isPresented: popupPresent.isPopupPresented) {
                popupPresent.popupView
            }
        }
    }
}
