//
//  SheetPresenter.swift
//  SwiftUIIntegratedSheet
//
//  Created by Morris Richman on 11/7/24.
//

import SwiftUI
import UIKit

public struct SheetPresenter<SheetContent: View>: ViewModifier {
    // MARK: Initialized Variables
    @Binding var isPresented: Bool
    @ViewBuilder let sheetContent: SheetContent
    private let cornerRadius: CGFloat //= 25
    private let backgroundColor: Color //= Color(uiColor: .secondarySystemBackground)
    
    public init(isPresented: Binding<Bool>, cornerRadius: CGFloat = 0, backgroundColor: Color = Color(uiColor: .secondarySystemBackground), @ViewBuilder content: @escaping () -> SheetContent) {
        self._isPresented = isPresented
        self.sheetContent = content()
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
    }
    
    // MARK: Variables
    @State var sheetOffsetY: CGFloat = 0
    
    // MARK: View Modifications
    public func body(content: Content) -> some View {
        VStack {
            content
                .padding(.bottom, -sheetOffsetY)
            
            sheetContent
                .transition(.asymmetric(insertion: .push(from: .bottom), removal: .push(from: .top)))
                .padding(.vertical)
                .padding(.bottom)
                .scrollContentBackground(.hidden)
                .background(backgroundColor)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: cornerRadius, topTrailingRadius: cornerRadius))
                .dragToDismiss(isPresented: $isPresented, offsetY: $sheetOffsetY)
        }
    }
    
    // MARK: Modifiers
//    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
//        let view = self
//        view.cornerRadius = cornerRadius
//        
//        return view
//    }
//    
//    func backgroundColor(_ color: Color) -> Self {
//        let view = self
//        view.backgroundColor = color
//        
//        return view
//    }
}

public extension View {
    func integratedSheet<Content>(isPresented: Binding<Bool>, cornerRadius: CGFloat = 25, backgroundColor: Color = Color(uiColor: .secondarySystemBackground), @ViewBuilder content: @escaping () -> Content) -> some View where Content: View {
        modifier(SheetPresenter(isPresented: isPresented, cornerRadius: cornerRadius, backgroundColor: backgroundColor, content: content))
    }
}
