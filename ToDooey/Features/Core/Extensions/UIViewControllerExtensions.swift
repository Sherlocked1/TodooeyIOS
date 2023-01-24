//Copyright © 2023 Mohammed

import UIKit

extension UIViewController : StoryboardInstantiable {
    
    ///Adds the functionality to hide the keyboard when clicking anywhere outside the field
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    ///dismiss the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    ///gets the name of the class
    static var identifier: String {
        let str = NSStringFromClass(self)
        let components = str.components(separatedBy: ".")
        return components.last!
    }
    
    ///instantiates a view controller instance from the provided storyboard
    class func instantiate(storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> Self {
        return  instantiateFromStoryboard(storyboard: storyboard, type: self)
    }
    
    ///instantiates a view controller instance and pushes it in the provided navigation controller stack
    class func instantiateAndPush(navigationController: UINavigationController, animated: Bool = true, storyboardName: String = "Main") {
        navigationController.pushViewController(instantiateFromStoryboard(storyboard: UIStoryboard(name: storyboardName, bundle: nil), type: self), animated: animated)
    }
    
    ///helper function for the instantiate and instantiateAndPush methods
    private class func instantiateFromStoryboard<T: UIViewController>(storyboard: UIStoryboard, type: T.Type) -> T {
        return storyboard.instantiateViewController(withIdentifier: self.identifier) as! T
    }
}


protocol StoryboardInstantiable : AnyObject {
    static var identifier: String { get }
    static func instantiate(storyboard: UIStoryboard) -> Self
}
