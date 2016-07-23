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

-(void) iTunesStop{
    [_myInstance iTunesStop];
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

-(Playlist*) getPlaylist:(NSString*)aPlaylist{
    NSAppleEventDescriptor *rawPlaylist = [_myInstance getPlaylist:aPlaylist];
    return [[Playlist alloc] initWithString:rawPlaylist.debugDescription];
}

-(NSMutableArray*) getSongsInPlaylist:(NSString*)aPlaylist{
    NSArray *rawSongs = [_myInstance getSongsInPlaylist:aPlaylist];

    NSMutableArray *songs = [[NSMutableArray alloc]init];
    for (int i = 0; i < [rawSongs count]; i++) {
        NSAppleEventDescriptor *aSong = [rawSongs objectAtIndex:i];
        [songs addObject:[[Song alloc] initWithString:aSong.debugDescription]];
    }
    return songs;
}

-(NSNumber*) getNumberOfSongsInPlaylist:(NSString*)aPlaylist{
    NSNumber *aNumber = [_myInstance getNumberOfSongsInPlaylist:aPlaylist];
    return aNumber;
}

-(Song*) getLastSongInPlaylist:(NSString*)aPlaylist{
    NSAppleEventDescriptor *rawSong = [_myInstance getLastSongInPlaylist:aPlaylist];
    return [[Song alloc] initWithString:rawSong.debugDescription];
}

-(void) removeLastSongInPlaylist:(NSString*)aPlaylist{
    [_myInstance removeLastSongInPlaylist:aPlaylist];
}

-(void) createPlaylistWithName:(NSString*)aName{
    [_myInstance createPlaylistWithName:aName];
}

-(void) deletePlaylistWithName:(NSString*)aName{
    [_myInstance deletePlaylistWithName:aName];
}

-(NSString*) getCurrentPlaylist{
    return [_myInstance getCurrentPlaylist];
}

-(void) disableShuffle{
    [_myInstance disableShuffle];
}

-(void) disableRepeat{
    [_myInstance disableRepeat];
}

-(double) timeLeftInCurrentSong{
    return [_myInstance timeLeftInCurrentSong].doubleValue;
}

-(void) playPlaylist:(NSString*)aPlaylist{
    //When a playlist does not exist, this function does nothing rather then throw an error. (Part of the reason for this is that the applescript error which would be thrown isn't intutive)
    [_myInstance playPlaylist:aPlaylist];
}

-(BOOL) isiTunesPlaying{
    BOOL result = false;
    NSString* state = [_myInstance getiTunesPlayerState].stringValue;
    if ([state isEqualToString:@"kPSP"]) {
        result = true;
    }
    return result;
}

-(void) playSongFromPlaylist:(NSNumber*)aTrack playlist:(NSString*)aPlaylist{
    [_myInstance playSongFromPlaylist:aTrack playlist:aPlaylist];
}

-(void) addSongsToPlaylist:(NSString*)aPlaylist songs:(NSArray*)songArray{
    for (int i = 0; i < songArray.count; i++) {
        [_myInstance addSongToPlaylist:aPlaylist songID:((Song*)[songArray objectAtIndex:i]).persistentID];
    }
}

@end

