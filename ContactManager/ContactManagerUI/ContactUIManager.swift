//
//  ContactUIManager.swift
//  ContactManagerUI
//
//  Created by devxsby on 2023/02/06.
//

import Foundation

protocol ContactUIManagerProtocol {
    func runProgram(menu: Menu, data: UserInputModel?) throws -> Any?
}

final class ContactUIManager: ContactUIManagerProtocol {
    
    var validator: ValidatorProtocol
    private let dataManager = DataManager.shared
    
    init(validator: ValidatorProtocol) {
        self.validator = validator
    }
    
    @discardableResult
    func runProgram(menu: Menu, data: UserInputModel?) throws -> Any? {
        guard let data else { return nil }
        
        switch menu {
        case .add:
            try addProgram(data)
        case .showList:
            return showListProgram()
        default:
            throw Errors.readFail
        }
        return nil
    }
}

extension ContactUIManager {
    
    func addProgram(_ data:UserInputModel) throws {
        try self.validateData(with: data)
        guard let validatedData = data.convertToPerson() else { throw Errors.readFail }
        dataManager.setContact(validatedData)
    }
    
    func showListProgram() -> [Person]  {
        let persons = dataManager.getContactsData().map{$0}
        return persons
    }
    
    func formmatingPhoneNumber(with number: String?) -> String? {
        guard let number = number else { return nil }
        var phoneNumber = number.map { String($0) }
        
        if number.count == 9 {
            phoneNumber.insert("-", at: 2)
            phoneNumber.insert("-", at: 6)
            return phoneNumber.joined()
        } else if number.count >= 10 {
            phoneNumber.insert("-", at: 3)
            phoneNumber.insert("-", at: 7)
            return phoneNumber.joined()
        } else {
            return phoneNumber.joined()
        }
    }
    
    private func validateData(with:UserInputModel) throws {
        
    }
}
