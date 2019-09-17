//
//  ViewController.swift
//  hackathonproj
//
//  Created by Mohammed Trama on 6/27/19.
//  Copyright © 2019 Mohammed Trama. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var upsLogoImage: UIImageView!
    @IBOutlet weak var userIDtf: UITextField!
    @IBOutlet weak var passtf: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    var userUuid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! HomeViewController
        vc.uuID = self.userUuid
    }
    
    @IBAction func onClickLogIn(_ sender: Any) {
        var user : String? = userIDtf.text
        var pass : String? = passtf.text
        
        //        if user!.count >= 7 {
        //            errorLbl.text = "Invalid username"
        //        }
        //
        //        if pass!.count >= 5 {
        //            passErrorLbl.text = "Invalid password"
        //        }
        //
        if !(user!.count >= 0 && pass!.count >= 0){
            errorLbl?.text = "Invalid login credentials"
            errorLbl?.textColor = UIColor.red
        } else {
            print("printing user")
            print(user!)
            Alamofire.request("https://hackathonproj-155e2.firebaseio.com/users/\(user!)/id.json", method: .get, encoding: JSONEncoding.default)
                .responseJSON { response in
                    debugPrint(response)
                    
                    if let data = response.result.value{
                        // Response type-1
                        print("running")
                        print(data)
                        self.userUuid = data as! String
                        self.performSegue(withIdentifier: "loginSegue", sender: self)
                        
                    }
            }
        }
        
        
        // check length of user id
        // check length of pass
        // if both are long enough then contiue
        // otehrwise display error message
    }
    
}

