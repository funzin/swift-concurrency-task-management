//
//  ViewController.swift
//  SwiftConcurrencyExampleApp
//
//  Created by funzin on 2022/02/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let featureAButton = UIButton(primaryAction: .init(handler: { [weak self]_ in
            let vc = FeatureAViewController(rootView: FeatureAView(), viewModel: FeatureAViewModel())
            self?.present(vc, animated: true)
        }))
        featureAButton.setTitle("present FeatureA", for: .normal)
        
        let featureBButton = UIButton(primaryAction: .init(handler: { [weak self] _ in
            let vc = FeatureBViewController(rootView: FeatureBView())
            self?.present(vc, animated: true)
        }))
        
        featureBButton.setTitle("present FeatureB", for: .normal)
                                      
        stackView.addArrangedSubview(featureAButton)
        stackView.addArrangedSubview(featureBButton)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

