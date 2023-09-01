import FirebaseStorage
import Foundation


final class CloudStorageManager {
    
    static let shared = CloudStorageManager()
    
    private init() { }
    
    func uploadImageAvatar(for fileURL: URL, for login: String, completion: @escaping (Result<URL,Error>)-> Void) {
        //        let storage = Storage.storage()
        //        let storageRef = storage.reference()
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let fileExtension = fileURL.pathExtension
        let fileName = "\(login).\(fileExtension)"
        let storageReference = Storage.storage().reference().child(fileName)
        
        let uploadTask = storageReference.putFile(from: fileURL, metadata: metadata) { meta, error in
            
            if let error {
                completion(.failure(error))
            }
            
            storageReference.downloadURL { (url, error) in
                if let error = error  {
                    completion(.failure(error))
                }
                completion(.success(url!))
            }
     
        }
    }
}
