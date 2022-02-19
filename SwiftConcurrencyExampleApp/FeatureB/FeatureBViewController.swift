//
//  FeatureBViewController.swift
//  SwiftConcurrencyExampleApp
//
//  Created by funzin on 2022/02/19.
//

import Foundation
import SwiftUI

struct FeatureBView: View {
    var body: some View {
        Text("FeatureB")
    }
}

final class FeatureBViewModel: ViewModel {
    func sleep() async -> Bool  {
        do {
            // wait 5 seconds
            try await Task.sleep(nanoseconds: 5000000000)
            return true
        } catch {
            return false
        }
    }
}

/// Use UIHostingController instead of HostingViewController
/// not cancel all tasks after screen is dismissed
final class FeatureBViewController: UIHostingController<FeatureBView> {
    private lazy var viewModel = FeatureBViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.addTask { [weak self] in
            let success = await self?.viewModel.sleep() ?? false
            
            // after waiting sleeping hours, print log
            print("success is \(success)")
        }
    }
}
