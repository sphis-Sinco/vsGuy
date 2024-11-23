local doDialogue = true
function onStartCountdown()
	if doDialogue and not seenCutscene and isStoryMode then
		if naughtyness then
			startDialogue('dialogue', 'breakfast') --breakfast is the dialogue music
		else
			startDialogue('dialogue-censored', 'breakfast')
		end
		doDialogue = false
		return Function_Stop
	end
	return Function_Continue
end