//
//  ViewController.swift
//  AnimatedGlassTabs-UIKit
//
//  Created by Thomas on 2025/11/23.
//

import UIKit

class ViewController: UIViewController {
    let customTabBar = CustomTabBarView()
    
    private let homeVC = HomeViewController()
    private let notificationsVC = NotificationsViewController()
    private let settingsVC = SettingsVieController()
    
    private var currentVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(customTabBar)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customTabBar.heightAnchor.constraint(equalToConstant: 50) 
        ])
        
        customTabBar.onTabSelected = { [weak self] tab in
            self?.updateView(for: tab)
        }
        
        updateView(for: customTabBar.activeTab)
    }
    
    func updateView(for tab: CustomTab) {
        if let currentVC = currentVC {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        let newVC: UIViewController
        switch tab {
        case .home:
            newVC = homeVC
        case .notifications:
            newVC = notificationsVC
        case .settings:
            newVC = settingsVC
        }
        
        addChild(newVC)
        view.insertSubview(newVC.view, at: 0)
        newVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            newVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        newVC.didMove(toParent: self)
        currentVC = newVC
    }
}


