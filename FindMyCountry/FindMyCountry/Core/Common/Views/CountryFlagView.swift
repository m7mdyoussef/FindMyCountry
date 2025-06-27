//
//  CountryFlagView.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct CountryFlagView: View {
    let url: String?
    var body: some View {
        WebImage(url: URL(string: url ?? ""))
            .resizable()
            .placeholder {
                AppResources.Assets.flagPlaceholder
                    .resizable()
            }
            .scaledToFit()
            .cornerRadius(5)
    }
}
