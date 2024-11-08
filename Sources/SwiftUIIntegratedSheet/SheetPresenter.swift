//
//  SheetPresenter.swift
//  SwiftUIIntegratedSheet
//
//  Created by Morris Richman on 11/7/24.
//

import SwiftUI
import UIKit

/// A modifier for presenting sheets in a customizable way in SwiftUI.
///
/// `SheetPresenter` is a `ViewModifier` that enables the presentation of
/// a sheet with a customizable corner radius and background color. It uses
/// bindings to manage the sheet's visibility and provides a seamless
/// integration into your SwiftUI views.
///
/// ## Overview
/// Use `SheetPresenter` to add sheets to your SwiftUI views with specific
/// appearance settings. It offers options for configuring the look and feel
/// of your sheets, such as the corner radius and background color.
///
/// - Parameters:
///     - isPresented: A binding boolean that determines whether the sheet is visible.
///     - cornerRadius: The an optional override of corner radius of the sheet.
///     - backgroundColor: The an optional overrid of background color of the sheet.
///     - content: A view builder that defines the content to be displayed in the sheet.
struct SheetPresenter<SheetContent: View>: ViewModifier {
    // MARK: Initialized Variables
    @Binding var isPresented: Bool
    @ViewBuilder let sheetContent: SheetContent
    private let cornerRadius: CGFloat //= 25
    private let backgroundColor: Color //= Color(uiColor: .secondarySystemBackground)
    
    init(isPresented: Binding<Bool>, cornerRadius: CGFloat = 25, backgroundColor: Color = Color(uiColor: .secondarySystemBackground), @ViewBuilder content: @escaping () -> SheetContent) {
        self._isPresented = isPresented
        self.sheetContent = content()
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
    }
    
    // MARK: Variables
    @State var sheetOffsetY: CGFloat = 0
    
    // MARK: View Modifications
    func body(content: Content) -> some View {
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
}

public extension View {
    /// A view modifier that integrates a customizable sheet presentation into your SwiftUI views.
    ///
    /// `integratedSheet` allows you to present a sheet with ease, using a binding to control
    /// the visibility and a view builder to define the content of the sheet. This modifier
    /// supports custom configurations, such as corner radius and background color, to give
    /// you full control over the appearance of the sheet.
    ///
    /// - Parameters:
    ///     - isPresented: A binding boolean that determines whether the sheet is visible.
    ///     - cornerRadius: The an optional override of corner radius of the sheet.
    ///     - backgroundColor: The an optional overrid of background color of the sheet.
    ///     - content: A view builder that defines the content to be displayed in the sheet.
    ///
    /// - Important: The recomended usage of `integratedSheet` is with ``SheetContainer``
    ///
    /// ## Example Usage
    /// Here's how to use the `integratedSheet` modifier in your SwiftUI view:
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var isSheetVisible = false
    ///
    ///     var body: some View {
    ///         Button("Show Integrated Sheet") {
    ///             isSheetVisible = true
    ///         }
    ///         .integratedSheet(isPresented: $isSheetVisible, cornerRadius: 20, backgroundColor: Color.white) {
    ///             VStack {
    ///                 Text("This is an integrated sheet")
    ///                     .font(.headline)
    ///                     .padding()
    ///                 Button("Dismiss") {
    ///                     isSheetVisible = false
    ///                 }
    ///                 .padding()
    ///             }
    ///         }
    ///     }
    /// }
    /// ```
    func integratedSheet<Content>(isPresented: Binding<Bool>, cornerRadius: CGFloat = 25, backgroundColor: Color = Color(uiColor: .secondarySystemBackground), @ViewBuilder content: @escaping () -> Content) -> some View where Content: View {
        modifier(SheetPresenter(isPresented: isPresented, cornerRadius: cornerRadius, backgroundColor: backgroundColor, content: content))
    }
}
