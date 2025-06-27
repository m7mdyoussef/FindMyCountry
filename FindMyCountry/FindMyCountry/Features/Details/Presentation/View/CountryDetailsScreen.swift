//
//  CountryDetailsScreen.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct CountryDetailsScreen: View {
    
    @EnvironmentObject var router:Router<AppDestinationUIPilot>
    var country: Country?
    
    @State var didTapback: Bool = false
    
    var body: some View {
        ZStack {
            Color(AppResources.Colors.offWhite)
                .ignoresSafeArea()
            VStack {
                FindMyCountryNavigationView(didtapBack: $didTapback).padding(.bottom, 30)
                
                if let country = country {
                    CountryFlagView(url: country.flags?.png)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                    Spacer().frame(height: 50)
                    CountryDataView(country: country)
                    Spacer()
                }
            }
            .padding(16)
        }
        .onChange(of: didTapback) { _, newValue in
            guard newValue else {return}
            router.pop()
        }
    }
}
