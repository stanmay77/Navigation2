import UIKit

class SetNotificationVC: UIViewController {

    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .dateAndTime
        picker.layer.cornerRadius = 8
        picker.layer.borderColor = UIColor.systemGray.cgColor
        picker.layer.borderWidth = 1
        return picker
    }()
    
    
    let notificationTitleTextField = CustomField(frame: .zero, passwordField: false, placeholderText: "", inputText: nil)
    let notificationBodyTextField = CustomField(frame: .zero, passwordField: false, placeholderText: "", inputText: nil)
    
    lazy var setNotificationButton = CustomButton(frame: .zero, buttonText: NSLocalizedString("setNotificationVCTitle", comment: ""), titleColor: .white) {
        LocalNotificationsService.shared.addNotification(for: self.datePicker.date, under: self.notificationTitleTextField.text ?? "", with: self.notificationBodyTextField.text ?? "")
        NotificationCenter.default.post(name: NSNotification.Name("notificationAdded"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkNotificationsAuth()
    }
    
    func configureUI() {
        navigationItem.title = NSLocalizedString("setNotificationVCTitle", comment: "")

        view.addSubview(datePicker)
        view.addSubview(notificationTitleTextField)
        view.addSubview(notificationBodyTextField)
        view.addSubview(setNotificationButton)
        view.backgroundColor = .systemBackground
        
        notificationBodyTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("notificationBodyField", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.fieldColor2])
         
        notificationTitleTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("notificationTitleField", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.fieldColor2])
     
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            notificationTitleTextField.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            notificationTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notificationTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            notificationTitleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            notificationBodyTextField.topAnchor.constraint(equalTo: notificationTitleTextField.bottomAnchor, constant: 20),
            notificationBodyTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notificationBodyTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            notificationBodyTextField.heightAnchor.constraint(equalToConstant: 50),
            
            setNotificationButton.topAnchor.constraint(equalTo: notificationBodyTextField.bottomAnchor, constant: 20),
            setNotificationButton.heightAnchor.constraint(equalToConstant: 50),
            setNotificationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            setNotificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    
    func checkNotificationsAuth() {
        LocalNotificationsService.shared.checkAuthStatus { authResult in
            switch authResult {
            case true:
                break
            case false:
                
                DispatchQueue.main.async {
                    let alertVC = UIAlertController(title: NSLocalizedString("errorAlertTitle", comment: ""), message: NSLocalizedString("notificationAuthorizationAlert", comment: ""), preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: NSLocalizedString("okAlertButtonTitle", comment: ""), style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alertVC.addAction(alertAction)
                    self.present(alertVC, animated: true)
                }
            }
            
        }
        
    }


}
