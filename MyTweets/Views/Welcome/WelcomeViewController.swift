//
//  WelcomeViewController.swift
//  MyTweets
//
//  Created by Nicolas Manograsso on 08/06/2021.
//

import UIKit

final class WelcomeViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.addShadow()
        }
    }
    
    // MARK: - Public properties
    weak var coordinator: MainCoordinator?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coordinator?.setWelcomeNavSyle()
    }
    
    // MARK: - Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        coordinator?.login()
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        coordinator?.register()
    }
}
