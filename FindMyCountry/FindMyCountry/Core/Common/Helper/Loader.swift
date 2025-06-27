//
//  Loader.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import SwiftUI

struct Loader: View {
    var size: CGFloat = 70
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                NativeActivityIndicator(
                    isAnimating: true,
                    style: .large,
                    color: UIColor(AppResources.Colors.main)
                )
                .frame(width: size, height: size)
                Spacer()
            }
        }
    }
}


struct AppLoader<Content: View>: View {
    var size: CGFloat = 70
    var content: Content
    @EnvironmentObject var popupPresent: PopupPresent
    @EnvironmentObject var loading: Loading
    
    
    init(size: CGFloat = 70, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.size = size
    }
    
    var body: some View {
        ZStack {
            content
                .environmentObject(loading)
                .disabled(loading.isLoading ?? false)
            
            if loading.isLoading ?? false {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(true)
                
                Loader(size: size)
                    .frame(width: 100, height: 100)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
                    .shadow(radius: 10)
            }
        }
    }
}

class Loading: ObservableObject {
    @Published var isLoading: Bool? {
        didSet {
            print("isLoading updated to: \(String(describing: isLoading))")
        }
    }
}


struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
    }
}

struct NativeActivityIndicator: UIViewRepresentable {
    let isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    let color: UIColor?
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.hidesWhenStopped = true
        if let color = color {
            view.color = color
        }
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

