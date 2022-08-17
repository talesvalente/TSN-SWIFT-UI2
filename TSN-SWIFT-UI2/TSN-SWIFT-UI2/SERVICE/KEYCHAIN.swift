//
//  Keychan.swift
//  TNS-SWIFT-UI
//
//  Created by Christian Paulo on 17/08/22.
//

import Foundation

func getPassword(){
        guard let data = KeychainManager.get(
            service: "Apple.Developer.Academy.TSN-SWIFT-UI2",
            account: "papai") else {
            print("sdfasdgds")
            return
        }
    
    let password = String(decoding: data, as: UTF8.self)
    print(password)
       
}

func save(){
    do {
        try KeychainManager.save(
            service: "Apple.Developer.Academy.TSN-SWIFT-UI2",
            account: "affraz",
            token: "something".data(using: .utf8) ?? Data() )
    }
    catch {
        print (error)
    }
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