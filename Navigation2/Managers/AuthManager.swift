import FirebaseAuth


enum AuthError: String, Error {
    case invalidPassword = "Wrong password entered"
    case emailBadlyFormatted = "Login not in email format"
    case userNotRegistered = "User not registered. Pls sign up"
    case otherError = "Other error. Pls relogin"
}

enum SignUpError: String, Error {
    case signUpEmailBadlyFormatted = "Login not in email format"
    case signUpUserAlreadyExists = "User already exists"
    case otherSignUpError = "Other error. Pls try again later"
    case passwordLengthIncorrect = "Password must be 6 characters long or more"
}


final class AuthManager {
    
    static let shared = AuthManager()
    private init() { }
    
    var userLogged: String? {
        if let user = Auth.auth().currentUser {
            return user.email!
        } else {
            return nil
        }
    }
    
    
    func logUserIn(email: String, password: String, completion: @escaping (Result<Bool, AuthError>)->Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error {
                switch error.localizedDescription {
                case "There is no user record corresponding to this identifier. The user may have been deleted.":
                    completion(.failure(.userNotRegistered))
                case "The email address is badly formatted.":
                    completion(.failure(.emailBadlyFormatted))
                case "The password is invalid or the user does not have a password.":
                    completion(.failure(.invalidPassword))
                default:
                    completion(.failure(.otherError))
                }
            }
            
            guard let result else {
                return
            }
            
            completion(.success(true))
        }
    }
    
    func signUpUser(with email: String, password: String, completion: @escaping (Result<Bool, SignUpError>)->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            
            if let error {
                switch error.localizedDescription {
                case "The email address is badly formatted.":
                    completion(.failure(.signUpEmailBadlyFormatted))
                case "The email address is already in use by another account.":
                    completion(.failure(.signUpUserAlreadyExists))
                case "The password must be 6 characters long or more.":
                    completion(.failure(.passwordLengthIncorrect))
                default:
                    completion(.failure(.otherSignUpError))
                }
            }
            
            if let error {
                print(error.localizedDescription)
                return
            }
            
            guard let result else {
                return
            }
            
            completion(.success(true))
            
        }
        
    }
    
    func logOut() {
        try? Auth.auth().signOut()
    }
    
}
