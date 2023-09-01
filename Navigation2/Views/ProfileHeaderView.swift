import UIKit

final class ProfileHeaderView: UIView {
    
    private var statusText: String?
    
    lazy var setStatusButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .systemBlue
        button.setTitle("Show status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 4.0
        button.layer.shadowOffset = CGSizeMake(4, 4)
        button.layer.shadowRadius = 4.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let fullNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
        let tapAvatar = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        imageView.addGestureRecognizer(tapAvatar)
        return imageView
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x:10, y:10, width: 100, height: 35))
        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.addSpacer(for: 10)
        textField.placeholder = "Enter status..."
        return textField
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(setStatusButton)
        self.addSubview(fullNameLabel)
        self.addSubview(avatarImageView)
        self.addSubview(statusLabel)
        self.addSubview(statusTextField)
        
        NSLayoutConstraint.activate([
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            
            setStatusButton.heightAnchor.constraint(equalToConstant: 50),
            setStatusButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            setStatusButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            setStatusButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            
            fullNameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 40),
            fullNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            
            statusLabel.bottomAnchor.constraint(equalTo: setStatusButton.topAnchor, constant: -50),
            statusLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 40),
            
            statusTextField.bottomAnchor.constraint(equalTo: setStatusButton.topAnchor, constant: -10),
            statusTextField.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 40),
            statusTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            statusTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        
        
    }
    
    @objc func buttonPressed() {
        statusLabel.text = self.statusText
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        self.statusText = textField.text ?? ""
    }
      
    @objc func tapImage() {
        print("img tapped")
    }
    
    }
