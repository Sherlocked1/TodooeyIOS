//Copyright © 2023 Mohammed

import UIKit
import FirebaseAuth
import Lottie

class SplashScreenViewController:UIViewController {
    
    @IBOutlet weak var animationView : AnimationView!
    
    var handler:AuthStateDidChangeListenerHandle?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationView.animationSpeed = 2
        animationView.play { [weak self] completed in
            if completed {
                self?.checkUserStatus()
            }
        }
        
    }
    
    func checkUserStatus () {
        
        handler = Auth.auth().addStateDidChangeListener { auth, user in
            if let _ = user {
                // User is signed in.
                let vc = HomeViewController.instantiate(storyboard: .init(name: "Main", bundle: .main))
                let scene = UIApplication.shared.connectedScenes.first
                let window = (scene?.delegate as? SceneDelegate)?.window
                window?.rootViewController = UINavigationController(rootViewController: vc)
                window?.makeKeyAndVisible()

            } else {
                // No user is signed in.
                let vc = LoginViewController.instantiate(storyboard: .init(name: "Main", bundle: .main))
                let scene = UIApplication.shared.connectedScenes.first
                let window = (scene?.delegate as? SceneDelegate)?.window
                window?.rootViewController = UINavigationController(rootViewController: vc)
                window?.makeKeyAndVisible()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handler!)
    }
    
    
}
