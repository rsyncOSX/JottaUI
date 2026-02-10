//
//  CreateCommandHandlers.swift
//  JottaUI
//
//  Created by Thomas Evensen on 17/11/2025.
//

import Foundation
import ProcessCommand

@MainActor
struct CreateCommandHandlers {
    func createcommandhandlers(
        processtermination: @escaping ([String]?, Bool) -> Void

    ) -> ProcessHandlersCommand {
        ProcessHandlersCommand(
            processtermination: processtermination,
            checklineforerror: CheckForError().checkforerror(_:),
            updateprocess: SharedReference.shared.updateprocess,
            propogateerror: { error in
                SharedReference.shared.errorobject?.alert(error: error)
            },
            logger: { command, output in
                _ = await ActorJottaUILogToFile().logOutput(command, output)
            },
            rsyncui: false
        )
    }
}
