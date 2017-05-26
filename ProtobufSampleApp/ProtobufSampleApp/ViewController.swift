//
//  ViewController.swift
//  ProtobufSampleApp
//
//  Created by Michał Cichoń on 24/05/2017.
//  Copyright © 2017 Codete. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var acceptHeaderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let httpClient = HttpClient()
    
    
    var accountList: AccountList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getListButtonPressed(_ sender: Any) {
        if acceptHeaderSegmentedControl.selectedSegmentIndex == 0 {
            httpClient.getAccountList(acceptHeader: .json) {
                result, accountList, durationTimes in
                self.accountList = accountList
                guard let totalDuration = durationTimes?.totalDuration else {
                    self.durationLabel.text = ""
                    return
                }
                guard let requestDuration = durationTimes?.requestDuration else {
                    self.durationLabel.text = ""
                    return
                }
                self.durationLabel.text = String(format: "Request: %.4f Total: %.4f", requestDuration, totalDuration)
                self.tableView.reloadData()
            }
        } else {
            httpClient.getAccountList(acceptHeader: .protobuf) {
                result, accountList, durationTimes in
                self.accountList = accountList
                guard let totalDuration = durationTimes?.totalDuration else {
                    self.durationLabel.text = ""
                    return
                }
                guard let requestDuration = durationTimes?.requestDuration else {
                    self.durationLabel.text = ""
                    return
                }
                self.durationLabel.text = String(format: "Request: %.4f Total: %.4f", requestDuration, totalDuration)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.accountList?.accounts.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TableViewCell")
        guard let name = self.accountList?.accounts[indexPath.row].name else {
            return cell
        }
        cell.textLabel?.text = name
        return cell
    }
}
