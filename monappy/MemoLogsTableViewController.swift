//
//  MemoLogsTableViewController.swift
//  monappy
//
//  Created by Yusuke Ohashi on 2017/07/13.
//  Copyright © 2017 Yusuke Ohashi. All rights reserved.
//

import UIKit
import SafariServices

class MemoLogsTableViewController: UITableViewController {

    var memoLogs: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "https://api.monappy.jp/v1/memo_logs") {
            let client = Client(with: url)
            client.send({ [weak self] (json, error) in
                if let weakSelf = self {
                    weakSelf.memoLogs = json as? [String: Any]
                    DispatchQueue.main.async {
                        weakSelf.tableView.reloadData()
                    }
                }
            })
        }
        
        title = "メモログ"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let p = memoLogs, let data = p["data"] as? [[String: Any]] {
            return data.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoLogsCell", for: indexPath)

        // Configure the cell...
        if let p = memoLogs, let data = p["data"] as? [[String: Any]] {
            cell.textLabel?.text = data[indexPath.row]["name"] as? String
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let p = memoLogs, let data = p["data"] as? [[String: Any]],
            let urlString = data[indexPath.row]["url"] as? String,
            let url = URL(string: urlString) {
            let safari: SFSafariViewController = SFSafariViewController(url: url)
            present(safari, animated: true, completion: nil)
        }

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
