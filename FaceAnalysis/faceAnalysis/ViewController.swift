//
//  ViewController.swift
//  faceAnalysis
//
//  Created by Olalekan Adeyeri on 6/26/19.
//  Copyright © 2019 Olalekan Adeyeri. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var myImg: UIImageView!
    var base64String = ""
    
    @IBOutlet weak var uuidLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
            
            // Handle your response
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        myImg.contentMode = .scaleToFill
        myImg.image = pickedImage
        picker.dismiss(animated: true, completion: nil)
        
        print("hello this is the image")

        base64String = (convertImageToBase64String(image: pickedImage.resized(withPercentage: 0.1)!))
    }
    
    @IBAction func goButton(_ sender: Any) {
        let urlString = "https://qpc4vwweo9.execute-api.us-east-1.amazonaws.com/testStage/"
        
        Alamofire.request(urlString, method: .post, parameters: ["imageBase64": base64String,"employeeUUID":uuidLabel.text],encoding: JSONEncoding.default, headers: nil).responseString {
            response in
            switch response.result {
            case .success:
                print("success")
                print(response)
                break
            case .failure(let error):
                print("error")
                print(error)
            }
        }
    }
    
    
    func  convertImageToBase64String(image : UIImage ) -> String
    {
        let strBase64 =  image.pngData()?.base64EncodedString()
        return strBase64!
    }
    
    func putToRest() {
        
        let urlString = "https://hackathonproj-155e2.firebaseio.com/users/dswwds221.json"
        
        Alamofire.request(urlString, method: .put, parameters: ["tsedsdsd":"www"],encoding: JSONEncoding.default, headers: nil).responseString {
            response in
            switch response.result {
            case .success:
                print("success")
                print(response)
                break
            case .failure(let error):
                print("error")
                print(error)
            }
        }
        
    }
    
   /* //This should have the post address as def
    func postToLambda(_for imageUrlString:String) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let postUrl = URL(string: "https://qpc4vwweo9.execute-api.us-east-1.amazonaws.com/testStage/")
        //let json: [String: Any] = ["title": "ABC","dict": ["1":"First", "2":"Second"]]
        let json: [String: String] = ["imageUrl": imageUrlString]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
        var request : URLRequest = URLRequest(url: postUrl!)
        
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let dataTask = session.dataTask(with: postUrl!) {
            data,response,error in
            // 1: Check HTTP Response for successful GET request
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("error: not a valid http response")
                    return
            }
            switch (httpResponse.statusCode) {
            case 200:
                //success response.
                print("200")
                break
            case 400:
                print("400")
                break
            default:
                print("default")
                let dataString = String(data: receivedData, encoding: String.Encoding.utf8)
                print(dataString!)
                break
            }
        }
        dataTask.resume()
    }
    
    func makePostCall(_for imageUrlString:String) {
        let todosEndpoint: String = "https://i.ytimg.com/vi/jmK9X9qUFeA/maxresdefault.jpg"
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        let newTodo: [String: Any] = ["imageUrl": imageUrlString]
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosUrlRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print("The todo is: " + receivedTodo.description)
                
                guard let todoID = receivedTodo["id"] as? Int else {
                    print("Could not get todoID as int from JSON")
                    return
                }
                print("The ID is: \(todoID)")
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
    }
*/

}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}


