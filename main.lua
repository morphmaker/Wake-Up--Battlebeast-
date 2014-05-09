--[[WAKE UP, BATTLEBEAST!
by: Sara Levine
for: CCTP645 Poetics of Mobile, Prof. Garrison LeMasters Spring 2014
	Resources:
	http://sree.cc/corona-sdk/detect-microphone-volume-blowing-into-microphone
	http://docs.coronalabs.com/api/event/enterFrame/index.html#TOC
	http://docs.coronalabs.com/legacy/api/library/widget/newScrollView.html#TOC
	]]
	
--Hide status bar
display.setStatusBar(display.HiddenStatusBar)

--Call widget
local widget = require( "widget" )

--ScrollView listener
local function scrollListener( event )
    local phase = event.phase
    local direction = event.direction

    if "began" == phase then
        print( "Began" )
    elseif "moved" == phase then
        print( "Moved" )
    elseif "ended" == phase then
        print( "Ended" )
    end

    if event.limitReached then
        if "up" == direction then
            print( "Reached Top Limit" )
        elseif "down" == direction then
            print( "Reached Bottom Limit" )
        elseif "left" == direction then
            print( "Reached Left Limit" )
        elseif "right" == direction then
            print( "Reached Right Limit" )
        end
    end

    return true
end

--Create ScrollView
local scrollView = widget.newScrollView
{
    top = 0,
    left = 0,
    width = 1136,
    height = 640,
    scrollWidth = 1136,
    scrollHeight = 640,
    listener = scrollListener,
    verticalScrollDisabled=true
}

--Load and display first part of the story.
local background = display.newImageRect( "wakeupbb1.png", 768, 1024 )
background.x = display.contentWidth*2.76
background.y = display.contentHeight*.5
background:scale(8.2,.65)
scrollView:insert( background )
--Load and display ending if no noise is being made.
local quiet = display.newImageRect("WakeUpBattlebeast-quiet-ending.png",768,1024)
quiet.x = display.contentWidth*9.55
quiet.y = display.contentHeight*.5
quiet:scale(12,.64)
scrollView:insert(quiet)
--Load ending if noise is being made
local loud = display.newImageRect("WakeUpBattlebeast-loud-ending.png",768,1024)
loud.x = display.contentWidth*9.55
loud.y = display.contentHeight*.5
loud:scale(12,.64)

--Noise Listener
local r = media.newRecording()
r:startRecording()
r:startTuner()
local soundDetector = function ( event )
local v = r:getTunerVolume()
if v == 0 then
return
end
--Convert RMS power to dB scale
v = 20 * 0.301 * math.log(v)
m = v*10
--If dB is louder than -35, then display the ending.
if(m>= -35)then
scrollView:insert(loud)
end

end

Runtime:addEventListener("enterFrame",soundDetector)


