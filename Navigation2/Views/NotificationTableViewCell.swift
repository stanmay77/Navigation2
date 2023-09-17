//
//  NotificationTableViewCell.swift
//  Navigation2
//
//  Created by STANISLAV MAYBORODA on 9/14/23.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    static let cellId = "NotificationTableViewCell"
    
    let notificationTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.monochrome
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let notificationDateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.monochrome
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let notificationTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.monochrome
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: NotificationTableViewCell.cellId)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubview(notificationTitle)
        contentView.addSubview(notificationDateLabel)
        contentView.addSubview(notificationTextLabel)
        
        NSLayoutConstraint.activate([
            notificationTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            notificationTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            notificationTitle.heightAnchor.constraint(equalToConstant: 20),
            notificationTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            notificationDateLabel.topAnchor.constraint(equalTo: notificationTitle.bottomAnchor, constant: 5),
            notificationDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            notificationDateLabel.heightAnchor.constraint(equalToConstant: 20),
            notificationDateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            notificationTextLabel.topAnchor.constraint(equalTo: notificationDateLabel.bottomAnchor, constant: 5),
            notificationTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
//            notificationTextLabel.heightAnchor.constraint(equalToConstant: 20),
            notificationTextLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            notificationTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
    }
    
    
    func configureCell(for notification: Notification) {
        notificationTitle.text = "🔔 "+notification.name
        notificationDateLabel.text = notification.time
        notificationTextLabel.text = notification.body
    }
    
}
