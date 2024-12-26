//
//  MainViewController_SearchHandling.swift
//  Notelist
//
//  Created by cao duc tin  on 26/12/24.
//

import UIKit


extension MainViewController {
    func setupSearchTextField() {
        searchTextField = UITextField()
        searchTextField.placeholder = "Search..."
        searchTextField.borderStyle = .roundedRect
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.isHidden = true
        
        view.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func setupBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.0
        view.insertSubview(blurEffectView, belowSubview: searchTextField)
    }
    
    func addTapGestureToDismissSearch() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideSearch(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTapOutsideSearch(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !searchTextField.frame.contains(location) {
            searchTextField.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.blurEffectView.alpha = 0.0
            }
        }
    }
}

