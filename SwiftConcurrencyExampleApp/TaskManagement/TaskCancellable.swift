//
//  TaskCancellable.swift
//  SwiftConcurrencyExampleApp
//
//  Created by funzin on 2022/02/19.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
protocol TaskCancellable {
    func cancelAll()
}
