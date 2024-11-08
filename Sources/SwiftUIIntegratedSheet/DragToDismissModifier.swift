//
//  DragToDismissModifier.swift
//  MeshPaper
//
//  Created by Morris Richman on 6/17/24.
//

import Foundation
import SwiftUI

/// A view modifier that adds drag-to-dismiss functionality to a sheet or modal view.
///
/// `DragToDismissModifier` allows users to dismiss a presented view by dragging
/// it downward. This modifier provides an intuitive and interactive way to
/// close sheets, making the user experience feel more natural and responsive.
///
///  - Important: This modifier has been added to the View protocol as ``dragToDismiss(isPresented:offsetY:)``
struct DragToDismissModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var offsetY: CGFloat
    
    func body(content: Content) -> some View {
            content
                .offset(y: offsetY)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            guard isPresented else { return }
                            
                            guard self.offsetY < 160 else {
                                stopPresenting()
                                return
                            }
                            
                            self.offsetY = max(0, value.translation.height)
                        }
                        .onEnded { value in
                            guard self.offsetY < 120 else {
                                stopPresenting()
                                return
                            }
                            
                            // Snap back to original position
                            withAnimation {
                                self.offsetY = 0
                            }
                        }
                )
    }
    
    func stopPresenting() {
        withAnimation {
            self.isPresented = false
            self.offsetY = 0
        }
    }
}

extension View {
    /// A view modifier that adds drag-to-dismiss functionality to a sheet or modal view.
    ///
    /// `.dragToDismiss` allows users to dismiss a presented view by dragging
    /// it downward. This modifier provides an intuitive and interactive way to
    /// close sheets, making the user experience feel more natural and responsive.
    ///
    /// - Parameters:
    ///     - isPresented: A binding boolean that determines whether the sheet is visible.
    ///     - offsetY: A binding representation of the y offset
    func dragToDismiss(isPresented: Binding<Bool>, offsetY: Binding<CGFloat>) -> some View {
        self.modifier(DragToDismissModifier(isPresented: isPresented, offsetY: offsetY))
    }
}

