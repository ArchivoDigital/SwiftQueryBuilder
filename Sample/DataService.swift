//
//  DataService.swift
//  Sample
//
//  Created by Hans Ospina on 1/4/17.
//  Copyright © 2016 Hans Ospina. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class DataService {

    static let sharedInstance: DataService = {
        let instance = DataService()
        return instance
    }()

    let token = ""
    let baseUrl = "https://archivo.digital"
    let defaults = UserDefaults.standard

    let displayNameKey = "DISPLAYNAME"
    let loggedKey = "LOGGED"

    let APP_KEY = "bcd864-abb4fb-48bab1-34fbca-ca76a3"

    var currentUser = User()


    func doLogIn(_ email: String, password: String, cb: @escaping ((NSError?, User?) -> ())) {
        let headers = [
                "App-Key": APP_KEY
        ]

        let params = [
                "login": email,
                "password": password
        ]

        let URLstring = URL(string: "\(baseUrl)/api/user/v1/login")

        Alamofire.request(URLstring!, method: .get, parameters: params, headers: headers).validate().responseJSON { response in

                    switch response.result {

                    case .success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            if !json["success"].boolValue {
                                NSLog("\(json["error"].stringValue)")

                                cb(NSError(
                                        domain: "root",
                                        code: -99,
                                        userInfo: [NSLocalizedDescriptionKey: "Problemas al autenticar el usuario."]
                                ), nil)
                            } else {
                                self.currentUser = User.fromJson(json)
                                self.defaults.set(true, forKey: self.loggedKey)
                                cb(nil, self.currentUser)
                            }

                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        cb(error as NSError!, nil)
                    }
                }
    }


}
