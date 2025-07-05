//
//  ValueSchemeView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 05/07/2025.
//

import SwiftUI

struct ValueSchemeView: View {
    @Environment(\.colorScheme) var colorScheme
    var myvalue: String
    var mywidth: CGFloat?

    var body: some View {
        Text(myvalue)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: mywidth, alignment: .trailing)
            .lineLimit(1)
            .foregroundColor(colorScheme == .dark ? .white : .black)
    }

    init(_ width: CGFloat, _ text: String) {
        mywidth = width
        myvalue = text
    }
}
