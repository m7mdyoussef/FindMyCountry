//
//  AddCountryButton.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct AddCountryButton: View {
    @Binding var openCountryPicker: Bool
    var body: some View {
        Button {
            openCountryPicker.toggle()
        } label: {
            HStack {
                Text(AppConstants.localizedText.addCountryButtonTitle)
                    .textStyle(BoldTextStyle(fontSize: 20, color: AppResources.Colors.white))
            }
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(RoundedRectangle(cornerRadius: 8)
                .fill(.eyeTiger))
        }
    }
}
