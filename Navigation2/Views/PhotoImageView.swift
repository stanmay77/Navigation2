import UIKit

final class PhotoImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, photo: UIImage) {
        self.init(frame: frame)
        configureUI(for: photo)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configureUI(for photo: Photo) {
//        self.image = UIImage(named: photo.name)
//        self.layer.cornerRadius = 6
//        self.contentMode = .scaleAspectFill
//        self.clipsToBounds = true
//        self.translatesAutoresizingMaskIntoConstraints = false
//    }
    
    func configureUI(for photo: UIImage) {
        self.image = photo
        self.layer.cornerRadius = 6
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}
