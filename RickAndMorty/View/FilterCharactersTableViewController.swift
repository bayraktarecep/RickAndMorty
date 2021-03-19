//
//  FilterCharactersTableViewController.swift
//  RickAndMorty
//
//  Created by Recep Bayraktar on 19.03.2021.
//

import UIKit

class FilterCharactersTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    
    var charactersFilterDelegate: CharactersFilterDelegate? = nil
    
    var statusValue: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 3
        }
        else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK: - Filter for Status Selection
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.statusValue = "alive"
            }
            else if indexPath.row == 1 {
                self.statusValue = "dead"
            }
            else if indexPath.row == 2 {
                self.statusValue = "unknown"
            }
        }
    }
    
    @IBAction func filterResults(_ sender: Any) {
        
        if let handledDelegate = self.charactersFilterDelegate {
            //MARK: - Get data from the Name text field for the name filter
            let urlString = self.nameTextField.text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            //MARK: - Get data from the second section of status and create new url for the filter
            handledDelegate.filterCharactersBy(nameValue: urlString, statusValue: self.statusValue)
        }
    }
    //TODO: Clear button doesnt work. Check
    @IBAction func clearFilters(_ sender: Any) {
        if let handledDelegate = self.charactersFilterDelegate {
            handledDelegate.clearFilter()
        }
    }
}
