//
//  ApplescriptBridge.h
//  Now Playing in iTunes
//
//  Created by Zachary Whitten on 4/11/16.
//  Copyright © 2016 WCNURadio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyApplescript.h"



@interface ApplescriptBridge : NSObject

@property id<ApplescriptProtocol> myInstance;

- (void) iTunesPause;

- (void) iTunesStop;

- (NSMutableArray*) getPlaylists;

- ()                getPlaylist:(NSString*)aPlaylist;

- (NSMutableArray*) getSongsInPlaylist:(NSString*)aPlaylist;

- (NSNumber*)       getNumberOfSongsInPlaylist:(NSString*)aPlaylist;

- (void)            createPlaylistWithName:(NSString*)aName;

- (NSString*)       getCurrentPlaylist;

- (void)            deletePlaylistWithName:(NSString*)aName;

- (void)            disableShuffle;

- (void)            disableRepeat;

- (double)          timeLeftInCurrentSong;

- (void)            playPlaylist:(NSString*)aPlaylist;

- (BOOL)            isiTunesPlaying;

- ()                getLastSongInPlaylist:(NSString*)aPlaylist;

- (void)            removeLastSongInPlaylist:(NSString*)aPlaylist;

- (void)            playSongFromPlaylist:(NSNumber*)aTrack playlist:(NSString*)aPlaylist;

- (void)            addSongsToPlaylist:(NSString*)aPlaylist songs:(NSArray*)songArray;

@end
