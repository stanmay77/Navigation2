import UIKit
import MobileCoreServices
import Foundation

class SignUpVC: UIViewController {
    
    private var avatarURL: URL? = nil
    lazy var logInSignUpField = CustomField(frame: .zero, passwordField: false, placeholderText: NSLocalizedString("loginTextFieldPlaceholder", comment:""), inputText: nil)
    
    lazy var passwordSignUpField = CustomField(frame: .zero, passwordField: true, placeholderText: NSLocalizedString("passwordTextFieldPlaceholder", comment:""), inputText: nil)
    
    lazy var confirmPasswordField = CustomField(frame: .zero, passwordField: true, placeholderText: NSLocalizedString("confirmPasswordSignUpPlaceholder", comment:""), inputText: nil)
    
    lazy var nameSignUpField = CustomField(frame: .zero, passwordField: false, placeholderText: NSLocalizedString("yourNameSignUpPlaceholder", comment:""), inputText: nil)
    
    lazy var statusSignUpField = CustomField(frame: .zero, passwordField: false, placeholderText: NSLocalizedString("yourStatusSignUpPlaceholder", comment:""), inputText: nil)
    
    lazy var signUpLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("signUpLabelText", comment:"")
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo.circle")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    lazy var profileLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("profileLabelText", comment:"")
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    
    
