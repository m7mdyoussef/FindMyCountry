//
//  PopupPresent.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//


import SwiftUI

class PopupPresent: ObservableObject {
    
    @Published var isPopupPresented = false
    @Published var isSheetPresented = false
    @Published var councilsScrollToTop = false
    @Published var homeScrollToTop = false
    @Published var committeesScrollToTop = false
    
    @Published var popupView: GenericView = GenericView {
        AnyView(VStack{})
    }
}

extension PopupPresent {
    func openPopup() {
        isPopupPresented = true
        isSheetPresented = false
    }
    
    func openSheet() {
        isPopupPresented = false
        isSheetPresented = true
    }
    
    func closeAll() {
        isPopupPresented = false
        isSheetPresented = false
    }
}

struct GenericView<Content: View>: View {
    @ViewBuilder
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack(content: content)
    }
}
