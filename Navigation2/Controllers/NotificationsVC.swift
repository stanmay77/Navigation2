import UIKit
import UserNotifications

class NotificationsVC: UIViewController {

    var notifications: [Notification] = []
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(NotificationTableViewCell.self, forCellReuseIdentifier: "NotificationTableViewCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.estimatedRowHeight = 100
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAdded), name: NSNotification.Name("notificationAdded"), object: nil)
        
        updateNotificationsTable()
        configureUI()
    }
    
    func configureUI() {
        navigationItem.title = NSLocalizedString("notificationsVCTitle", comment: "")
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        let addNavItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddNotification))
        addNavItem.tintColor = .white
        navigationItem.rightBarButtonItem = addNavItem
    
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    @objc func tapAddNotification() {
        navigationController?.pushViewController(SetNotificationVC(), animated: true)
    }
    
    @objc func notificationAdded() {
        updateNotificationsTable()
    }
    
    func updateNotificationsTable() {
        LocalNotificationsService.shared.getPendingNotifications { [weak self] completion in
            self?.notifications = completion
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath)) as!
        NotificationTableViewCell
        cell.configureCell(for: notifications[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            LocalNotificationsService.shared.deleteNotification(id: notifications[indexPath.row].id)
            updateNotificationsTable()
        }
    }
  
}
