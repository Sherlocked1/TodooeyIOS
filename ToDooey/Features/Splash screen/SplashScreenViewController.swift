//Copyright © 2023 Mohammed

import UIKit
import FirebaseAuth
import Lottie

class SplashScreenViewController:UIViewController {
    
    @IBOutlet weak var animationView : AnimationView!
    
    var handler:AuthStateDidChangeListenerHandle?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //adjusting animation speed
        animationView.animationSpeed = 1.5
        
        //playing the animation
        animationView.play { [weak self] completed in
            if completed {
                //checks userstatus on animation finish
                self?.checkUserStatus()
            }
        }
        
    }
    
    ///checks firebase authentication user status
    ///and routes to the login screen if the user does not exist
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
    
    // removes the auth listener after leaving the splash screen
    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handler!)
    }
    
    
}
