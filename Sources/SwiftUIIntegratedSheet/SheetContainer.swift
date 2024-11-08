//
//  SheetContainer.swift
//  MeshPaper
//
//  Created by Morris Richman on 6/17/24.
//

import SwiftUI

public struct SheetContainer<Header: View, Content: View>: View {
    let title: String
    @Binding var isShown: Bool
    private var header: (() -> Header)?
    private var content: () -> Content
    @State var scrollOffsetIsDisabled = false
    
    public init(title: String, isShown: Binding<Bool>, @ViewBuilder header: @escaping () -> Header, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self._isShown = isShown
        self.header = header
        self.content = content
    }
     
    public init(title: String, isShown: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) where Header == EmptyView {
        self.title = title
        self._isShown = isShown
        self.header = nil
        self.content = content
    }
    
    public var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
                    .bold()
                    .textCase(nil)
                    .foregroundStyle(Color.primary)
                Spacer()
                header?()
                Button {
                    withAnimation {
                        isShown = false
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                }
            }
            ScrollView {
                VStack {
                    ForEach(sections: content()) { section in
                        VStack {
                            ForEach(subviews: section.content) { subview in
                                subview
                            }
                        }
                        .padding()
                        .background(Color(uiColor: .tertiarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .background(GeometryReader {
                            Color.clear.preference(key: ViewOffsetKey.self,
                                                   value: -$0.frame(in: .named("scroll")).origin.y)
                        })
                    }
                    Color.clear.frame(height: 15)
                }
                .onChange(of: isShown) {
                    scrollOffsetIsDisabled = !isShown
                }
            }
            .coordinateSpace(name: "scroll")
            .ignoresSafeArea()
        }
        .padding(.horizontal)
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static let defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
