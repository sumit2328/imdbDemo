//
//  SearchValidator.swift
//  IMDB Demo
//
//  Created by Sumit on 04/07/24.
//


class SearchValidator {
    
    static func isValidSearchText(_ text: String?) -> Bool {
        guard let text = text, !text.isEmpty else {
            return false
        }
        return true
    }
}
