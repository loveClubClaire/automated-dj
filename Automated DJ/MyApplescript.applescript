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
    
end script