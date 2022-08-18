//
//  Keychan.swift
//  TNS-SWIFT-UI
//
//  Created by Christian Paulo on 17/08/22.
//

import Foundation

func getPassword() -> String? {
        guard let data = KeychainManager.get(
            service: "Apple.Developer.Academy.TSN-SWIFT-UI2",
            account: "academy") else {
            return nil
        }
    
    let password = String(decoding: data, as: UTF8.self)
    return password
       
}

func save(token : String){
    do {
        try KeychainManager.save(
            service: "Apple.Developer.Academy.TSN-SWIFT-UI2",
            account: "academy",
            token: token.data(using: .utf8) ?? Data() )
    }
    catch {
        print (error)
    }
}

func delete(service: String, account: String) {

    let query = [
        kSecAttrService: service,
        kSecAttrAccount: account,
        kSecClass: kSecClassGenericPassword,
        ] as CFDictionary

    // Delete item from keychain
    SecItemDelete(query)
}

class KeychainManager{
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    static func save(
        service: String,
        account: String,
        token: Data
    ) throws{
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: token as AnyObject,
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else{
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        print("Saved")
    }
    static func get(
        service: String,
        account: String
    ) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        print("Read Status: \(status)")
        

        return result as? Data
    }
}
