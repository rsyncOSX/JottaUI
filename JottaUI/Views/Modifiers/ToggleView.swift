//
//  ToggleView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 05/07/2025.
//
import SwiftUI

struct ToggleView: View {
    @Environment(\.colorScheme) var colorScheme
    private var mytext: String?
    private var mybinding: Binding<Bool>

    var body: some View {
        HStack {
            Toggle(mytext ?? "", isOn: mybinding)
                .labelsHidden()
                .toggleStyle(CheckboxToggleStyle())

            Text(mytext ?? "")
                .foregroundColor(mybinding.wrappedValue ? .blue : (colorScheme == .dark ? .white : .black))
                .toggleStyle(CheckboxToggleStyle())
        }
    }

    init(text: String, binding: Binding<Bool>) {
        mytext = text
        mybinding = binding
    }
}
