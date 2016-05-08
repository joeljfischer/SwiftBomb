//
//  CharacterRequests.swift
//  SwiftBomb
//
//  Created by David Fox on 16/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension SwiftBomb {
    
    /**
     Fetches a paginated list of `CharacterResource` instances. This list can be filtered to a search term, paginated and sorted.
     
     - parameter query: An optional search term used to filter for a particular character.
     - parameter pagination: An optional `PaginationDefinition` to define the limit and offset when paginating results.
     - parameter sort: An optional `SortDefinition` to define how the results should be sorted.
     - parameter completion: A closure returning an optional generic `PaginatedResults` object containing the returned `CharacterResource` objects and pagination information and also, an optional `RequestError` object if the request failed.
     */
    public static func fetchCharacters(name: String? = nil, pagination: PaginationDefinition?, sort: SortDefinition?, completion: (PaginatedResults<CharacterResource>?, error: RequestError?) -> Void) {
        
        let instance = SwiftBomb.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                completion(nil, error: .FrameworkConfigError)
                return
        }
        
        let request = requestFactory.charactersRequest(name, pagination: pagination, sort: sort)
        networkingManager.performPaginatedRequest(request, objectType: CharacterResource.self, completion: completion)
    }
}

extension RequestFactory {
    
    func charactersRequest(name: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) -> Request {
        
        var request = Request(configuration: configuration, path: "characters", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        
        if let name = name {
            request.addURLParameter("filter", value: "name:\(name)")
        }

        return request
    }
}

extension CharacterResource {
    
    /**
     Fetches extended info for this character. Also re-populates base data in the case where this object is a stub from another parent resource.
     
     - parameter completion: A closure containing an optional `RequestError` if the request failed.
     */
    public func fetchExtendedInfo(completion: (error: RequestError?) -> Void) {
        
        let api = SwiftBomb.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("character/\(id)/") else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}
