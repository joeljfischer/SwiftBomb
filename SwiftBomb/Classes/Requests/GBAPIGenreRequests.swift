//
//  GBAPIGenreRequests.swift
//  GBAPI
//
//  Created by David Fox on 25/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension GBAPI {
    
    public static func retrieveGenres(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, completion: (GBAPIPaginatedResults<GBGenreResource>?, error: GBAPIError?) -> Void) {
        
        let instance = GBAPI.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                assertionFailure("Must initialise the GBAPI with your configuration")
                return
        }
        
        let request = requestFactory.genreRequest(query, pagination: pagination, sort: sort)
        networkingManager.performPaginatedRequest(request, objectType: GBGenreResource.self, completion: completion)
    }
}

extension GBAPIRequestFactory {
    
    func genreRequest(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) -> GBAPIRequest {
        
        var request = GBAPIRequest(baseURL: configuration.baseURL, path: "api/genres", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        if let query = query {
            request.addURLParameter("filter", value: "name:\(query)")
        }
        
        return request
    }
}

extension GBGenreResource {
    
    public func fetchExtendedInfo(completion: (error: GBAPIError?) -> Void) {
        
        let api = GBAPI.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("api/genre/\(id)/") else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}
