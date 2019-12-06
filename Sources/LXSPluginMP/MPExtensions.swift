//
//  MPExtensions.swift
//  LXSCommons
//
//  Created by Alex Rote on 11/15/15.
//  Copyright © 2015 Alex Rote. All rights reserved.
//

#if os(iOS)

import MediaPlayer

// Extensions relating to MediaPlayer classes
// MPMediaItem
// MPMediaPlaylist

public extension MPMediaItem {
    
    var propertyTitle: String? {
        return value(forProperty: MPMediaItemPropertyTitle) as? String
    }
    
    var propertyArtwork: MPMediaItemArtwork? {
        return value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
    }
    
    var propertyArtist: String? {
        return value(forProperty: MPMediaItemPropertyArtist) as? String
    }
    
    var propertyAlbumTitle: String? {
        return value(forProperty: MPMediaItemPropertyAlbumTitle) as? String
    }
}

public extension MPMediaItemCollection {
    
    var propertyArtwork: MPMediaItemArtwork? {
        return representativeItem?.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
    }
    
    var propertyArtist: String? {
        return representativeItem?.value(forProperty: MPMediaItemPropertyArtist) as? String
    }
    
    var propertyAlbumTitle: String? {
        return representativeItem?.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String
    }
}

public extension MPMediaPlaylist {
    
    var propertyName: String? {
        return value(forProperty: MPMediaPlaylistPropertyName) as? String
    }
}

#endif
