//
//  TaskID.swift
//  SwiftConcurrencyExampleApp
//
//  Created by funzin on 2022/02/19.
//

import Foundation

typealias TaskID = AnyHashable
protocol TaskIDProtocol: Hashable & Sendable {}
struct DefaultTaskID: TaskIDProtocol {
    init() {}
}
