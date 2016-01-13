//
//  CitySearchController.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 29/11/2015.
//
//

import UIKit
import LMGeocoder

class CitySearchController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var closeButton: CircularButton!
    
    var addresses = [City]()
    var cities = DataManager().getCitiesList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        closeButton.rotate()
        
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: UITextFieldDelegate
extension CitySearchController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        LMGeocoder.sharedInstance().geocodeAddressString(textField.text, service: .GoogleService) { (results, error) -> Void in
            self.addresses.removeAll()
            if let res = results {
                for address in res as! [LMAddress] {
                    self.addresses.append(City(name: address.formattedAddress, coordinate: address.coordinate))
                }
            }
            self.tableView.reloadData()
        }
        return true
    }
}


// MARK: UITableViewDataSource
extension CitySearchController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Saved Cities" : "Searched Cities"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? cities.count : addresses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.textLabel?.text = (indexPath.section == 0) ? cities[indexPath.row].name : addresses[indexPath.row].name
        return cell
    }
}

// MARK: UITableViewDelegate
extension CitySearchController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            tableView.beginUpdates()
            
            cities = DataManager().addNewCity(addresses[indexPath.row])
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: cities.count - 1, inSection: 0)], withRowAnimation: .Automatic)
            
            addresses.removeAll()
            tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
            
            textField.text = ""
            
            tableView.endUpdates()
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return (indexPath.section == 0)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            tableView.beginUpdates()
            
            cities = DataManager().removeCity(cities[indexPath.row])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            tableView.endUpdates()
        }
    }
}
