//
//  DataManager.swift
//  ContactManager
//
//  Created by devxsby on 2023/01/30.
//

import Foundation

final class DataManager {
    
    static let shared = DataManager()
    
    private var contacts: Set<Person> = Set<Person>()
    
    private var dataStore = UserDefaults.standard
    
    private init() {
        getStoredContactsData()
    }
    
    func getStoredContactsData(){
        if dataStore.object(forKey: UserDefaultKey.contacts.rawValue) != nil {
            if let data = dataStore.value(forKey: UserDefaultKey.contacts.rawValue) as? Data {
                guard let decodedData = try? PropertyListDecoder().decode([Person].self, from: data) else { return }
                self.contacts = Set(decodedData)
            }
        }
    }
    
    func setStoredContactsData() {
        let data = getcontactsDataAsPerson()
        let encodedData = try? PropertyListEncoder().encode(data)
        dataStore.set(encodedData, forKey: UserDefaultKey.contacts.rawValue)
    }
    
    func setContact(_ person: Person) {
        contacts.insert(person)
    }
    
    func getContactsData() -> Set<Person> {
        return contacts
    }
    
    func getcontactsDataAsPerson() -> [Person] {
        let datas = contacts.map { $0 }
        let sortedDatas = datas.sorted()
        return sortedDatas
    }
    
    func getContactsList() -> [String] {
        let contacts = contacts.map { "- \($0.name) / \($0.age) / \($0.phoneNum)" }
        return contacts
    }
    
    func countContactLists() -> Int {
        return contacts.count
    }
    
    func deleteContact(of data: Person) {
        contacts.remove(data)
    }
    
    func clearAllStoredDataForTest() {
        dataStore.removeObject(forKey: UserDefaultKey.contacts.rawValue)
        contacts.removeAll()
    }
}
