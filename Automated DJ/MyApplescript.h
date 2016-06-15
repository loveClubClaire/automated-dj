// MyStuff.h

#import <Cocoa/Cocoa.h>

@protocol ApplescriptProtocol

- (void)        iTunesPause;

-(NSArray*)     getPlaylists;

-(NSAppleEventDescriptor*) getPlaylist:(NSString*)aPlaylist;

-(NSArray*)     getSongsInPlaylist:(NSString*)aPlaylist;

-(void)         createPlaylistWithName:(NSString*)aName;

-(NSString*)    getCurrentPlaylist;

-(void)         deletePlaylistWithName:(NSString*)aName;

-(void)         disableShuffle;

-(void)         disableRepeat;

-(NSNumber*)    timeLeftInCurrentSong;

-(void)         playPlaylist:(NSString*)aPlaylist;

-(NSAppleEventDescriptor*)    getiTunesPlayerState;

-(NSAppleEventDescriptor*)    getLastSongInPlaylist:(NSString*)aPlaylist;

-(void)         removeLastSongInPlaylist:(NSString*)aPlaylist;


@end