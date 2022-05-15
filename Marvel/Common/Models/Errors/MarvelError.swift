//
//  MarvelError.swift
//  Marvel
//
//  Created by mike on 14.05.2022.
//

import Foundation

enum MarvelError: Error {
	case failedRequestBuild
	
	case api(ApiError)
}
