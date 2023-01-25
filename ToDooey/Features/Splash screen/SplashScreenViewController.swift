//Copyright © 2023 Mohammed

import UIKit
import FirebaseAuth

class SplashScreenViewController:UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // User is signed in.
                let vc = HomeViewController.instantiate(storyboard: .init(name: "Main", bundle: .main))
                let scene = UIApplication.shared.connectedScenes.first
                let window = (scene?.delegate as? SceneDelegate)?.window
                window?.rootViewController = UINavigationController(rootViewController: vc)
                window?.makeKeyAndVisible()
                
            } else {
                // No user is signed in.
                let vc = LoginViewControlelr.instantiate(storyboard: .init(name: "Main", bundle: .main))
                let scene = UIApplication.shared.connectedScenes.first
                let window = (scene?.delegate as? SceneDelegate)?.window
                window?.rootViewController = UINavigationController(rootViewController: vc)
                window?.makeKeyAndVisible()
            }
        }
    }
    
    
}
