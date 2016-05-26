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

- (NSMutableArray*) getPlaylists;

- (NSMutableArray*) getSongsInPlaylist:(NSString*)aPlaylist;

- (void)            createPlaylistWithName:(NSString*)aName;

@end