    lazy var passwordConfirmationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("passwordConfirmationLabelText", comment:"")
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    lazy var profileStackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.addArrangedSubview(self.nameSignUpField)
        stack.addArrangedSubview(self.statusSignUpField)
        stack.layer.cornerRadius = 10
        stack.layer.borderWidth = 0.5
        stack.layer.borderColor = UIColor.lightGray.cgColor
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = UIColor.systemGray6
        return stack
    }()
    
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.addArrangedSubview(self.logInSignUpField)
        stack.addArrangedSubview(self.passwordSignUpField)
        stack.addArrangedSubview(self.confirmPasswordField)
        stack.layer.cornerRadius = 10
        stack.layer.borderWidth = 0.5
        stack.layer.borderColor = UIColor.lightGray.cgColor
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = UIColor.systemGray6
        return stack
    }()
    
    lazy var scrollSignUpContentView: UIView = {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
     
     
     lazy var signUpScrollView: UIScrollView = {
         let view = UIScrollView(frame: .zero)
         view.isScrollEnabled = true
         view.showsVerticalScrollIndicator = true
         view.showsHorizontalScrollIndicator = false
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    
    lazy var separatorView = Divider()
    lazy var separatorView1 = Divider()
    lazy var separatorView2 = Divider()
    
    lazy var signUpButton = CustomButton(frame: .zero, buttonText: NSLocalizedString("signUpLabel", comment:""), titleColor: .white) {
        [unowned self] in
        
        AuthManager.shared.signUpUser(with: logInSignUpField.text!, password: passwordSignUpField.text!) { [self] result in
            
            switch result {
            case .success(let result):
                
                if let iURL = self.avatarURL {
                    CloudStorageManager.shared.uploadImageAvatar(for: iURL, for: logInSignUpField.text!) { [self] result in
                        switch result {
                        case .success(let url):
                            self.uploadPhotoButton.isEnabled = true
                            StorageManager.shared.saveUserToDB(user: RegisteredUser(login: self.logInSignUpField.text!, fullName: self.nameSignUpField.text ?? "", avatarURL: url.absoluteString ?? "", status: self.statusSignUpField.text ?? ""))
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                else {
                    StorageManager.shared.saveUserToDB(user: RegisteredUser(login: logInSignUpField.text!, fullName: nameSignUpField.text ?? "", avatarURL: "", status: statusSignUpField.text ?? ""))
                }
                
                
                let alertVC = UIAlertController(title: NSLocalizedString("successAlertTitle", comment: ""), message: NSLocalizedString("userRegisteredAlertText", comment: ""), preferredStyle: .alert)
                let alertAction = UIAlertAction(title: NSLocalizedString("okAlertButtonTitle", comment: ""), style: .default) { _ in
                    navigationController?.popViewController(animated: true)
                }
                alertVC.addAction(alertAction)
                present(alertVC, animated: true)
            
            case .failure(let error):
                let alertVC = UIAlertController(title: NSLocalizedString("errorAlertTitle", comment: ""), message: error.localizedSignUpError, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: NSLocalizedString("errorAlertAction", comment: ""), style: .default)
                alertVC.addAction(alertAction)
                present(alertVC, animated: true)
            }
        }
        
    }
    
    lazy var uploadPhotoButton = CustomButton(frame: .zero, buttonText: NSLocalizedString("uploadPhotoButtonLabel", comment: ""), titleColor: .white) {
        [unowned self] in
        
        let imageMediaType = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [imageMediaType]
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true)
    }
    
    
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
        navigationController?.navigationBar.isHidden = false
        
        title = "Sign Up"
        view.backgroundColor = .systemBackground
        
        logInSignUpField.addTarget(self, action: #selector(finishEditing), for: .editingChanged)
        passwordSignUpField.addTarget(self, action: #selector(finishEditing), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(passwordConfirmed), for: .editingChanged)
        passwordConfirmationLabel.isHidden = true
        
        view.addSubview(signUpScrollView)
        signUpScrollView.addSubview(scrollSignUpContentView)
        scrollSignUpContentView.addSubview(stackView)
        scrollSignUpContentView.addSubview(profileStackView)
        scrollSignUpContentView.addSubview(separatorView)
        scrollSignUpContentView.addSubview(separatorView1)
        scrollSignUpContentView.addSubview(separatorView2)
        scrollSignUpContentView.addSubview(signUpLabel)
        scrollSignUpContentView.addSubview(profileLabel)
        scrollSignUpContentView.addSubview(signUpButton)
        scrollSignUpContentView.addSubview(uploadPhotoButton)
        scrollSignUpContentView.addSubview(passwordConfirmationLabel)
        scrollSignUpContentView.addSubview(avatarImageView)
        
        
        
        NSLayoutConstraint.activate([
            signUpScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            signUpScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signUpScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signUpScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollSignUpContentView.topAnchor.constraint(equalTo: signUpScrollView.topAnchor),
            scrollSignUpContentView.widthAnchor.constraint(equalTo: signUpScrollView.widthAnchor),
            scrollSignUpContentView.heightAnchor.constraint(equalTo: signUpScrollView.heightAnchor),
            scrollSignUpContentView.bottomAnchor.constraint(equalTo: signUpScrollView.bottomAnchor),
            scrollSignUpContentView.leadingAnchor.constraint(equalTo: signUpScrollView.leadingAnchor),
            scrollSignUpContentView.trailingAnchor.constraint(equalTo: signUpScrollView.trailingAnchor),
        
            signUpLabel.topAnchor.constraint(equalTo: scrollSignUpContentView.topAnchor, constant: 15),
            signUpLabel.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor, constant: 16),
            signUpLabel.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: scrollSignUpContentView.topAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor, constant: -16),
            
            profileStackView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 10),
            profileStackView.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor, constant: 16),
            profileStackView.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor, constant: -16),
            profileStackView.heightAnchor.constraint(equalToConstant: 100),
            
            logInSignUpField.heightAnchor.constraint(equalToConstant: 50),
            passwordSignUpField.heightAnchor.constraint(equalToConstant: 50),
            confirmPasswordField.heightAnchor.constraint(equalToConstant: 50),
            
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.topAnchor.constraint(equalTo: logInSignUpField.bottomAnchor),
            
            separatorView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            separatorView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            separatorView1.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView1.topAnchor.constraint(equalTo: passwordSignUpField.bottomAnchor),
            
            separatorView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            separatorView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            separatorView2.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView2.topAnchor.constraint(equalTo: nameSignUpField.bottomAnchor),
            
            passwordConfirmationLabel.heightAnchor.constraint(equalToConstant: 20),
            passwordConfirmationLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            passwordConfirmationLabel.widthAnchor.constraint(equalToConstant: 200),
            passwordConfirmationLabel.centerXAnchor.constraint(equalTo: scrollSignUpContentView.centerXAnchor),
            
            profileLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            profileLabel.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor, constant: 16),
            profileLabel.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor, constant: -16),
            
            uploadPhotoButton.heightAnchor.constraint(equalToConstant: 30),
            uploadPhotoButton.topAnchor.constraint(equalTo: profileStackView.bottomAnchor, constant: 15),
            uploadPhotoButton.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor, constant: 50),
            uploadPhotoButton.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor, constant: -50),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 30),
            signUpButton.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor, constant: -16),
            
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.centerXAnchor.constraint(equalTo: uploadPhotoButton.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: uploadPhotoButton.bottomAnchor, constant: 20)
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
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        if signUpScrollView.contentInset.bottom == 0 {
            signUpScrollView.contentInset.bottom += keyboardHeight ?? 0.0
        }
     
        
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        signUpScrollView.contentInset.bottom = 0.0
    }
    
    @objc func finishEditing() {
        signUpButton.isEnabled = !logInSignUpField.text!.isEmpty && !passwordSignUpField.text!.isEmpty
        uploadPhotoButton.isEnabled = !logInSignUpField.text!.isEmpty && !passwordSignUpField.text!.isEmpty

    }
    
    @objc func passwordConfirmed() {
        
        if passwordSignUpField.text! == confirmPasswordField.text! || (passwordSignUpField.text!.isEmpty || confirmPasswordField.text!.isEmpty)
        {
            passwordConfirmationLabel.isHidden = true
            signUpButton.isEnabled = true
            uploadPhotoButton.isEnabled = true
        }
        else {
            passwordConfirmationLabel.isHidden = false
            signUpButton.isEnabled = false
            uploadPhotoButton.isEnabled = false
        }
    }
}


extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        do {
            let imageData = try Data(contentsOf: imageURL)
            avatarImageView.image = UIImage(data: imageData)
        }
        catch {
            print(error.localizedDescription)
        }
        
        self.avatarURL = imageURL
        
        picker.dismiss(animated: true)
        }
    }
