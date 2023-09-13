//
//  FavVC.swift
//  Navigation2
//
//  Created by STANISLAV MAYBORODA on 8/30/23.
//

import UIKit

class FavVC: UIViewController {
    
    var posts: [Post] {
        let postsCD = CoreDManager.shared.posts
        return postsCD.map({$0.toStruct()})
    }
    
    lazy var favPostsTable: UITableView = {
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
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(didAddedFavorites), name: NSNotification.Name("didTappedOnFavorites"), object: nil)
    }
    
    
    
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = NSLocalizedString("favoritePostsVCTitle", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("LogOutButtonTitle", comment: ""), style: .plain, target: self, action: #selector(logOut))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        favPostsTable.delegate = self
        favPostsTable.dataSource = self
        
        view.addSubview(favPostsTable)
        
        NSLayoutConstraint.activate([
            favPostsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favPostsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favPostsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favPostsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
    }
    
    @objc func logOut() {
        AuthManager.shared.logOut()
        let loginVC = LoginVC(viewModel: LogModel())
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    @objc func didAddedFavorites() {
        favPostsTable.reloadData()
    }

}


extension FavVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier, for: indexPath) as? PostTableViewCell else { return UITableViewCell()}
        cell.configure(for: self.posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDManager.shared.deletePost(at: indexPath.row)
            favPostsTable.reloadData()
        }
    }
    
    
}
