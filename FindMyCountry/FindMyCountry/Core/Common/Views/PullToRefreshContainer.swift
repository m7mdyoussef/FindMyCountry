//
//  PullToRefreshContainer.swift
//  FindMyCountry
//
//  Created by Mohamed Youssef Al-Azizy on 27/06/2025.
//

import Foundation
import SwiftUI

struct PullToRefreshContainer<Content: View>: View {
    let content: () -> Content
    let onRefresh: () -> Void
    
    @State private var dragOffset: CGFloat = 0
    @State private var showRefreshBanner = false
    @GestureState private var isDragging = false
    
    private let threshold: CGFloat = 80
    
    var body: some View {
        ZStack(alignment: .top) {
            content()
                .gesture(
                    DragGesture(minimumDistance: 10, coordinateSpace: .global)
                        .updating($isDragging) { value, state, _ in
                            state = true
                            if value.translation.height > 0 {
                                dragOffset = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > threshold {
                                triggerRefresh()
                            } else {
                                reset()
                            }
                        }
                )
                .animation(.interactiveSpring(), value: dragOffset)
            
            if showRefreshBanner {
                refreshBanner
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut, value: showRefreshBanner)
            }
        }
    }
    
    private var refreshBanner: some View {
        Text(AppConstants.localizedText.refreshing)
            .font(.callout)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(AppResources.Colors.main)
            .cornerRadius(12)
            .padding(.horizontal, 40)
            .padding(.top, 60)
            .shadow(radius: 3)
    }
    
    private func triggerRefresh() {
        guard !showRefreshBanner else { return }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        showRefreshBanner = true
        dragOffset = 0
        
        onRefresh()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                showRefreshBanner = false
            }
        }
    }
    
    private func reset() {
        withAnimation {
            dragOffset = 0
        }
    }
}
