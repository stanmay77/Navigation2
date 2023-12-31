import UIKit


class CustomField: UITextField {
    
    let passwordField: Bool = false
    let placeholderText: String? = nil
    let inputText: String? = nil
    
    init(frame: CGRect, passwordField: Bool, placeholderText: String?, inputText: String?) {
        super.init(frame: frame)
        self.placeholder = placeholderText ?? ""
        self.text = inputText ?? ""
        self.isSecureTextEntry = passwordField
        self.addSpacer(for: 10)
        self.textColor = .black
        self.font = UIFont.systemFont(ofSize: 16)
        self.layer.cornerRadius = 10
        self.autocapitalizationType = .none
        self.backgroundColor = UIColor.systemGray6
        self.tintColor = UIColor(named: "AccentColor")
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
