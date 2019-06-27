//
//  detailsViewController.swift
//  TSF Connnect
//
//  Created by Syamantak Dhavle on 24/06/19.
//  Copyright © 2019 Syamantak Dhavle. All rights reserved.
//

import UIKit
import TwitterKit

class detailsViewController: UIViewController {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var profilepic: UIImageView!
    @IBAction func mainmenu(_ sender: Any) {
    }
    var loginButton : TWTRLogInButton!
    
    @IBAction func logout(_ sender: Any) {
        let store = TWTRTwitter.sharedInstance().sessionStore
        if let userID = store.session()?.userID {
            print(store.session()?.userID ?? "")
            store.logOutUserID(userID)
            print(store.session()?.userID ?? "")
            self.userName.text = ""
            self.email.text = ""
        self.profilepic.image = nil
        }
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
            loginButton = TWTRLogInButton { (session, error) in
            if let session = session {
                let client = TWTRAPIClient()
                client.loadUser(withID: session.userID, completion: { (user, error) in
                    let client = TWTRAPIClient.withCurrentUser()
                    let name = session.userName
                    self.userName.text = name
                    print(user?.profileImageURL ?? "")
                    
                    let Url = (user?.profileImageLargeURL)
                    let url = URL(string: Url!)!
                    let data = try?Data(contentsOf: url)
                    if let imageData = data {
                    let image = UIImage(data: imageData)
                    self.profilepic.image = image
                    }
                    
                    client.requestEmail { email, error in
                        if (email != nil) {
                            let recivedEmailID = email ?? ""
                            self.email.text = recivedEmailID
                        }else {
                            print("error--: \(String(describing: error?.localizedDescription))");
                        }
                    }
                    })
            }else{
                print("Login Error")
            }
        }
        loginButton.center = view.center
        view.addSubview(loginButton)
        
        
        
        }
    }


