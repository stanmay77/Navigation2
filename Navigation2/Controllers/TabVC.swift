//
//  TabVCViewController.swift
//  Navigation2
//
//  Created by STANISLAV MAYBORODA on 8/30/23.
//

import UIKit
import FirebaseAuth

class TabVC: UITabBarController {

    var userLogged: RegisteredUser
    
    init(userLogged: RegisteredUser) {
        self.userLogged = userLogged
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
       
    }
    
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        
        UITabBar.appearance().backgroundColor = UIColor(red: 53.0, green: 144.0, blue: 243.0, alpha: 0.6)
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
               
        navigationBarAppearance.shadowColor = nil
        navigationBarAppearance.backgroundColor = UIColor(named: "AccentColor")
        UINavigationBar.appearance().barStyle = .default
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        
        let tabVC1 = UINavigationController(rootViewController: ProfileVC(userLogged: userLogged))
        let tabVC2 = UINavigationController(rootViewController: FavVC())
        
        
//        let tabVC1 = ProfileVC()
//        let tabVC2 = FavVC()
        
        
        tabVC1.tabBarItem = UITabBarItem(title: "My profile", image: UIImage(systemName: "person.circle"), tag: 1)
        
        tabVC2.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.circle"), tag: 1)
        
        self.setViewControllers([tabVC1, tabVC2], animated: true)
    }
    

}
