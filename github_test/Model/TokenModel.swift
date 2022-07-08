//
//  TokenModel.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import Foundation

struct TokenModel: Codable {
    let access_token: String?
    let scope: String?
    let token_type: String?
}
