//
//  OTPStore.swift
//  2F
//
//  Created by Javier Matusevich on 29/12/2017.
//  Copyright © 2017 Javier Matusevich. All rights reserved.
//

import UIKit
import OneTimePassword
import KeychainAccess

class OTPStore: NSObject {
    let keychain = Keychain(service: "ar.com.stanet.javiermatusevich.2F.otp")
    private let idGenerator = UUID()
    func listTokens() -> [Token?] {
        // TODO: Retrieve from Keychain
        let items = self.keychain.allItems()
        if let entries = items as? [[String: String]] {
            let r = entries
                .map({$0["value"]!})
                .map({URL(string: $0)!})
                .map({Token(url: $0)})
            return r
        }
        return [];
    }
    
    func clearAllItems() {
        do {
            // Should be the secret invalidated when passcode is removed? If not then use `.WhenUnlocked`
            
            try self.keychain.removeAll()
        } catch let error {
            // Error handling if needed...
        }
    }
    
    func addToken(otpURL url: URL) -> Token? {
        if let token = Token(url: url) {
            print("Succesful import")
            let identifier = self.idGenerator.uuidString
            DispatchQueue.global().async {
                do {
                    // Should be the secret invalidated when passcode is removed? If not then use `.WhenUnlocked`

                    try self.keychain
                        .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                        .set(url.absoluteString, key: identifier)
                } catch let error {
                    // Error handling if needed...
                }
            }
            // TODO: Store in Keychain
             return token
        } else {
            print("Invalid token URL")
            return nil
        }
    }
    
    func renameToken(token: Token, to newName: String) -> Token {
        // TODO: Store Again in Keychain
        return Token(name: newName, issuer: token.issuer, generator: token.generator)
    }
    
    func removeToken(token: Token) -> Bool {
        // TODO: Delete from Keychain and return 'true'
        return false
    }
}
