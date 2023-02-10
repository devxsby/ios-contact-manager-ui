//
//  ContactListViewController.swift
//  ContactManagerUI
//
//  Created by DONGWOOK SEO on 2023/01/30.
//

import UIKit

final class ContactListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let contactUIManager = ContactUIManager(validator: Validator())
    private var searchResultTableController = SearchResultTableViewController()
    private var searchController: UISearchController!
    private var willSearchedContacts: [Person]?
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak private var contactListTableView: UITableView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setSearchController()
    }
    
    // MARK: - @IBAction Properties
    
    @IBAction func tappedAddContactButton(_ sender: UIBarButtonItem) {
        guard let addContactVC = UIStoryboard(name: "AddContact", bundle: nil).instantiateViewController(withIdentifier:"AddContactViewController") as? AddContactViewController else { return }
        addContactVC.contactUIManager = contactUIManager
        addContactVC.contactListTableView = contactListTableView
        self.present(addContactVC, animated: true)
    }
}

// MARK: - Methods

extension ContactListViewController {
    
    private func setDelegate() {
        contactListTableView.delegate = self
        contactListTableView.dataSource = self
    }
    
    private func setSearchController() {
        let searchController = UISearchController(searchResultsController: searchResultTableController)
        willSearchedContacts = contactUIManager.getContactsData()
        
        self.navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search User"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchResultsUpdater = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactUIManager.countContactLists()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(type: ContactTableViewCell.self, indexPath: indexPath)
        guard let cellDataInRow = contactUIManager.getContactsData()[safe: indexPath.row] else { return UITableViewCell() }
        cell.setData(with: cellDataInRow)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            let selectedItem = self.contactUIManager.getContactsData()[indexPath.row]
            
            self.contactUIManager.deleteContactData(of: selectedItem)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            self.contactUIManager.setStoredContactsData()
            success(true)
        }
        delete.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

//MARK: - UISearchResultUpdating

extension ContactListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let willSearchedContacts else { return }
        
        //        searchController.showsSearchResultsController = false
        
//        if let resultTableViewController = searchController.searchResultsController as? SearchResultTableViewController {
//            let whitespaceCharacterSet = CharacterSet.whitespaces
//            let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet).lowercased()
//            let searchItems = strippedString.components(separatedBy: " ") as [String]
//
//            var filterdContacts = willSearchedContacts
//            var curTerm = searchItems[0]
//            var index = 0
//            while curTerm != "" {
//                filterdContacts = filterdContacts.filter {_ in
//
//                    return true
//                }
//            }
//
//
//            if let resultTableViewController = searchController.searchResultsController as? SearchResultTableViewController {
//                resultTableViewController.contactUIManager = self.contactUIManager
//                resultTableViewController.filteredContacts = filterdContacts
//            }
//        }
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        print(searchBar.text)
        //        if searchBar.text!.isEmpty {
        //            searchResultTableController.showSuggestedSearches = false
        //        } else {
        //            searchResultTableController.showSuggestedSearches = true
        //        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true)
        searchBar.text = ""
    }
}