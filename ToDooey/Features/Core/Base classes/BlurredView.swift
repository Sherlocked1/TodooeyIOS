//Copyright © 2023 Mohammed

import Foundation
import UIKit

class BlurredView: UIView {

    private let blurEffectView: UIVisualEffectView

    override init(frame: CGRect) {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(frame: frame)

        blurEffectView.frame = bounds
        addSubview(blurEffectView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
