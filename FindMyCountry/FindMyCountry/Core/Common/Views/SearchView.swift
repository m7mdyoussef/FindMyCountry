//
//  SearchView.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct SearchView: View {
    @Binding var openSearch: Bool
    var body: some View {
        HStack {
            Text(AppConstants.localizedText.FindMyCountry)
                .textStyle(BoldTextStyle(fontSize: 20, color:.eyeTiger))
            
            Spacer()
            
            HStack {
                AppResources.Assets.whiteSearchIcon
                    .padding(.horizontal)
            }
            .frame(width: 90 , height: 40)
            .backgroundStyle(
                cornerRadius: 12,
                borderColor: .main,
                borderWidth: 1,
                backgroundColor: .eyeTiger
            )
            .onTapGesture {
                openSearch.toggle()
            }
        }
    }
}
