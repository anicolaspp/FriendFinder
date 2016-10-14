//
//  UserSeachViewController.swift
//  FriendsFinder
//
//  Created by Nicolas Perez on 10/13/16.
//  Copyright © 2016 Nicolas Perez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class UserSearchResult {
    
    let name: String
    let imageUrl: String?
    
    init(name: String, imageUrl: String?) {
        self.name = name
        self.imageUrl = imageUrl
    }
}

class UserSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    var resultSearch: [UserSearchResult] = []
    
    var history: [String : [UserSearchResult]] = [:]
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        history = [:]
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell")

        if indexPath.row < self.resultSearch.count {
            
            cell?.textLabel?.text = self.resultSearch[indexPath.row].name
            let data = try? Data(contentsOf: URL(string: self.resultSearch[indexPath.row].imageUrl!)!)
            
            cell?.imageView?.image = UIImage(data: data!)
            cell?.accessoryType = .detailButton
        }
        
        return cell!
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.resultSearch.count
    }
    
    var currentSearchTerm: String = ""
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            updateTable(with: [])
            return
        }
        
        if let result = history[searchText] {
            if result.count > 0 {
                updateTable(with: result)
                return
            }
        }
        
        currentSearchTerm = searchText
        
        FBSDKGraphRequest.init(graphPath: "/search",
                               parameters: ["q" : searchText, "type" : "user", "fields" : "id, name,  picture"],
                               httpMethod: "GET")
            .start(completionHandler: processResponse)
    }
    
    func updateTable(with data: [UserSearchResult]) -> Void {
        self.history[currentSearchTerm] = data
        self.resultSearch = data
        self.tableView.reloadData()
    }
    
    func processResponse(for connection: FBSDKGraphRequestConnection?, result: Any?, error: Error? ) -> Void {
        if let _ = error {
            print(error)
        }
        else {
            let dic = result as! NSDictionary
            let data = dic.object(forKey: "data") as! [NSDictionary]
            
            let newData = data.map({ (d) -> UserSearchResult in
                let name = d.object(forKey: "name") as! String
                let url  = ((d.object(forKey: "picture") as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "url") as? String
                
                return UserSearchResult.init(name: name, imageUrl: url)
            })
            
            updateTable(with: newData)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

