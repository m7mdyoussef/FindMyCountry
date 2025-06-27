//
//  HeaderTitleView.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct HeaderTitleView: View {
    let title: String
    var titleColor: Color = AppResources.Colors.dark_Gray
    var body: some View {
        HStack {
            Text(title)
                .textStyle(MeduimTextStyle(fontSize: 16, color: titleColor))
            Spacer()
        }
        .padding(4)
    }
}
