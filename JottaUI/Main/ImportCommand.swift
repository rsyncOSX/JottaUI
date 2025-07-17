//
//  ImportCommand.swift
//  JottaUI
//
//  Created by Thomas Evensen on 17/07/2025.
//

import SwiftUI

struct ImportCommand: Commands {
    @FocusedBinding(\.importtasks) private var importtasks

    var body: some Commands {
        CommandGroup(replacing: CommandGroupPlacement.importExport) {
            Menu("Import") {
                ImporttasksButton(importtasks: $importtasks)
            }
        }
    }
}

struct ImporttasksButton: View {
    @Binding var importtasks: Bool?

    var body: some View {
        Button {
            importtasks = true
        } label: {
            Label("Import", systemImage: "play.fill")
        }
    }
}

struct FocusedExporttasksBinding: FocusedValueKey {
    typealias Value = Binding<Bool>
}

struct FocusedImporttasksBinding: FocusedValueKey {
    typealias Value = Binding<Bool>
}

extension FocusedValues {
    
    var importtasks: FocusedImporttasksBinding.Value? {
        get { self[FocusedImporttasksBinding.self] }
        set { self[FocusedImporttasksBinding.self] = newValue }
    }
}
