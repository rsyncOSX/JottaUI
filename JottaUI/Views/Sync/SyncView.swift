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
    @State private var jottaclioutput = ObservableJottaOutput()
    @State private var showprogressview = false
    @State private var showoutputview: Bool = false
    
    var body: some View {
        NavigationStack {
            HStack {
                if showprogressview {
                    ProgressView()
                } else {
                    
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
                        let argumentssync = ["sync", synctask.description]
                        let command = FullpathJottaCli().jottaclipathandcommand()
                        let process = ProcessCommand(command: command,
                                                     arguments: argumentssync,
                                                     syncmode: nil,
                                                     input: nil,
                                                     processtermination: processtermination)
                        // Start progressview
                        showprogressview = true
                        process.executeProcess()
                        
                    } label: {
                        Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.circle.fill")
                            .imageScale(.large)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Sync parameters")
            .navigationDestination(isPresented: $showoutputview) {
                JottaStatusOutputView(output: jottaclioutput.output ?? [])
            }
        }
    }
        

    var confirmation: String {
        synctask.description + " is applied"
    }
    
    func processtermination(_ stringoutput: [String]?, _: Bool) {
        showprogressview = false
        Task {
            jottaclioutput.output = await ActorCreateOutputforview().createaoutput(stringoutput)
            showoutputview = true
        }
    }
}
