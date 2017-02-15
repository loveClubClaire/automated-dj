script MyApplescript
    property parent : class "NSObject"
    
    on iTunesPause()
        tell application "iTunes"
            pause
        end tell
    end iTunesPause
    
    on iTunesStop()
        tell application "iTunes"
            stop
        end tell
    end iTunesStop
    
    on getPlaylists()
        tell application "iTunes"
            set my_result to {}
            try
                set my_result to properties of playlists
            end try
            return my_result
        end tell
    end getPlaylists
    
    on getPlaylist_(aPlaylist as string)
        tell application "iTunes"
            get properties of playlist aPlaylist
        end tell
    end getPlaylist_
    
    on getSongsInPlaylist_(aPlaylist as string)
        tell application "iTunes"
            --Custom timeout of 45 minutes to allow slower systems with large libraries to sucessfully return. The passed parameter is set to another variable because passed parameters can not be directlly called in a timeout block or the applescript will not compile. 
            set thePlaylist to aPlaylist
            set my_result to {}
            with timeout of 2700 seconds
                set my_playlist to get playlist thePlaylist
                try
                    set my_result to properties of tracks of my_playlist
                end try
            end timeout
        return my_result
        end tell
    end getSongsInPlaylist_
    
    on getNumberOfSongsInPlaylist_(aPlaylist as string)
        tell application "iTunes"
            set my_playlist to get playlist aPlaylist
            get number of tracks in my_playlist
        end tell
    end getNumberOfSongsInPlaylist_
    
    on getLastSongInPlaylist_(aPlaylist as string)
        tell application "iTunes"
            set trackNumber to count of tracks of playlist aPlaylist
            return properties of track trackNumber of playlist aPlaylist
        end tell
    end getLastSongInPlaylist_
    
    on removeLastSongInPlaylist_(aPlaylist as string)
        tell application "iTunes"
            set trackNumber to count of tracks of playlist aPlaylist
            delete track trackNumber of playlist aPlaylist
        end tell
    end removeLastSongInPlaylist_
    
    on createPlaylistWithName_(aName as string)
        tell application "iTunes"
            make user playlist with properties {name:aName}
        end tell
    end createPlaylistWithName_
    
    on getCurrentPlaylist()
        --If iTunes is not currently playing, returns the "Music" playlist (which is just the entire music library) as a default
        tell application "iTunes"
           	set currentPlaylist to "Music"
            try
                set currentPlaylist to name of current playlist
            end try
            return currentPlaylist
        end tell
    end getCurrentPlaylist
    
    on deletePlaylistWithName_(aName as string)
        tell application "iTunes"
            try
                delete playlist aName
            end try
        end tell
    end deletePlaylistWithName_
    
    on disableShuffle()
        tell application "iTunes"
            set shuffle enabled to false
        end tell
    end disableShuffle
    
    on disableRepeat()
        tell application "iTunes"
            set song repeat to off
        end tell
    end disableRepeat
    
    on timeLeftInCurrentSong()
        tell application "iTunes"
            --Try block is needed because will otherwise throw an error if iTunes is stopped
            set totalTime to 0
            set currentTime to 0
            try
                set totalTime to duration of current track
                set currentTime to player position
            end try
            return totalTime - currentTime
        end tell
    end timeLeftInCurrentSong
    
    on playPlaylist_(aPlaylist as string)
        tell application "iTunes"
            try
                play playlist aPlaylist
            end try
        end tell
    end playPlaylist_
    
    on getiTunesPlayerState()
        tell application "iTunes"
            return player state
        end tell
    end getiTunesPlayerState
    
    on playSongFromPlaylist_aPlaylist_(aTrack as integer, aPlaylist as string)
        tell application "iTunes"
            play track aTrack in playlist aPlaylist
        end tell
    end playSongFromPlaylist_aPlaylist_
    
    on addSongToPlaylist_aSongID_(aPlaylist as string, aSongID as string)
        tell application "iTunes"
                duplicate (tracks of playlist "Music" whose persistent ID is aSongID) to playlist aPlaylist
        end tell
    end addSongToPlaylist_aSongID_

    on getPersistentIDsOfSongsInPlaylist_(aPlaylist as string)
        tell application "iTunes"
            set my_result to {}
            try
                set my_result to persistent ID of tracks of playlist aPlaylist
            end try
            return my_result
        end tell
    end getSongsInPlaylist_

    on getSong_(anID as string)
        tell application "iTunes"
            get properties of tracks of playlist "Music" whose persistent ID is anID
        end tell
    end getSong_

end script
