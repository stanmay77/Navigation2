import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift



final class StorageManager {
    
    let db = Firestore.firestore()
    static let shared = StorageManager()
    private init() {}
    

    
    func saveUserToDB(user: RegisteredUser) {

          let collectionRef = db.collection("Users")
          do {
              let newUserReference = try collectionRef.addDocument(from: user)
              print("User stored with new document reference: \(newUserReference)")
          }
          catch {
              print(error.localizedDescription)
          }
        }
    
    func getUser(by login: String, completion: @escaping (RegisteredUser) -> Void) {
        
        let collectionRef = db.collection("Users")
        
        let query = collectionRef.whereField("login", isEqualTo: login)
        
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {

                    do {
                        
                        let user = try document.data(as: RegisteredUser.self)
                        completion(user)
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    }



