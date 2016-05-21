script MyApplescript
    property parent : class "NSObject"
    
    on iTunesPause()
        tell application "iTunes"
            pause
        end tell
    end iTunesPause

    
end script