//
//  Logger.swift
//  NeuroKit
//
//  Created by Anshul Kumar on 24/03/26.
//

import Foundation

enum Logger {
    static func log(_ message: String) {
        #if DEBUG
        print("[NeuroKit]: \(message)")
        #endif
    }
}
