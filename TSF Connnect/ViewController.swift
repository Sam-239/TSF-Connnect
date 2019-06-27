//
//  ViewController.swift
//  TSF Connnect
//
//  Created by Syamantak Dhavle on 22/06/19.
//  Copyright © 2019 Syamantak Dhavle. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit
import FBSDKCoreKit

class ViewController: UIViewController, LoginButtonDelegate {
    @IBOutlet weak var twitter: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var email: UILabel!
    var imageView : UIImageView!
    var label1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.center = CGPoint(x: view.center.x, y: 200)
        imageView.image = UIImage(named: "")
        view.addSubview(imageView)
        label1 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label1.center = CGPoint(x: view.center.x, y: 300)
        label1.text = ""
        label1.textAlignment = NSTextAlignment.center
        email.textAlignment = NSTextAlignment.center
        view.addSubview(label1)
    
        let loginButton = FBLoginButton()
        loginButton.center = CGPoint(x: view.center.x, y: 400)
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        fetchProfile()
    }

    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("loginButtonDidLogOut")
        label1.text = ""
        email.text = ""
        twitter.setImage(UIImage(named: "twitter_button.png"), for: .normal)
        imageView.image = UIImage(named: "")
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result:
        
        LoginManagerLoginResult?, error: Error?) {
        print("Logged in")
        twitter.setImage(nil, for: .normal)
        fetchProfile()
    }
    
    func fetchProfile() {
        if(AccessToken.current != nil)
        {
            
            print(AccessToken.current!)
            let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
            let connection = GraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                
                let data = result as! [String : AnyObject]
                
                self.label1.text = data["name"] as? String
                
                self.email.text = data["email"] as? String
                
                let FBid = data["id"] as? String
                
                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                self.imageView.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
            })
            connection.start()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}



