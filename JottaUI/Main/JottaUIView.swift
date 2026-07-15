//
//  JottaUIView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 17/06/2021.
//

import OSLog
import SwiftUI

struct JottaUIView: View {
    @State private var jottacliversion = JottaCliVersion()
    @State private var errorhandling = AlertError()

    var body: some View {
        SidebarMainView(errorhandling: errorhandling)
            .onAppear {
                SharedReference.shared.errorobject = errorhandling
            }
            .task {
                jottacliversion.getjottacliversion()
            }
    }
}
