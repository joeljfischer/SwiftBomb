//
//  GBCompanyResource.swift
//  GBAPI
//
//  Created by David Fox on 16/04/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

final public class GBCompanyResource: GBResourceUpdating {
    
    /// The resource type
    public let resourceType = ResourceType.Company
    
    /// Abbreviation of the company
    public private(set) var abbreviation: String?
    
    /// Array of aliases the company is known by
    public private(set) var aliases: [String]?
    
    /// URL pointing to the company detail resource
    public private(set) var api_detail_url: NSURL?
    
    /// Date the company was added to Giant Bomb
    public private(set) var date_added: NSDate?
    
    /// Date the company was founded
    public private(set) var date_founded: NSDate?
    
    /// Date the company was last updated on Giant Bomb
    public private(set) var date_last_updated: NSDate?
    
    /// Brief summary of the company
    public private(set) var deck: String?
    
    /// Description of the company
    public private(set) var description: String?
    
    /// Unique ID of the company
    public let id: Int?
    
    /// Main image of the company
    public private(set) var image: GBImageURLs?
    
    /// Street address of the company
    public private(set) var location_address: String?
    
    /// City the company resides in
    public private(set) var location_city: String?
    
    /// Country the company resides in
    public private(set) var location_country: String?
    
    /// State the company resides in
    public private(set) var location_state: String?
    
    /// Name of the company
    public private(set) var name: String?
    
    /// Phone number of the company
    public private(set) var phone: String?
    
    /// URL pointing to the company on Giant Bomb
    public private(set) var site_detail_url: NSURL?
    
    /// URL to the company website
    public private(set) var website: NSURL?
    
    /// Extended info
    public var extendedInfo: GBCompanyExtendedInfo?

    public init(json: [String: AnyObject]) {
        
        id = json["id"] as? Int

        update(json)
    }
    
    func update(json: [String : AnyObject]) {
        
        if let aliasesString = json["aliases"] as? String {
            aliases = aliasesString.componentsSeparatedByString("\n")
        } else {
            aliases = [String]()
        }
        
        abbreviation = json["abbreviation"] as? String
        api_detail_url = (json["api_detail_url"] as? String)?.url()
        date_added = (json["date_added"] as? String)?.dateRepresentation()
        date_founded = (json["date_founded"] as? String)?.dateRepresentation()
        date_last_updated = (json["date_last_updated"] as? String)?.dateRepresentation()
        deck = json["deck"] as? String
        description = json["description"] as? String
        location_address = json["location_address"] as? String
        location_city = json["location_city"] as? String
        location_state = json["location_state"] as? String
        location_country = json["location_country"] as? String
        name = json["name"] as? String
        phone = json["phone"] as? String
        site_detail_url = (json["site_detail_url"] as? String)?.url()
        website = (json["website"] as? String)?.url()
        
        if let imageJSON = json["image"] as? [String: AnyObject] {
            image = GBImageURLs(json: imageJSON)
        } else {
            image = nil
        }
    }
    
    public var prettyDescription: String {
        return name ?? "Company \(id)"
    }
}

public struct GBCompanyExtendedInfo: GBResourceExtendedInfo {
    
    /// Characters related to the company
    public let characters: [GBCharacterResource]
    
    /// Concepts related to the company
    public let concepts: [GBConceptResource]
    
    /// Games the company has developed
    public let developed_games: [GBGameResource]
    
    /// Releases the company has developed
    public let developer_releases: [GBGameReleaseResource]
    
    /// Releases the company has distributed
    public let distributor_releases: [GBGameReleaseResource]
    
    /// Locations related to the company
    public let locations: [GBLocationResource]
    
    /// Objects related to the company
    public let objects: [GBObjectResource]
    
    /// People who have worked with the company
    public let people: [GBPersonResource]
    
    /// Games published by the company
    public let published_games: [GBGameResource]
    
    /// Releases the company has published
    public let publisher_releases: [GBGameReleaseResource]
    
    public init(json: [String : AnyObject]) {
        
        characters = json.jsonMappedResources("characters")
        concepts = json.jsonMappedResources("concepts")
        developed_games = json.jsonMappedResources("developed_games")
        developer_releases = json.jsonMappedResources("developer_releases")
        distributor_releases = json.jsonMappedResources("distributor_releases")
        locations = json.jsonMappedResources("locations")
        objects = json.jsonMappedResources("objects")
        people = json.jsonMappedResources("people")
        published_games = json.jsonMappedResources("published_games")
        publisher_releases = json.jsonMappedResources("publisher_releases")
    }
}