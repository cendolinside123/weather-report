//
//  AppDelegate.swift
//  Weather Report
//
//  Created by Jan Sebastian on 29/03/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    private lazy var coreData = CoreDataStack(modelName: "Weather_Report")
    private var viewModel: AuthVMGuideline?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        viewModel = AuthViewModel(useCase: UserDataSource(cdStack: coreData))
        
        viewModel?.authResponse = { [weak self] _ in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                let loginVC = LoginViewController(page: .login, coredata: strongSelf.coreData)
                UserDefaults.standard.set(true, forKey: Constants.userDefaults.firstStart)
                let nav = UINavigationController(rootViewController: loginVC)
                strongSelf.window?.rootViewController = nav
                strongSelf.window?.makeKeyAndVisible()
            }
        }
        viewModel?.errorReponse = { error in
            print("AuthViewModel: \(error)")
        }
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        setupGuest()
        
        
        return true
    }
    
}

extension AppDelegate {
    func setupGuest() {
        let isFreshInstall = UserDefaults.standard.bool(forKey: Constants.userDefaults.firstStart)
        if !isFreshInstall {
            let setupVC = SetupViewController()
            window?.rootViewController = setupVC
            window?.makeKeyAndVisible()
            viewModel?.createUser(user: UserInfo(name: "guest", pass: "guest", isGuest: true))
        } else {
            if UserSession.getUser() != nil {
                let homeVC = HomeViewController(coredata: coreData)
                
                let nav = UINavigationController(rootViewController: homeVC)
                window?.rootViewController = nav
                window?.makeKeyAndVisible()
            } else {
                let loginVC = LoginViewController(page: .login, coredata: coreData)
                let nav = UINavigationController(rootViewController: loginVC)
                window?.rootViewController = nav
                window?.makeKeyAndVisible()
            }
            
        }
        
    }
}
