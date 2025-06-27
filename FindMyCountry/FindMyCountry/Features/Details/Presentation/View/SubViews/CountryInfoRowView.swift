//
//  CountryInfoRowView.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct CountryRowInfoView<Content: View>: View {
    let title: String
    let content: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HeaderTitleView(title: title, titleColor: AppResources.Colors.main)
            HStack {
                content()
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
        }
    }
}
