//
//  GBAPIRequestFactory.swift
//  GBAPI
//
//  Created by David Fox on 10/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

/**
 A tuple describing how a request should be paginated. Takes an `offset` and a fetch `limit`
 */
public typealias PaginationDefinition = (offset: Int, limit: Int)

/**
 Struct defining how a request's results should be sorted. Note that this sorting is done on Giant Bomb's server side and not by the framework. `SortDefinition` just acts as a convenient and strongly typed way to add in the appropriate url parameters when making the request.
 */
public struct SortDefinition {
    
    /// The field upon which to sort by
    let field: String
    
    /// The direction in which to sort
    let direction: SortDirection
    
    /// An enum which declares in which direction results should be sorted by
    public enum SortDirection: String {
        
        /// Sort in ascending order
        case Ascending = "asc"
        
        /// Sort in descending order
        case Descending = "desc"
    }
    
    public init(field: String, direction: SortDirection) {
        self.field = field
        self.direction = direction
    }
    
    func urlParameter() -> String {
        return "\(field):\(direction.rawValue)"
    }
}

final class GBAPIRequestFactory {
    
    let configuration: GBAPIConfiguration
    let authenticationStore: GBAPIAuthenticationStore
    
    init(configuration: GBAPIConfiguration, authenticationStore: GBAPIAuthenticationStore) {
        
        self.configuration = configuration
        self.authenticationStore = authenticationStore
    }
    
    func addAuthentication(inout request: GBAPIRequest) {
        
        request.addURLParameter("api_key", value: authenticationStore.apiKey)
    }
    
    // MARK: Base requests
    func simpleRequest(path: String) -> GBAPIRequest {
        
        var request = GBAPIRequest(configuration: configuration, path: path, method: .GET)
        addAuthentication(&request)
        
        return request
    }
}
