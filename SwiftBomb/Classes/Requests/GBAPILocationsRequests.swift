//
//  GBAPILocationsRequests.swift
//  GBAPI
//
//  Created by David Fox on 25/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

extension GBAPI {
    
    public static func retrieveLocations(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil, completion: (GBAPIPaginatedResults<GBLocationResource>?, error: GBAPIError?) -> Void) {
        
        let instance = GBAPI.framework
        guard
            let requestFactory = instance.requestFactory,
            let networkingManager = instance.networkingManager else {
                assertionFailure("Must initialise the GBAPI with your configuration")
                return
        }
        
        let request = requestFactory.locationRequest(query, pagination: pagination, sort: sort)
        networkingManager.performPaginatedRequest(request, objectType: GBLocationResource.self, completion: completion)
    }
}

extension GBAPIRequestFactory {
    
    func locationRequest(query: String? = nil, pagination: PaginationDefinition? = nil, sort: SortDefinition? = nil) -> GBAPIRequest {
        
        var request = GBAPIRequest(baseURL: configuration.baseURL, path: "api/locations", method: .GET, pagination: pagination, sort: sort)
        addAuthentication(&request)
        if let query = query {
            request.addURLParameter("filter", value: "name:\(query)")
        }
        
        return request
    }
}

extension GBLocationResource {
    
    public func fetchExtendedInfo(completion: (error: GBAPIError?) -> Void) {
        
        let api = GBAPI.framework
        
        guard
            let networkingManager = api.networkingManager,
            let id = id,
            let request = api.requestFactory?.simpleRequest("api/location/\(id)/") else {
                completion(error: .FrameworkConfigError)
                return
        }
        
        networkingManager.performDetailRequest(request, resource: self, completion: completion)
    }
}
