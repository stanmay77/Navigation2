//
//  ProfileVCViewController.swift
//  Navigation2
//
//  Created by STANISLAV MAYBORODA on 8/30/23.
//

import UIKit

class ProfileVC: UIViewController {

    
    var userLogged: RegisteredUser?
    var profileVC: ProfileHeaderView? = nil
    
    
    
    init(userLogged: RegisteredUser) {
        self.userLogged = userLogged
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let postsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.reuseIdentifier)
        table.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.reuseIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.estimatedRowHeight = 850
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileVC = ProfileHeaderView()
        profileVC?.fullNameLabel.text = userLogged!.fullName
        profileVC?.statusLabel.text = userLogged!.status
        
        
        DispatchQueue.main.async {
            let avatarData = NSData(contentsOf: URL(string: self.userLogged!.avatarURL!)!)
            let image = UIImage(data: avatarData! as Data)
            self.profileVC?.avatarImageView.image = image ?? UIImage(systemName: "xmark.icloud")
        }
        
        configureUI()
    }
    

    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = NSLocalizedString("ProfileVCTitle", comment: "")
        navigationItem.titleView?.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("LogOutButtonTitle", comment: ""), style: .plain, target: self, action: #selector(tapLogOut))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("LocationButtonTitle", comment: ""), style: .plain, target: self, action: #selector(tapLocation))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        
        postsTable.delegate = self
        postsTable.dataSource = self
        
        view.addSubview(postsTable)
        
        NSLayoutConstraint.activate(
            [
                postsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                postsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                postsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                postsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        let gestureDoubleTap = UITapGestureRecognizer(target: self, action: #selector(tableViewTap))
        gestureDoubleTap.numberOfTapsRequired = 2
        postsTable.addGestureRecognizer(gestureDoubleTap)
    }
    
    @objc func tapLogOut() {
        AuthManager.shared.logOut()
        let loginVC = LoginVC(viewModel: LogModel())
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    @objc func tapLocation() {
        navigationController?.pushViewController(LocationVC(), animated: true)
    }

    
    @objc func tableViewTap(_ recognizer: UITapGestureRecognizer) {
        let loc = recognizer.location(in: postsTable)
        if let indexPath = self.postsTable.indexPathForRow(at: loc) {
            CoreDManager.shared.savePost(Post.posts[indexPath.row])
            NotificationCenter.default.post(name: NSNotification.Name("didTappedOnFavorites"), object: self)
        }
        
    }
}


extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return Post.posts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.reuseIdentifier, for: indexPath) as? PhotosTableViewCell else { return UITableViewCell() }
            return cell
        }
        else  {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier, for: indexPath) as? PostTableViewCell else { return UITableViewCell()}
            cell.configure(for: Post.posts[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0
        {
            return profileVC
        }
        else
        {
            return UIView()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 200
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return (view.frame.size.width - 48) / 4 + 50
        }
        else
        {
            return tableView.rowHeight
        }
    }
    
    
}
