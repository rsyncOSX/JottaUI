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
    @Binding var updateactionlogview: Bool

    @State private var logfilerecords: [LogfileRecords]?
    // Filterstring
    @State private var filterstring: String = ""
    // Sortdirection, true most recent at top false default
    @State private var sortdirection: Bool = true
    // Reset and read logfile again as default
    @State private var reset: Bool = false
    // Set progressview when resetting, filter or reset data

    var body: some View {
        VStack {
            ZStack {
                if let logfilerecords {
                    Table(logfilerecords) {
                        TableColumn("Time stamp") { data in
                            let stringdate = data.logrecordlogdate?.string_from_date() ?? "No date"
                            Text(stringdate)
                        }
                        .width(min: 100, max: 150)

                        TableColumn("Logfile Jotta-client" + ": \(logfilerecords.count) rows" + sortdirectionstring()) { data in
                            Text(data.logrecordline)
                        }
                    }
                } else {
                    ProgressView()
                }

                if updateactionlogview {
                    ProgressView()
                }
            }
        }
        .padding()
        .searchable(text: $filterstring)
        .onAppear {
            Task {
                updateactionlogview = true
                logfilerecords = await ActorJottaCliLogfile().jottaclilogfile()
                updateactionlogview = false
            }
        }
        .onChange(of: filterstring) {
            Task {
                updateactionlogview = true
                if filterstring.isEmpty == false {
                    // Must read all logrecords before filter
                    let alllogrecords = await ActorJottaCliLogfile().jottaclilogfile()
                    logfilerecords = alllogrecords.filter { $0.logrecordline.contains(filterstring) }
                } else {
                    logfilerecords = await ActorJottaCliLogfile().jottaclilogfile()
                }
                updateactionlogview = false
            }
        }
        .onChange(of: reset) {
            Task {
                guard reset == true else { return }
                updateactionlogview = true
                logfilerecords = await ActorJottaCliLogfile().jottaclilogfile()
                reset = false
                sortdirection = true
                updateactionlogview = false
            }
        }
        .onChange(of: sortdirection) {
            Task {
                guard reset == false else { return }
                updateactionlogview = true
                if filterstring.isEmpty == false {
                    // Must read all logrecords before filter
                    let alllogrecords = await ActorJottaCliLogfile().sortjottaclilogfile(sortdirection)
                    logfilerecords = alllogrecords.filter { $0.logrecordline.contains(filterstring) }
                } else {
                    logfilerecords = await ActorJottaCliLogfile().sortjottaclilogfile(sortdirection)
                }
                updateactionlogview = false
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
