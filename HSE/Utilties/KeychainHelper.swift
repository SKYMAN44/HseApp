//
//  KeychainHelper.swift
//  HSE
//
//  Created by Дмитрий Соколов on 04.06.2022.
//

import Foundation

protocol EncryptedStorage {
    
}

final class KeychainHelper {
    static let defaultService: String = "hseSocial.com"
    static let defaultAccount: String = "userToken"
    
    static let shared = KeychainHelper()
    // make sure class is singleton
    private init() {}
    
    // MARK: - External Calls
    public func save<T>(_ item: T, service: String, account: String) where T : Codable {
        do {
            let data = try JSONEncoder().encode(item)
            save(data, service: service, account: account)
        } catch {
            assertionFailure("Failed to encode item for keychain: \(error)")
        }
    }
    
    public func read<T>(service: String, account: String, type: T.Type) -> T? where T: Codable {
        guard let data = read(service: service, account: account),
              "null" != String(data: data, encoding: .utf8) else { return nil }
        
        do {
//            let string = String(data: data, encoding: .utf8)
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
    
    // MARK: - LowLevelApi
    private func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if(status != errSecSuccess) {
            print("Error saving in keychain: \(status)")
        }
        
        if(status == errSecDuplicateItem) {
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    private func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete(service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        SecItemDelete(query)
    }
}
