import UIKit

protocol LoginViewModel {
    
    var onStateChanged: ((LogModel.State)->Void)? { get set }
    func updateState(input: LogModel.Input)
}


final class LogModel: LoginViewModel {
    
    
    var onStateChanged: ((State) -> Void)?
    
    
    enum State {
        case logged(RegisteredUser)
        case notlogged(AuthError?)
    }
    
    enum Input {
        case userCredentialsInput((String, String))
       // case errorInLogin(AuthError)
       // case signUp
    }
    
    var state: State = .notlogged(nil) {
        didSet {
            onStateChanged!(state)
        }
    }
    
    func updateState(input: Input) {
        switch input {
        case .userCredentialsInput((let login, let password)):
            AuthManager.shared.logUserIn(email: login, password: password) { result in
                switch result {
                case .success:
                    StorageManager.shared.getUser(by: login) { user in
                        self.state = .logged(user)
                    }
                    
                case .failure(let error):
                    self.state = .notlogged(error)
                    print(error)
                }
            }
        }
        
    }
}
