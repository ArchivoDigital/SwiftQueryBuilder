//
//  Domain.swift
//  Sample
//
//  Created by Hans Ospina on 1/5/17.
//  Copyright © 2017 Hans Ospina. All rights reserved.
//

import Foundation
import SwiftyJSON

class Domain {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var displayName = ""
    dynamic var home = ""

    static func domainFromJson(_ json: JSON) -> Domain {
        let domain = Domain()
        domain.id = json["domain_id"].intValue
        domain.name = json["name"].stringValue
        domain.displayName = json["display_name"].stringValue
        if let _ = json["home"].null {
            domain.home = ""
        } else {
            domain.home = json["home"].stringValue
        }

        return domain
    }


}
