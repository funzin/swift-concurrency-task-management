//
//  HostingViewController.swift
//  SwiftConcurrencyExampleApp
//
//  Created by funzin on 2022/02/19.
//

import SwiftUI

@MainActor
class HostingViewController<Content: View, ViewModel: TaskCancellable>: UIHostingController<Content> {
    let viewModel: ViewModel
    
    init(rootView: Content, viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(rootView: rootView)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let willDisappear = isBeingDismissed
        || isMovingFromParent
        || navigationController?.isBeingDismissed ?? false
        if willDisappear {
            viewModel.cancelAll()
        }
    }
}
