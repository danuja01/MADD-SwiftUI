//
//  String.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-10.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
}
