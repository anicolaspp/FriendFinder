//
//  UserProfileViewController.swift
//  FriendsFinder
//
//  Created by Nicolas Perez on 10/12/16.
//  Copyright © 2016 Nicolas Perez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit




class UserProfileViewController: UIViewController {
  
    var token: FBSDKAccessToken!
    
//    var resultSearch: [UserSearchResult] = []
//    
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
//    @IBOutlet weak var peopleSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        FBSDKProfile.loadCurrentProfile { (p, error) in
            if let e = error {
                print(e)
            }
            else {
                print(p)
                
                FBSDKGraphRequest.init(graphPath: p?.userID, parameters: ["fields": "picture"]).start(completionHandler: { (connection, result, error) in
                    let dic = result as! NSDictionary
                    let pic = (dic.object(forKey: "picture") as! NSDictionary).object(forKey: "data") as! NSDictionary
                    let url = pic.object(forKey: "url") as! String
                    let data = try? Data(contentsOf: URL(string: url)!)
                
                    self.userPicture.image = UIImage(data: data!)
                    self.userPicture.contentMode = .scaleAspectFit
                })
                
                self.userName.text = p?.firstName
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logout(_ sender: AnyObject) {
        
        FBSDKLoginManager().logOut()
        
        let navigationController = self.navigationController
        
        navigationController?.dismiss(animated: true, completion: nil)
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
//
//extension UserProfileViewController : UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//        
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
//        }
//        
//        if indexPath.row < self.resultSearch.count {
//        
//            cell?.textLabel?.text = self.resultSearch[indexPath.row].name
//            let data = try? Data(contentsOf: URL(string: self.resultSearch[indexPath.row].imageUrl!)!)
//        
//            cell?.imageView?.image = UIImage(data: data!)
//            cell?.accessoryType = .detailButton
//        }
//        
//        return cell!
//    }
//
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return self.resultSearch.count
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        FBSDKGraphRequest.init(graphPath: "/search",
//                               parameters: ["q" : self.peopleSearchBar.text!, "type" : "user", "fields" : "id, name,  picture"],
//                               httpMethod: "GET")
//            .start(completionHandler: processResponse)
//    }
//    
//    func processResponse(for connection: FBSDKGraphRequestConnection?, result: Any?, error: Error? ) -> Void {
//        if let _ = error {
//            print(error)
//        }
//        else {
//            let dic = result as! NSDictionary
//            
//            let data = dic.object(forKey: "data") as! [NSDictionary]
//            
//            self.resultSearch = [UserSearchResult]()
//            self.resultSearch = data.map({ (d) -> UserSearchResult in
//                let name = d.object(forKey: "name") as! String
//                let url  = ((d.object(forKey: "picture") as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "url") as? String
//                
//                return UserSearchResult.init(name: name, imageUrl: url)
//            })
//        }
//    }
//}
//
//
//
