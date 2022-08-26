//
//  File.swift
//  TSN-SWIFT-UI2
//
//  Created by Tales Valente on 25/08/22.
//

import Foundation
import SwiftUI
import Combine

class FormViewModel: ObservableObject {

    @Published var password = ""
    @Published var validations: [Validation] = []
    @Published var isValid: Bool = false

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        // Validations
        passwordPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validations, on: self)
            .store(in: &cancellableSet)

        // isValid
        passwordPublisher
            .receive(on: RunLoop.main)
            .map { validations in
                return validations.filter { validation in
                    return ValidationState.failure == validation.state
                }.isEmpty
            }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }

    private var passwordPublisher: AnyPublisher<[Validation], Never> {
        $password
            .removeDuplicates()
            .map { password in

                var validations: [Validation] = []
                validations.append(Validation(string: password,
                                              id: 0,
                                              field: .password,
                                              validationType: .isNotEmpty))

                validations.append(Validation(string: password,
                                              id: 1,
                                              field: .password,
                                              validationType: .minCharacters(min: 8)))

                validations.append(Validation(string: password,
                                              id: 2,
                                              field: .password,
                                              validationType: .hasSymbols))

                validations.append(Validation(string: password,
                                              id: 3,
                                              field: .password,
                                              validationType: .hasUppercasedLetters))
                
                validations.append(Validation(string: password,
                                              id: 4,
                                              field: .password,
                                              validationType: .hasNumbers))
                return validations
            }
            .eraseToAnyPublisher()
    }
}


enum Field: String {
    case username
    case password
}

enum ValidationState {
    case success
    case failure
}

enum ValidationType {
    case isNotEmpty
    case minCharacters(min: Int)
    case hasSymbols
    case hasUppercasedLetters
    case hasNumbers
    
    func fulfills(string: String) -> Bool {
        switch self {
        case .isNotEmpty:
            return !string.isEmpty
        case .minCharacters(min: let min):
            return string.count > min
        case .hasSymbols:
            return string.hasSpecialCharacters()
        case .hasUppercasedLetters:
            return string.hasUppercasedCharacters()
        case .hasNumbers:
            return string.hasNumbers()
        }
    }
    
    func message(fieldName: String) -> String {
        switch self {
        case .isNotEmpty:
            return "Não pode ser vazia"
        case .minCharacters(min: let min):
            return "Precisa ser maior que \(min) caracteres"
        case .hasSymbols:
            return "Deve ter ao menos 1 caracter especial"
        case .hasUppercasedLetters:
            return "Deve ter ao menos 1 letra maíuscula"
        case .hasNumbers:
            return "Deve ter ao menos 1 número"
        }
    }
}

struct Validation: Identifiable {
    var id: Int
    var field: Field
    var validationType: ValidationType
    var state: ValidationState
    
    init(string: String, id: Int, field: Field, validationType: ValidationType) {
        self.id = id
        self.field = field
        self.validationType = validationType
        self.state = validationType.fulfills(string: string) ? .success : .failure
    }
}

extension String {

    func hasUppercasedCharacters() -> Bool {
        return stringFulfillsRegex(regex:  ".*[A-Z]+.*")
    }

    func hasSpecialCharacters() -> Bool {
        return stringFulfillsRegex(regex: ".*[^A-Za-z0-9].*")
    }
    
    func hasNumbers() -> Bool {
        return stringFulfillsRegex(regex: ".*[0-9].*")
    }
    
    private func stringFulfillsRegex(regex: String) -> Bool {
        let texttest = NSPredicate(format: "SELF MATCHES %@", regex)
        guard texttest.evaluate(with: self) else {
            return false
        }
        return true
    }
}

//COMBINE
