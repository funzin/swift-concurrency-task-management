//
//  FeatureAViewController.swift
//  SwiftConcurrencyExampleApp
//
//  Created by funzin on 2022/02/19.
//

import SwiftUI

struct FeatureAView: View {
    var body: some View {
        Text("FeatureA")
    }
}

final class FeatureAViewModel: ViewModel {
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

final class FeatureAViewController: HostingViewController<FeatureAView, FeatureAViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.addTask { [weak self] in
            let success = await self?.viewModel.sleep() ?? false
            
            // after waiting sleeping hours, print log
            print("success is \(success)")
        }
    }
}
