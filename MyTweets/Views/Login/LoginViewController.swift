//
//  LoginViewController.swift
//  MyTweets
//
//  Created by Nicolas Manograsso on 14/06/2021.
//

import NotificationBannerSwift
import SVProgressHUD
import Simple_Networking
import UIKit

final class LoginViewController: UIViewController {
    // MARK: - Private properties
    private let loginView: LoginViewProtocol
    
    // MARK: - Public properties
    weak var coordinator: MainCoordinator?
    
    // MARK: - Initializer
    init(view: LoginViewProtocol = LoginView()) {
        loginView = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        setupActions()
    }
    
    override func loadView() {
        super.loadView()
        view = loginView
    }
    
    // MARK: - Private methods
    private func setupActions() {
        loginView.setLoginButtonAction(#selector(performLogin), viewController: self)
    }
    
    private func isFormValid() -> Bool {
        guard let email = loginView.getEmailValue(), let pass = loginView.getPasswordValue() else {
            FormNotification.generic.showError()
            return false
        }
        
        if email.isEmpty && pass.isEmpty {
            FormNotification.allFields.showError()
            return false
        }

        if email.isEmpty || pass.isEmpty {
            FormNotification.someField.showError()
            return false
        }
        
        return true
    }

    // MARK: - Actions
    @objc private func performLogin() {
        guard isFormValid(),
              let email = loginView.getEmailValue(),
              let password = loginView.getPasswordValue() else {
            return
        }
        
        // A valid user is email: test@test.com password: qwerty
        let request = LoginRequest(email: email, password: password)
        
        SVProgressHUD.show()

        SN.post(endpoint: Endpoint.login,
                model: request) { [weak self] (response: SNResultWithEntity<UserResponse, ErrorResponse>) in
            
            SVProgressHUD.dismiss()
            
            switch response {
            case .errorResult(let error):
                NotificationBanner(subtitle: error.error, style: .danger).show()
            case .error:
                FormNotification.generic.showError()
            case .success(let user):
                SimpleNetworking.setAuthenticationHeader(prefix: "", token: user.token)
                self?.coordinator?.home()
            }
        }
    }
}

enum FormNotification {
    case generic
    case someField
    case allFields
    
    func showError() {
        switch self {
        case .generic:
            NotificationBanner(title: "Error",
                               subtitle: "An error was occurred",
                               style: .danger).show()
        case .someField:
            NotificationBanner(title: "Error",
                               subtitle: "One or more fields are not valid",
                               style: .warning).show()
        case .allFields:
            NotificationBanner(title: "Error",
                               subtitle: "The fields must be valid",
                               style: .warning).show()
        }
    }
}
