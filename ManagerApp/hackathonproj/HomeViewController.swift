//
//  HomeViewController.swift
//  hackathonproj
//
//  Created by Mohammed Trama on 6/27/19.
//  Copyright © 2019 Mohammed Trama. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var EMPName: UILabel!
    @IBOutlet weak var Profile: UIImageView!
    @IBOutlet weak var Barcode: UIImageView!
    
    @IBOutlet weak var lastName: UILabel!
    var uuID = ""
    
    @IBAction func ReturnHome(_ sender: Any) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EMPName.text = "hello"
        // Do any additional setup after loading the view.
        EMPName.text = "button"
        
        print("from homevc")
        print(uuID)
        var firstName = ""
        var lastNameV = ""
    Alamofire.request("https://hackathonproj-155e2.firebaseio.com/users/\(uuID)/firstName.json", method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                
                if let data = response.result.value{
                    // Response type-1
                    print("running")
                    print(data)
                    
                    self.EMPName.text = data as! String
                } else {
                    print(response.error)
                    print("nope")
                }
        }
    Alamofire.request("https://hackathonproj-155e2.firebaseio.com/users/\(uuID)/lastName.json", method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                
                if let data = response.result.value{
                    // Response type-1
                    print("running")
                    print(data)
                    
                    self.lastName.text = data as! String
                }
        }
        
        Alamofire.request("https://hackathonproj-155e2.firebaseio.com/users/\(uuID)/photoUrl.json", method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                
                if let data = response.result.value{
                    // Response type-1
                    print("running")
                    print(data)
                    
                    self.Profile.downloaded(from: data as! String)
                }
        }
        
        Alamofire.request("https://hackathonproj-155e2.firebaseio.com/users/\(uuID)/barCodeUrl.json", method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                
                if let data = response.result.value{
                    // Response type-1
                    print("running")
                    print(data)
                    
                    self.Barcode.downloaded(from: data as! String)
                }
        }
    }
        
   /* Alamofire.request("https://hackathonproj-155e2.firebaseio.com/users/\(uuID)/lastName", method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                
                if let data = response.result.value{
                    // Response type-1
                    print("running")
                    print(data)
                    
                    
                }
        }*/
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
