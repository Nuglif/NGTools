import UIKit
import NGTools

 // MARK: - Validator

public struct EmailValidator: Validator {
    public typealias T = String
    
    private let predicate: NSPredicate
    
    public init(predicate: NSPredicate) {
        self.predicate = predicate
    }
    
    public func isValid(value: String) -> Bool {
        return predicate.evaluate(with: value)
    }
}

struct EmailAddress {
    let email: String
    
    public init?(untrustedEmail: Untrusted<String>, validator: EmailValidator) {
        guard let email = validator.validate(untrusted: untrustedEmail) else {
            return nil
        }
        self.email = email
    }
}

struct User {
    let email: EmailAddress?
}

let predicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
let emailValidator = EmailValidator(predicate: predicate)

let userWrongEmail = User(email: EmailAddress(untrustedEmail: Untrusted("toto"), validator: emailValidator))

print("Email is wrong: \(reflect(userWrongEmail.email))")

let userGoodEmail = User(email: EmailAddress(untrustedEmail: Untrusted("werckayrton@gmail.com"), validator: emailValidator))

print(reflect(userGoodEmail.email))
