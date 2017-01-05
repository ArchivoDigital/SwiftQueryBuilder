//
//  QueryBuilder.swift
//  Sample
//
//  Created by Hans Ospina on 1/5/17.
//  Copyright © 2017 Hans Ospina. All rights reserved.
//

import Foundation
import SwiftyJSON


class QueryBuilder {


    struct ConditionGroup {
        var andOr: AndOr = .OR
        var conditions = [Condition]()

        init(andOr: AndOr) {
            self.andOr = andOr
        }
    }

    struct Condition {
        var andOr: AndOr
        var field: String
        var op: Operator
        var val: String

        init(andOr: AndOr = .AND, field: String, op: Operator = .EQUALS, value: String) {
            self.andOr = andOr
            self.field = field
            self.op = op
            self.val = value
        }

    }

    enum AndOr: String {
        case AND = "AND"
        case OR = "OR"
    }

    enum Operator: String {
        case EQUALS = "="
        case LIKE = "LIKE"
        case LESS_THAN = "<"
        case MORE_THAN = ">"
    }

    enum ArDiAction {
        case INSERT
        case DELETE
        case FIND
        case UPDATE
    }

    struct Config {
        var action: ArDiAction
        var domain: Int
        var model: String
        var page: Int
        var size: Int
    }

    let config: Config

    private var groups: [ConditionGroup]?

    private var keys: [String]?

    private var objects: [[String: Any?]]?


    private func checkObjects() -> Bool {

        if let _ = keys {
            self.keys = nil
        }

        if let _ = groups {
            self.groups = nil
        }

        if objects == nil {
            self.objects = [[String:Any?]]()
        }


        // can only work with objects for INSERT and UPDATE
        return config.action == .INSERT || config.action == .UPDATE
    }

    private func checkKeys() -> Bool {

        if let _ = objects {
            objects = nil
        }

        if let _ = groups {
            groups = nil
        }

        if keys == nil {
            keys = [String]()
        }



        // can only use keys for find or delete
        return config.action == .FIND || config.action == .DELETE
    }


    private func checkGroups() -> Bool {

        if let _ = keys {
            keys = nil
        }

        if let _ = objects {
            objects = nil
        }

        if groups == nil {
            groups = [ConditionGroup]()
        }

        // QueryBuilder will break if the user tried to add a groups to a INSERT/UPDATE
        return config.action == .FIND || config.action == .DELETE
    }

    func addObject(obj: [String: Any?]) -> QueryBuilder? {

        if checkObjects() {
            objects!.append(obj)
            return self
        }

        return nil
    }

    func addCondition(obj: Condition) -> QueryBuilder? {

        if checkGroups() {

            if groups!.isEmpty {
                let _ = newGroup(andOr: .AND)
            }

            groups![groups!.count - 1].conditions.append(obj)
            return self
        }

        return nil
    }


    func newGroup(andOr: AndOr) -> QueryBuilder? {

        if checkGroups() {
            groups!.append(ConditionGroup(andOr: andOr))
            return self
        }

        return nil
    }

    func addKey(key: String) -> QueryBuilder? {

        if checkKeys() {
            keys!.append(key)
            return self
        }

        // QueryBuilder will break if the user tried to add a key to a INSERT/UPDATE
        return nil
    }

    init(action: ArDiAction, domain: Int, model: String, page: Int = 1, size: Int = 100) {
        self.config = Config(action: action, domain: domain, model: model, page: page, size: size)

    }

    func compile() -> (e: Error?, json: JSON?) {

        var json: JSON = ["domain": config.domain, "row_model": config.model, "page": config.page, "size": config.size]

        if let tmpGroups = groups {

            var groupList = [[String: Any?]]()

            for g in tmpGroups {

                var tmpConditions = [Any?]()

                for c in g.conditions {
                    let tmp: [String: Any?] = ["ANDOR": c.andOr.rawValue, "FIELD": c.field, "OP": c.op.rawValue, "VAL": c.val]
                    tmpConditions.append(tmp)
                }

                let tmpGroup: [String: Any?] = ["ANDOR": g.andOr.rawValue, "GROUP": tmpConditions]
                groupList.append(tmpGroup)
            }


            json["where"] = JSON(groupList)

        } else if let tmpKeys = keys {
            json["where"] = JSON(["keys": tmpKeys])
        } else if let tmpObjects = objects {
            json["rows"] = JSON(tmpObjects)
        }

        print(json.rawString()!)


        return (nil, json)
    }

}
