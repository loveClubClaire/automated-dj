script MyApplescript
    property parent : class "NSObject"
    
    on iTunesPause()
        tell application "iTunes"
            pause
        end tell
    end iTunesPause
    
    on getPlaylists()
        tell application "iTunes"
            get properties of playlists
        end tell
    end getPlaylists
    
    on getSongsInPlaylist_(aPlaylist as string)
        tell application "iTunes"
            set my_playlist to get playlist aPlaylist
            get properties of tracks of my_playlist
        end tell
    end getSongsInPlaylist_
    
    on createPlaylistWithName_(aName as string)
        tell application "iTunes"
            make user playlist with properties {name:aName}
        end tell
    end createPlaylistWithName_
    
    on getCurrentPlaylist()
        tell application "iTunes"
            get name of current playlist
        end tell
    end getCurrentPlaylist
    
    on deletePlaylistWithName_(aName as string)
        tell application "iTunes"
            delete playlist aName
        end tell
    end deletePlaylistWithName_
    
end script