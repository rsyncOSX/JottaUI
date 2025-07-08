//
//  JottaUIView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 17/06/2021.
//

import OSLog
import SwiftUI

struct JottaUIView: View {
    @State private var start: Bool = true
    @State private var jottacliversion = JottaCliVersion()

    var body: some View {
        VStack {
            if start {
                VStack {
                    Text("JottaUI a GUI for Jotta-client")
                        .font(.largeTitle)
                }
                .onAppear(perform: {
                    Task {
                        try await Task.sleep(seconds: 1)
                        start = false
                    }

                })
            } else {
                SidebarMainView(errorhandling: errorhandling)
            }
        }
        .padding()
        .task {
            jottacliversion.getjottacliversion()
        }
    }

    var errorhandling: AlertError {
        SharedReference.shared.errorobject = AlertError()
        return SharedReference.shared.errorobject ?? AlertError()
    }
}
