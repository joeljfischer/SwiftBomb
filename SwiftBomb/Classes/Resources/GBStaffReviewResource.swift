//
//  GBStaffReviewResource.swift
//  GBAPI
//
//  Created by David Fox on 01/05/2016.
//  Copyright © 2016 David Fox. All rights reserved.
//

import Foundation

final public class GBStaffReviewResource: GBResource {
    
    /// The resource type
    public let resourceType = ResourceType.Review
    
    /// URL pointing to the review detail resource
    public let api_detail_url: NSURL?
    
    /// Brief summary of the review
    public let deck: String?
    
    /// Description of the review
    public let description: String?
    
    /// Name of the Downloadable Content package
    public let dlc_name: String?
    
    /// Game the review is for
    public let game: GBGameResource?
    
    /// Date the review was published on Giant Bomb
    public let publish_date: NSDate?
    
    /// Release of game for review
    public let release: GBGameResource?
    
    /// Name of the review's author
    public let reviewer: String?
    
    /// The score given to the game on a scale of 1 to 5
    public let score: Int?
    
    /// URL pointing to the review on Giant Bomb
    public let site_detail_url: NSURL?
    
    /// IDs don't exist for reviews in the Giant Bomb database! But to satisfy the GBResource protocol...
    public let id: Int? = 0
    
    /// Take the image from the game
    public var image: GBImageURLs? {
        get {
            return game?.image
        }
    }
    
    /// Extended info
    public var extendedInfo: GBUnusedExtendedInfo?
    
    public init(json: [String: AnyObject]) {
        
        api_detail_url = (json["api_detail_url"] as? String)?.url()
        deck = json["deck"] as? String
        description = json["description"] as? String
        dlc_name = json["dlc_name"] as? String
        
        if let gameJSON = json["game"] as? [String: AnyObject] {
            game = GBGameResource(json: gameJSON)
        } else {
            game = nil
        }
        
        publish_date = (json["publish_date"] as? String)?.dateRepresentation()
        
        if let releaseJSON = json["release"] as? [String: AnyObject] {
            release = GBGameResource(json: releaseJSON)
        } else {
            release = nil
        }
        
        reviewer = json["reviewer"] as? String
        score = json["score"] as? Int
        site_detail_url = (json["site_detail_url"] as? String)?.url()
    }
    
    public var prettyDescription: String {
        if let game = game, let gameName = game.name {
            return "\(gameName) Review"
        }
        
        return "Review"
    }
}