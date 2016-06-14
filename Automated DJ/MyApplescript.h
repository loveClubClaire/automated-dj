// MyStuff.h

#import <Cocoa/Cocoa.h>

@protocol ApplescriptProtocol

- (void)        iTunesPause;

-(NSArray*)     getPlaylists;

-(NSArray*)     getSongsInPlaylist:(NSString*)aPlaylist;

-(void)         createPlaylistWithName:(NSString*)aName;

-(NSString*)    getCurrentPlaylist;

-(void)         deletePlaylistWithName:(NSString*)aName;

@end