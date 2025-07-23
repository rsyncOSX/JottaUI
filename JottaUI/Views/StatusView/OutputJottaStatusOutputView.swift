//
//  OutputJottaStatusOutputView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 20/11/2023.
//

import SwiftUI

struct OutputJottaStatusOutputView: View {
    var output: [JottaCliOutputData]

    var body: some View {
        Table(output) {
            TableColumn("Output from Jotta-cli" + ": \(output.count) rows") { data in
                Text(data.record)
            }
        }
        .padding()
    }
}
