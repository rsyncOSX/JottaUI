//
//  EditValueScheme.swift
//  JottaUI
//
//  Created by Thomas Evensen on 08/07/2025.
//

import SwiftUI

struct EditValueScheme: View {
    @Environment(\.colorScheme) var colorScheme

    var myvalue: Binding<String>
    var mywidth: CGFloat?
    var myprompt: Text?

    var body: some View {
        TextField("", text: myvalue, prompt: myprompt)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .frame(width: mywidth, alignment: .trailing)
            .lineLimit(1)
    }

    init(_ width: CGFloat, _ str: String?, _ value: Binding<String>) {
        mywidth = width
        myvalue = value
        myprompt = Text(str ?? "")
    }
}
