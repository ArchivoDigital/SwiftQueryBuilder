//
//  User.swift
//  Sample
//
//  Created by Hans Ospina on 1/5/17.
//  Copyright © 2017 Hans Ospina. All rights reserved.
//

import Foundation
import SwiftyJSON


class User {
    dynamic var key = ""
    dynamic var token = ""
    dynamic var name = ""
    dynamic var id = 0
    dynamic var ventas = ""
    dynamic var code = ""
    dynamic var email = ""
    dynamic var login = ""
    dynamic var display_name = ""
    dynamic var role = ""
    dynamic var domain = ""
    dynamic var domain_id = 0
    dynamic var membershipRole = ""
    var memberOf = [Domain]()

    static func fromJson(_ json: JSON) -> User {

        let user = User()
        user.key = json["_KEY"].stringValue
        user.token = json["token"].stringValue
        user.id = json["user"]["id"].intValue
        user.name = json["user"]["name"].stringValue
        user.code = json["user"]["code"].stringValue
        user.email = json["user"]["email"].stringValue
        user.login = json["user"]["login"].stringValue
        user.role = json["user"]["role"].stringValue
        user.domain = json["user"]["domain"].stringValue
        user.display_name = json["user"]["display_name"].stringValue
        user.domain_id = json["user"]["domain_id"].intValue
        user.membershipRole = json["user"]["membership_role"].stringValue



        for (_, subJson): (String, JSON) in json["user"]["member_of"] {
            let domain = Domain.domainFromJson(subJson)
            user.memberOf.append(domain)
        }
        return user
    }
}
