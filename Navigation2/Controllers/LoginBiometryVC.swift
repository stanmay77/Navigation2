import UIKit

class LoginBiometryVC: UIViewController {
    
    var userLogged: RegisteredUser
    
    init(userLogged: RegisteredUser) {
        self.userLogged = userLogged
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
    
    
    lazy var faceIDImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "faceid")
        imageView.tintColor = UIColor.faceIdColor
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tapImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapFaceId))
        imageView.addGestureRecognizer(tapImageRecognizer)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authWithBiometrics()
    }
    
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(logoImageView)
        view.addSubview(faceIDImageView)

        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            faceIDImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 100),
            faceIDImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            faceIDImageView.heightAnchor.constraint(equalToConstant: 100),
            faceIDImageView.widthAnchor.constraint(equalToConstant: 100)

        ])
    }
    
    func authWithBiometrics() {
        LocalAuthorizationService.shared.authorizeIfPossible { [self] authResult in
            switch authResult {
            case true:
                DispatchQueue.main.async {
                    let vc = TabVC(userLogged: self.userLogged)
                    vc.modalPresentationStyle = .fullScreen
                    present(vc, animated: true)
                }
            case false:
                return
            }
        }
    }
    
    
    @objc func tapFaceId() {

    }
}
