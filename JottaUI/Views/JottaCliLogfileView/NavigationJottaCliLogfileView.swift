//
//  NavigationJottaCliLogfileView.swift
//  JottaUI
//
//  Created by Thomas Evensen on 25/11/2023.
//

import Foundation
import Observation
import SwiftUI

struct NavigationJottaCliLogfileView: View {
    @State private var logfilerecords: [LogfileRecords]?
    // Filterstring
    @State private var filterstring: String = ""
    // Sortdirection, true most recent at top false default
    @State private var sortdirection: Bool = false
    // Reset and read logfile again as default
    @State private var reset: Bool = false
    // Set progressview when resetting, filter or reset data
    @State private var updateaction: Bool = false

    var body: some View {
        VStack {
            ZStack {
                if let logfilerecords {
                    Table(logfilerecords) {
                        TableColumn("Time stamp") { data in
                            let stringdate = data.logdate?.string_from_date() ?? "No date"
                            Text(stringdate)
                        }
                        .width(min: 100, max: 150)

                        TableColumn("Logfile form Jotta-client" + ": \(logfilerecords.count) rows" + sortdirectionstring()) { data in
                            Text(data.line)
                        }
                    }
                } else {
                    ProgressView()
                }

                if updateaction {
                    ProgressView()
                }
            }
        }
        .padding()
        .searchable(text: $filterstring)
        .onAppear {
            Task {
                updateaction = true
                logfilerecords = await ActorGenerateJottaCliLogfileforview().generatedata()
                updateaction = false
            }
        }
        .onChange(of: filterstring) {
            Task {
                updateaction = true
                if filterstring.isEmpty == false {
                    logfilerecords = logfilerecords?.filter { $0.line.contains(filterstring) }
                } else {
                    logfilerecords = await ActorGenerateJottaCliLogfileforview().generatedata()
                }
                updateaction = false
            }
        }
        .onChange(of: reset) {
            Task {
                guard reset == true else { return }
                updateaction = true
                logfilerecords = await ActorGenerateJottaCliLogfileforview().generatedata()
                reset = false
                sortdirection = false
                updateaction = false
            }
        }
        .onChange(of: sortdirection) {
            Task {
                guard reset == false else { return }
                updateaction = true
                logfilerecords = await ActorGenerateJottaCliLogfileforview().sortlogdata(sortdirection)
                updateaction = false
            }
        }
        .toolbar {
            ToolbarItem {
                if sortdirection == false {
                    Button {
                        guard sortdirection != true else { return }
                        sortdirection = true
                    } label: {
                        Image(systemName: "arrow.down.circle.fill")
                    }
                    .help("Most recent at bottom")
                } else {
                    Button {
                        guard sortdirection != false else { return }
                        sortdirection = false
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                    }
                    .help("Most recent at top")
                }
            }

            ToolbarItem {
                Button {
                    reset = true
                } label: {
                    Image(systemName: "clear")
                }
                .help("Reset and read again")
            }
        }
    }
    
    func sortdirectionstring() -> String {
        if sortdirection {
            return " - most recent at TOP"
        }
        return "- most recent at BOTTOM"
    }
}
