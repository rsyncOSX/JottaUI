
import OSLog
import SwiftUI

enum JottaSync: String, CaseIterable, Identifiable, CustomStringConvertible {
    case configure
    case diag
    case log
    case move
    case reset
    case selective
    case start
    case stop
    case trigger

    var id: String { rawValue }
    var description: String { rawValue.localizedLowercase.replacingOccurrences(of: "_", with: " ") }
}

struct SyncView: View {

    @State private var synctask = JottaSync.diag
    @State private var errordiscovered: Bool = false

    var body: some View {
        HStack {

            Picker(NSLocalizedString("Sync", comment: ""),
                   selection: $synctask)
            {
                ForEach(JottaSync.allCases) { Text($0.description)
                    .tag($0)
                }
            }
            .pickerStyle(DefaultPickerStyle())
            .frame(width: 150)

            Button {
                let argumentssync = ["sync",synctask.description]
                let command = FullpathJottaCli().jottaclipathandcommand()
                let process = ProcessCommand(command: command,
                                             arguments: argumentssync,
                                             processtermination: processtermination)
                // Start progressview
                process.executeProcess()

            } label: {
                Image(systemName: "plus.circle.fill")
                    .imageScale(.large)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    func processtermination(_ output: [String]?, _ errordiscovered: Bool) {
        print(output)
    }
}
