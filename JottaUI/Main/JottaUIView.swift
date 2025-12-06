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

    var body: some View {
        SidebarMainView(errorhandling: errorhandling)
            .task {
                jottacliversion.getjottacliversion()
            }
    }

    var errorhandling: AlertError {
        SharedReference.shared.errorobject = AlertError()
        return SharedReference.shared.errorobject ?? AlertError()
    }
}
