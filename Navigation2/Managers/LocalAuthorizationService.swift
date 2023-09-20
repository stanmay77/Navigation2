import Foundation
import LocalAuthentication

final class LocalAuthorizationService {
    
    static let shared = LocalAuthorizationService()
    
    private init() { }
    
    let manager = LAContext()
    
    var canUseBiometry: Bool {
        var error: NSError? = nil
        let canEvaluatePolicy = LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if error == nil && canEvaluatePolicy == true {
            return true
        } else {
            return false
        }
    }
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        
        var error: NSError? = nil
        let canEvaluatePolicy = manager.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if error != nil {
            print(error?.localizedDescription)
        }
        
        guard canEvaluatePolicy else { return }
        
        manager.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Reason") { result, error in
            if result {
                authorizationFinished(true)
            } else {
                authorizationFinished(false)
            }
        }
    }
    
}


