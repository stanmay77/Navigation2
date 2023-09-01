import UIKit


class CustomButton: UIButton {
    
    typealias Action = (()->Void)
    
    var buttonText: String? = nil
    var titleColor: UIColor? = nil
    var tapAction: Action
    
    
    init(frame: CGRect, buttonText: String?, titleColor: UIColor?, action: @escaping Action) {
        self.tapAction = action
        super.init(frame: frame)
        self.setTitle(buttonText, for: .normal)
        
        self.titleColor = titleColor
        self.layer.cornerRadius = 10
        self.setTitleColor(titleColor, for: .normal)
        
    
        self.setBackgroundImage(UIImage(named: "blue_pixel")!, for: .normal)
        self.setBackgroundImage(UIImage(named: "blue_pixel")!.image(alpha: 0.8), for: .selected)
        self.setBackgroundImage(UIImage(named: "blue_pixel")!.image(alpha: 0.8), for: .highlighted)
        self.setBackgroundImage(UIImage(named: "blue_pixel")!.image(alpha: 0.8), for: .disabled)
        self.imageView?.layer.cornerRadius = 10.0
        
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(tapOnButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func tapOnButton() {
        tapAction()
    }
    
    
}
