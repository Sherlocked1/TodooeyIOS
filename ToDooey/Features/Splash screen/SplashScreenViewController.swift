//Copyright © 2023 Mohammed

import UIKit


class SplashScreenViewController:UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vc = LoginViewControlelr.instantiate(storyboard: .init(name: "Main", bundle: .main))
        let scene = UIApplication.shared.connectedScenes.first
        let window = (scene?.delegate as? SceneDelegate)?.window
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
    }
}
