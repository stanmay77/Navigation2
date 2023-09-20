import UIKit

class LoginVC: UIViewController {
    
    var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var logoImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = UIImage(named: "logo")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var loginField = CustomField(frame: .zero, passwordField: false, placeholderText: NSLocalizedString("loginTextFieldPlaceholder", comment: ""), inputText: "stan@google.com")
    lazy var passwordField = CustomField(frame: .zero, passwordField: true, placeholderText: NSLocalizedString("passwordTextFieldPlaceholder", comment: ""), inputText: "111111")
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.addArrangedSubview(self.loginField)
        stack.addArrangedSubview(self.passwordField)
        stack.layer.cornerRadius = 10
        stack.layer.borderWidth = 0.5
        stack.layer.borderColor = UIColor.lightGray.cgColor
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = UIColor.fieldColor1
        return stack
    }()
    
    lazy var signUpLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("signUpLabel", comment: "")
        label.textColor = UIColor.link
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSignUpLabel))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var loginButton = CustomButton(frame: .zero, buttonText: NSLocalizedString("loginButtonTitle", comment: ""), titleColor: .white) {
        var email = self.loginField.text ?? ""
        var password = self.passwordField.text ?? ""
        
        self.viewModel.updateState(input: .userCredentialsInput((email, password)))
        self.viewModel.onStateChanged = { [self] state in
            
            switch state {
            case .logged(let user):
                let vc = TabVC(userLogged: user)
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
                
            case .notlogged(let error):
                if error != nil {
                    let alertVC = UIAlertController(title: NSLocalizedString("errorAlertTitle", comment: ""), message: error!.localizedAuthError, preferredStyle: .alert)
                    let action = UIAlertAction(title: NSLocalizedString("errorAlertAction", comment: ""), style: .cancel)
                    alertVC.addAction(action)
                    present(alertVC, animated: true)
                }
            }
        }
    }
    
    
    lazy var scrollVew: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.isScrollEnabled = true
        scroll.showsVerticalScrollIndicator = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var scrollContentView: UIView = {
        let scrollContent = UIView(frame: .zero)
        scrollContent.translatesAutoresizingMaskIntoConstraints = false
        return scrollContent
    }()
    
    lazy var divider = Divider(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollVew)
        scrollVew.addSubview(scrollContentView)
        scrollContentView.addSubview(logoImageView)
        scrollContentView.addSubview(stackView)
        scrollContentView.addSubview(divider)
        scrollContentView.addSubview(loginButton)
        scrollContentView.addSubview(signUpLabel)
        
        loginField.delegate = self
        passwordField.delegate = self
        
        NSLayoutConstraint.activate([
            scrollVew.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollVew.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollVew.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollVew.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollVew.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollVew.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollVew.trailingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollVew.widthAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollVew.bottomAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            
            loginField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            divider.topAnchor.constraint(equalTo: loginField.bottomAnchor),
            
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16),
            
            signUpLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5),
            signUpLabel.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            signUpLabel.heightAnchor.constraint(equalToConstant: 30),
        
            signUpLabel.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height+2.5*loginButton.frame.height, right: 0)
            scrollVew.contentInset = insets
            scrollVew.scrollIndicatorInsets = insets
            
        }
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollVew.contentInset = .zero
        scrollVew.scrollIndicatorInsets = .zero
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func tapSignUpLabel() {
                let vc = SignUpVC()
                vc.modalPresentationStyle = .formSheet
                present(vc, animated: true)
    }
    
}

extension LoginVC: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}
