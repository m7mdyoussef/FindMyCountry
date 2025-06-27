//
//  SearchTextFieldView.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct SearchTextFieldView: View {
    @Binding var text: String
    var placeholder: String = AppConstants.localizedText.searchCountries
    var searchicon: Image = AppResources.Assets.graySearchIcon
    var cancelIcon: Image = AppResources.Assets.cancelSearchIcon
    
    var body: some View {
        HStack(spacing: 8) {
            ZStack(alignment: .leading) {
                TextField(placeholder, text: $text)
                    .padding(.horizontal, 36)
                    .frame(height: 40)
                    .backgroundStyle()
                    .overlay(
                        HStack {
                            searchicon
                                .padding(.leading, 8)
                            Spacer()
                        }
                    )
            }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    cancelIcon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.main)
                }
                .padding(.trailing, 4)
            }
        }
    }
}
