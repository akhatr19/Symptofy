//
//  RealmDatabase.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/2/23.
//

import Foundation
import RealmSwift

class RealmDatabase: NSObject {
    private(set) var localRealm: Realm?
    private static var realmDB: RealmDatabase?
    
    static func sharedInstance() -> RealmDatabase {
        if realmDB == nil {
            realmDB = RealmDatabase()
        }
        return realmDB!
    }
    
    private override init() {
        super.init()
        updateeScheme()
    }
    
    func updateeScheme() {
        let fileURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0],
                        isDirectory: true).appendingPathComponent("parkinsonsity.realm")
        let version = UInt64(Bundle.main.infoDictionary?["CFBundleVersion"] as! String)!
        let schemaVersion = version + 1
//        let encConfig = Realm.Configuration(fileURL: fileURL, encryptionKey: getKey(),
//                                            schemaVersion: schemaVersion, migrationBlock: { _, oldSchemaVersion in
//            if oldSchemaVersion < schemaVersion {
//            }
//        })

        let encConfig = Realm.Configuration(schemaVersion: schemaVersion) { _, oldSchemaVersion in
            if oldSchemaVersion < schemaVersion {
            }
        }

        print(encConfig.fileURL!)

        do {
            localRealm = try Realm(configuration: encConfig)
        } catch let error as NSError {
            fatalError("error \(error)")
        }
    }

    func getRealmDB() -> Realm {
        return localRealm!
    }
    
    fileprivate func getKey() -> Data {
        let keychainIdentifier = "parkinsons_sec_key"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!

        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]

        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! Data
        }

        var key = Data(count: 64)
        key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
            let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            assert(result == 0, "Failed to get random bytes")
        })

        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: key as AnyObject
        ]

        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        return key
    }
}
