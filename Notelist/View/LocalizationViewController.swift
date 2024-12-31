//
//  LocalizationViewController.swift
//  Notelist
//
//  Created by cao duc tin  on 31/12/24.
//

import UIKit


class LocalizationViewController: UIViewController {
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        applyLocalization()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(greetingLabel)
        view.addSubview(welcomeLabel)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            welcomeLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 20),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func applyLocalization() {
        // Set localized text
        greetingLabel.text = NSLocalizedString("greeting", comment: "Greeting text")
        welcomeLabel.text = NSLocalizedString("welcome_message", comment: "Welcome message")
    }
}
