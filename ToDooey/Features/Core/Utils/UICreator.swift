//Copyright © 2023 Mohammed

import UIKit
import Lottie

class UI {
    
    private static let ScreenSize = UIScreen.main.bounds

    private static func showBlur() {
        UI.blurView.isHidden = false
    }
    private static func hideBlur() {
        UI.blurView.isHidden = true
    }
    
    //MARK: - Loading View
    
    ///Loading animation
    private static var animationView:AnimationView = {
        let view = AnimationView(name: "loading")
        let width = ScreenSize.width/2
        let height = width
        
        view.frame.origin = CGPoint(x: (ScreenSize.width/2) - width/2, y: (ScreenSize.height/2) - height/2)
        
        view.frame.size = CGSize(width: width, height: height)
        
        view.loopMode = .loop
        
        return view
    }()
    
    ///background blur view
    private static var blurView:BlurredView = {
        
        let blurView = BlurredView()
        
        blurView.frame.origin = CGPoint(x: 0, y: 0)
        blurView.frame.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        
        return blurView
        
    }()
    
    ///back view that holds the blur view and the animation view
    private static var ClearView: UIView = {
        let ClearView = UIView()
        
        ClearView.frame.origin = CGPoint(x: 0, y: 0)
        ClearView.frame.size = CGSize(width: ScreenSize.width, height: ScreenSize.height)
        ClearView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        ClearView.insertSubview(blurView, at: 0)
        
        return ClearView
    }()
    
    ///Shows loading animation
    class func ShowLoadingView() {
        UI.showBlur()
        ClearView.addSubview(animationView)
        animationView.play()
        UIApplication.shared.keyWindow?.addSubview(ClearView)
    }
    
    ///Stops the loading animation
    class func HideLoadingView() {
        UI.hideBlur()
        animationView.stop()
        animationView.removeFromSuperview()
        ClearView.removeFromSuperview()
    }
    
    
}
