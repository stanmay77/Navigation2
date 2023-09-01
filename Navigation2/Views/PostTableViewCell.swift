import UIKit

final class PostTableViewCell: UITableViewCell {
    
    lazy var postHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var postImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleToFill
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let postTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    static let reuseIdentifier = "customCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: PostTableViewCell.reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubview(postHeaderLabel)
        addSubview(postTextLabel)
        addSubview(postImageView)
        addSubview(likesLabel)
        addSubview(viewsLabel)
 
        NSLayoutConstraint.activate(
            [
                
                postHeaderLabel.topAnchor.constraint(equalTo: topAnchor),
                postHeaderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                postHeaderLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                
//                postImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
//                postImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
//                postImageView.topAnchor.constraint(equalTo: postHeaderLabel.bottomAnchor),
                
                postImageView.topAnchor.constraint(equalTo: postHeaderLabel.bottomAnchor),
                postImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                postImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                postImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                      
                postTextLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
                postTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                postTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                
                likesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                likesLabel.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: Constants.likesViewsTopConstraint),
                likesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.likesViewsBottomConstraint),

                viewsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                viewsLabel.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: Constants.likesViewsTopConstraint),
                viewsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.likesViewsBottomConstraint)
            ])
    }
    
    func configure(for post:Post) {
        postHeaderLabel.text = post.title
        guard let postImage = UIImage(named: post.image) else { return }
        postImageView.image = postImage
        postTextLabel.text = post.descr
        likesLabel.text = "👍 Likes: \(post.likes)"
        viewsLabel.text = "👀 Views: \(post.views)"
    }
    
}
