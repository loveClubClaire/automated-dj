//
//  ApplescriptBridge.m
//  Now Playing in iTunes
//
//  Created by Zachary Whitten on 4/11/16.
//  Copyright © 2016 WCNURadio. All rights reserved.
//

#import "ApplescriptBridge.h"
#import "Automated_DJ-Swift.h"


@implementation ApplescriptBridge

@class Playlist;


-(id)init{
    Class myClass = NSClassFromString(@"MyApplescript");
    _myInstance = [[myClass alloc] init];
    return self;
}

-(void) iTunesPause{
    [_myInstance iTunesPause];
}

-(NSMutableArray*) getPlaylists{
    NSArray *rawPlaylists = [_myInstance getPlaylists];
    NSMutableArray *Playlists = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [rawPlaylists count]; i++) {
        NSAppleEventDescriptor *aPlaylist = [rawPlaylists objectAtIndex:i];
        Playlist *tempPlaylist = [[Playlist alloc] initWithString:aPlaylist.debugDescription];
        [Playlists addObject:tempPlaylist];
    }
    
    return Playlists;

}

-(NSMutableArray*) getSongsInPlaylist:(NSString*)aPlaylist{

    NSArray *rawSongs = [_myInstance getSongsInPlaylist:aPlaylist];
    NSMutableArray *songs = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [rawSongs count]; i++) {
        NSAppleEventDescriptor *aSong = [rawSongs objectAtIndex:i];
        Song *tempSong = [[Song alloc] initWithString:aSong.debugDescription];
        [songs addObject:tempSong];
    }
    
    return songs;
}

-(void) createPlaylistWithName:(NSString*)aName{
    [_myInstance createPlaylistWithName:aName];
}

-(NSString*) getCurrentPlaylist{
    return [_myInstance getCurrentPlaylist];
}

-(void) deletePlaylistWithName:(NSString*)aName{
    [_myInstance deletePlaylistWithName:aName];
}

- (void) disableShuffle{
    [_myInstance disableShuffle];
}

- (void) disableRepeat{
    [_myInstance disableRepeat];
}

@end
