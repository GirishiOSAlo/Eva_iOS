//
//  SecurityKeys.swift
//  EvaConnect
//
//  Created by Pranay Barua on 08/12/23.
//  Copyright © 2023 HyperNym. All rights reserved.
//

import Foundation
import Security

class KeychainService {
    
    private static let serviceIdentifier = "com.hypernym.EvaConnect"
    
    // Save email to Keychain
    static func saveEmail(email: String) {
        saveToKeychain(service: serviceIdentifier, key: "email", data: email)
    }
    
    // Retrieve email from Keychain
    static func getEmail() -> String? {
        return retrieveFromKeychain(service: serviceIdentifier, key: "email")
    }
    
    // Save password to Keychain
    static func savePassword(password: String) {
        saveToKeychain(service: serviceIdentifier, key: "password", data: password)
    }
    
    // Retrieve password from Keychain
    static func getPassword() -> String? {
        return retrieveFromKeychain(service: serviceIdentifier, key: "password")
    }
    
    // Save "remember me" value to Keychain
    static func saveRememberMe(rememberMe: Bool) {
        saveToKeychain(service: serviceIdentifier, key: "rememberMe", data: "\(rememberMe)")
    }
    
    // Retrieve "remember me" value from Keychain
    static func getRememberMe() -> Bool {
        if let rememberMeString = retrieveFromKeychain(service: serviceIdentifier, key: "rememberMe"),
           let rememberMe = Bool(rememberMeString) {
            return rememberMe
        }
        return false
    }
    
    // Generic function to save data to Keychain
    private static func saveToKeychain(service: String, key: String, data: String) {
        if let dataFromString = data.data(using: .utf8) {
            let keychainQuery: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: key,
                kSecValueData as String: dataFromString
            ]
            
            SecItemDelete(keychainQuery as CFDictionary)
            
            let _ = SecItemAdd(keychainQuery as CFDictionary, nil)
        }
    }
    
    // Generic function to retrieve data from Keychain
    private static func retrieveFromKeychain(service: String, key: String) -> String? {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &result)
        
        if status == errSecSuccess {
            if let data = result as? Data, let value = String(data: data, encoding: .utf8) {
                return value
            }
        }
        
        return nil
    }
}
