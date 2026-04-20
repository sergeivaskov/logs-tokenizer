$rawLog = @"
2026-04-18T21:07:19.509 [TTTrack] htt: after modifier check
2026-04-18T21:07:19.509 [TTTrack] htt: KeyUp branch, checking cachedSettings      
2026-04-18T21:07:19.509 [TTTrack] htt: KeyUp autoReplEnabled=1 isProcessing=0     
2026-04-18T21:07:19.509 [TTTrack] htt: KeyUp postRepl=0
2026-04-18T21:07:19.509 [TTTrack] htt: KeyUp hasPlannedTargetLayout=0
2026-04-18T21:07:19.509 [TTTrack] htt: KeyUp branch returning false
2026-04-18T21:07:19.557 [HookDiag] LowLevelKeyboardProc: vk=81 keyDown=0 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:19.557 [StageDiag] > entry vk=81 keyDown=0
2026-04-18T21:07:19.557 [StageDiag] > drainPendingReset vk=81 keyDown=0
2026-04-18T21:07:19.558 [StageDiag] > shouldBlockAllFeatures vk=81 keyDown=0      
2026-04-18T21:07:19.558 [StageDiag] > executePendingReplacementIfAny vk=81 keyDown=0
2026-04-18T21:07:19.558 [StageDiag] > hotkeyManager.processKeyEvent vk=81 keyDown=0
2026-04-18T21:07:19.558 [StageDiag] > getCurrentLayout vk=81 keyDown=0
2026-04-18T21:07:19.558 [StageDiag] > isAwaitingBuffer vk=81 keyDown=0
2026-04-18T21:07:19.558 [HookDiag] KeyUp vk=81 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:19.558 [StageDiag] > hotkeyDefs->snapshot vk=81 keyDown=0        
2026-04-18T21:07:19.558 [StageDiag] > handlePromptHotkey vk=81 keyDown=0
2026-04-18T21:07:19.559 [StageDiag] > handleAddWordHotkey vk=81 keyDown=0
2026-04-18T21:07:19.559 [StageDiag] > handleCaseSwitchHotkey vk=81 keyDown=0      
2026-04-18T21:07:19.559 [StageDiag] > handleTranslationHotkey vk=81 keyDown=0     
2026-04-18T21:07:19.559 [StageDiag] > handleLayoutSwitchCombo vk=81 keyDown=0     
2026-04-18T21:07:19.559 [StageDiag] > handleListContinuation vk=81 keyDown=0      
2026-04-18T21:07:19.559 [StageDiag] > handleTokenTracking vk=81 keyDown=0
2026-04-18T21:07:19.559 [TTTrack] htt: enter vk=81 keyDown=0
2026-04-18T21:07:19.559 [TTTrack] htt: after modifier check
2026-04-18T21:07:19.559 [TTTrack] htt: KeyUp branch, checking cachedSettings      
2026-04-18T21:07:19.559 [TTTrack] htt: KeyUp autoReplEnabled=1 isProcessing=0     
2026-04-18T21:07:19.559 [TTTrack] htt: KeyUp postRepl=0
2026-04-18T21:07:19.559 [TTTrack] htt: KeyUp hasPlannedTargetLayout=0
2026-04-18T21:07:19.560 [TTTrack] htt: KeyUp branch returning false
2026-04-18T21:07:19.601 [HookDiag] LowLevelKeyboardProc: vk=32 keyDown=1 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:19.601 [StageDiag] > entry vk=32 keyDown=1
2026-04-18T21:07:19.601 [StageDiag] > drainPendingReset vk=32 keyDown=1
2026-04-18T21:07:19.601 [StageDiag] > shouldBlockAllFeatures vk=32 keyDown=1      
2026-04-18T21:07:19.602 [StageDiag] > executePendingReplacementIfAny vk=32 keyDown=1
2026-04-18T21:07:19.602 [StageDiag] > hotkeyManager.processKeyEvent vk=32 keyDown=1
2026-04-18T21:07:19.602 [StageDiag] > getCurrentLayout vk=32 keyDown=1
2026-04-18T21:07:19.602 [StageDiag] > handleKeyDownWithCapture vk=32 keyDown=1    
2026-04-18T21:07:19.602 [StageDiag] > isAwaitingBuffer vk=32 keyDown=1
2026-04-18T21:07:19.602 [HookDiag] KeyDown vk=32 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:19.602 [StageDiag] > hotkeyDefs->snapshot vk=32 keyDown=1        
2026-04-18T21:07:19.602 [StageDiag] > handlePromptHotkey vk=32 keyDown=1
2026-04-18T21:07:19.602 [StageDiag] > handleAddWordHotkey vk=32 keyDown=1
2026-04-18T21:07:19.602 [StageDiag] > handleCaseSwitchHotkey vk=32 keyDown=1      
2026-04-18T21:07:19.603 [StageDiag] > handleTranslationHotkey vk=32 keyDown=1     
2026-04-18T21:07:19.603 [StageDiag] > handleLayoutSwitchCombo vk=32 keyDown=1     
2026-04-18T21:07:19.603 [StageDiag] > handleListContinuation vk=32 keyDown=1      
2026-04-18T21:07:19.603 [StageDiag] > handleTokenTracking vk=32 keyDown=1
2026-04-18T21:07:19.603 [TTTrack] htt: enter vk=32 keyDown=1
2026-04-18T21:07:19.603 [TTTrack] htt: after modifier check
2026-04-18T21:07:19.603 [TTTrack] htt: KeyDown branch past initial block
2026-04-18T21:07:19.603 [TTTrack] htt: before tracker.handleKeyEvent
2026-04-18T21:07:19.603 [TTTrack] htt: after tracker.handleKeyEvent
2026-04-18T21:07:19.603 [TTTrack] htt: KeyDown shouldAnalyze=1
2026-04-18T21:07:19.603 [TTTrack] htt: KeyDown shouldExecute=0
2026-04-18T21:07:19.603 [SpellCheckDiag] enqueue inflight=1 word=единой
2026-04-18T21:07:19.604 [SpellCheckDiag] done    inflight=0
2026-04-18T21:07:19.690 [HookDiag] LowLevelKeyboardProc: vk=32 keyDown=0 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:19.690 [StageDiag] > entry vk=32 keyDown=0
2026-04-18T21:07:19.690 [StageDiag] > drainPendingReset vk=32 keyDown=0
2026-04-18T21:07:19.690 [StageDiag] > shouldBlockAllFeatures vk=32 keyDown=0      
2026-04-18T21:07:19.690 [StageDiag] > executePendingReplacementIfAny vk=32 keyDown=0
2026-04-18T21:07:19.690 [StageDiag] > hotkeyManager.processKeyEvent vk=32 keyDown=0
2026-04-18T21:07:19.691 [StageDiag] > getCurrentLayout vk=32 keyDown=0
2026-04-18T21:07:19.691 [StageDiag] > isAwaitingBuffer vk=32 keyDown=0
2026-04-18T21:07:19.691 [HookDiag] KeyUp vk=32 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:19.691 [StageDiag] > hotkeyDefs->snapshot vk=32 keyDown=0        
2026-04-18T21:07:19.691 [StageDiag] > handlePromptHotkey vk=32 keyDown=0
2026-04-18T21:07:19.691 [StageDiag] > handleAddWordHotkey vk=32 keyDown=0
2026-04-18T21:07:19.691 [StageDiag] > handleCaseSwitchHotkey vk=32 keyDown=0      
2026-04-18T21:07:19.691 [StageDiag] > handleTranslationHotkey vk=32 keyDown=0     
2026-04-18T21:07:19.691 [StageDiag] > handleLayoutSwitchCombo vk=32 keyDown=0     
2026-04-18T21:07:19.691 [StageDiag] > handleListContinuation vk=32 keyDown=0      
2026-04-18T21:07:19.692 [StageDiag] > handleTokenTracking vk=32 keyDown=0
2026-04-18T21:07:19.692 [TTTrack] htt: enter vk=32 keyDown=0
2026-04-18T21:07:19.692 [TTTrack] htt: after modifier check
2026-04-18T21:07:19.692 [TTTrack] htt: KeyUp branch, checking cachedSettings      
2026-04-18T21:07:19.692 [TTTrack] htt: KeyUp autoReplEnabled=1 isProcessing=0     
2026-04-18T21:07:19.692 [TTTrack] htt: KeyUp postRepl=0
2026-04-18T21:07:19.692 [TTTrack] htt: KeyUp hasPlannedTargetLayout=0
2026-04-18T21:07:19.692 [TTTrack] htt: KeyUp branch returning false
2026-04-18T21:07:19.802 [HookDiag] LowLevelKeyboardProc: vk=75 keyDown=1 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:19.802 [StageDiag] > entry vk=75 keyDown=1
2026-04-18T21:07:19.802 [StageDiag] > drainPendingReset vk=75 keyDown=1
2026-04-18T21:07:19.802 [StageDiag] > shouldBlockAllFeatures vk=75 keyDown=1      
2026-04-18T21:07:19.802 [StageDiag] > executePendingReplacementIfAny vk=75 keyDown=1
2026-04-18T21:07:19.802 [StageDiag] > hotkeyManager.processKeyEvent vk=75 keyDown=1
2026-04-18T21:07:19.802 [StageDiag] > getCurrentLayout vk=75 keyDown=1
2026-04-18T21:07:19.803 [StageDiag] > handleKeyDownWithCapture vk=75 keyDown=1    
2026-04-18T21:07:19.803 [StageDiag] > isAwaitingBuffer vk=75 keyDown=1
2026-04-18T21:07:19.803 [HookDiag] KeyDown vk=75 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:19.803 [StageDiag] > hotkeyDefs->snapshot vk=75 keyDown=1        
2026-04-18T21:07:19.803 [StageDiag] > handlePromptHotkey vk=75 keyDown=1
2026-04-18T21:07:19.803 [StageDiag] > handleAddWordHotkey vk=75 keyDown=1
2026-04-18T21:07:19.803 [StageDiag] > handleCaseSwitchHotkey vk=75 keyDown=1      
2026-04-18T21:07:19.803 [StageDiag] > handleTranslationHotkey vk=75 keyDown=1     
2026-04-18T21:07:19.803 [StageDiag] > handleLayoutSwitchCombo vk=75 keyDown=1     
2026-04-18T21:07:19.803 [StageDiag] > handleListContinuation vk=75 keyDown=1      
2026-04-18T21:07:19.804 [StageDiag] > handleTokenTracking vk=75 keyDown=1
2026-04-18T21:07:19.804 [TTTrack] htt: enter vk=75 keyDown=1
2026-04-18T21:07:19.804 [TTTrack] htt: after modifier check
2026-04-18T21:07:19.804 [TTTrack] htt: KeyDown branch past initial block
2026-04-18T21:07:19.804 [TTTrack] htt: before tracker.handleKeyEvent
2026-04-18T21:07:19.804 [TTDiag] cleanupBuffer: enter
2026-04-18T21:07:19.804 [TTDiag] cleanupBuffer: before lock_guard(bufferMutex_)   
2026-04-18T21:07:19.804 [TTDiag] cleanupBuffer: lock acquired, hasOnComplete=0    
2026-04-18T21:07:19.804 [TTDiag] cleanupBuffer: releasing lock
2026-04-18T21:07:19.804 [TTDiag] cleanupBuffer: lock released
2026-04-18T21:07:19.804 [TTDiag] cleanupBuffer: exit
2026-04-18T21:07:19.804 [TTTrack] htt: after tracker.handleKeyEvent
2026-04-18T21:07:19.804 [TTTrack] htt: KeyDown shouldAnalyze=1
2026-04-18T21:07:19.804 [TTTrack] htt: KeyDown shouldExecute=0
2026-04-18T21:07:19.881 [HookDiag] LowLevelKeyboardProc: vk=74 keyDown=1 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:19.881 [StageDiag] > entry vk=74 keyDown=1
2026-04-18T21:07:19.882 [StageDiag] > drainPendingReset vk=74 keyDown=1
2026-04-18T21:07:19.882 [StageDiag] > shouldBlockAllFeatures vk=74 keyDown=1      
2026-04-18T21:07:19.882 [StageDiag] > executePendingReplacementIfAny vk=74 keyDown=1
2026-04-18T21:07:19.882 [StageDiag] > hotkeyManager.processKeyEvent vk=74 keyDown=1
2026-04-18T21:07:19.882 [StageDiag] > getCurrentLayout vk=74 keyDown=1
2026-04-18T21:07:19.882 [StageDiag] > handleKeyDownWithCapture vk=74 keyDown=1    
2026-04-18T21:07:19.882 [StageDiag] > isAwaitingBuffer vk=74 keyDown=1
2026-04-18T21:07:19.882 [HookDiag] KeyDown vk=74 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:19.882 [StageDiag] > hotkeyDefs->snapshot vk=74 keyDown=1        
2026-04-18T21:07:19.883 [StageDiag] > handlePromptHotkey vk=74 keyDown=1
2026-04-18T21:07:19.883 [StageDiag] > handleAddWordHotkey vk=74 keyDown=1
2026-04-18T21:07:19.883 [StageDiag] > handleCaseSwitchHotkey vk=74 keyDown=1      
2026-04-18T21:07:19.883 [StageDiag] > handleTranslationHotkey vk=74 keyDown=1     
2026-04-18T21:07:19.883 [StageDiag] > handleLayoutSwitchCombo vk=74 keyDown=1     
2026-04-18T21:07:19.883 [StageDiag] > handleListContinuation vk=74 keyDown=1      
2026-04-18T21:07:19.883 [StageDiag] > handleTokenTracking vk=74 keyDown=1
2026-04-18T21:07:19.883 [TTTrack] htt: enter vk=74 keyDown=1
2026-04-18T21:07:19.883 [TTTrack] htt: after modifier check
2026-04-18T21:07:19.883 [TTTrack] htt: KeyDown branch past initial block
2026-04-18T21:07:19.883 [TTTrack] htt: before tracker.handleKeyEvent
2026-04-18T21:07:19.883 [TTTrack] htt: after tracker.handleKeyEvent
2026-04-18T21:07:19.883 [TTTrack] htt: KeyDown shouldAnalyze=1
2026-04-18T21:07:19.883 [TTTrack] htt: KeyDown shouldExecute=0
2026-04-18T21:07:19.919 [HookDiag] LowLevelKeyboardProc: vk=75 keyDown=0 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:19.919 [StageDiag] > entry vk=75 keyDown=0
2026-04-18T21:07:19.919 [StageDiag] > drainPendingReset vk=75 keyDown=0
2026-04-18T21:07:19.920 [StageDiag] > shouldBlockAllFeatures vk=75 keyDown=0      
2026-04-18T21:07:19.920 [StageDiag] > executePendingReplacementIfAny vk=75 keyDown=0
2026-04-18T21:07:19.920 [StageDiag] > hotkeyManager.processKeyEvent vk=75 keyDown=0
2026-04-18T21:07:19.920 [StageDiag] > getCurrentLayout vk=75 keyDown=0
2026-04-18T21:07:19.920 [StageDiag] > isAwaitingBuffer vk=75 keyDown=0
2026-04-18T21:07:19.920 [HookDiag] KeyUp vk=75 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:19.920 [StageDiag] > hotkeyDefs->snapshot vk=75 keyDown=0        
2026-04-18T21:07:19.920 [StageDiag] > handlePromptHotkey vk=75 keyDown=0
2026-04-18T21:07:19.920 [StageDiag] > handleAddWordHotkey vk=75 keyDown=0
2026-04-18T21:07:19.921 [StageDiag] > handleCaseSwitchHotkey vk=75 keyDown=0      
2026-04-18T21:07:19.921 [StageDiag] > handleTranslationHotkey vk=75 keyDown=0     
2026-04-18T21:07:19.921 [StageDiag] > handleLayoutSwitchCombo vk=75 keyDown=0     
2026-04-18T21:07:19.921 [StageDiag] > handleListContinuation vk=75 keyDown=0      
2026-04-18T21:07:19.921 [StageDiag] > handleTokenTracking vk=75 keyDown=0
2026-04-18T21:07:19.921 [TTTrack] htt: enter vk=75 keyDown=0
2026-04-18T21:07:19.921 [TTTrack] htt: after modifier check
2026-04-18T21:07:19.921 [TTTrack] htt: KeyUp branch, checking cachedSettings      
2026-04-18T21:07:19.921 [TTTrack] htt: KeyUp autoReplEnabled=1 isProcessing=0     
2026-04-18T21:07:19.922 [TTTrack] htt: KeyUp postRepl=0
2026-04-18T21:07:19.922 [TTTrack] htt: KeyUp hasPlannedTargetLayout=0
2026-04-18T21:07:19.922 [TTTrack] htt: KeyUp branch returning false
2026-04-18T21:07:19.995 [HookDiag] LowLevelKeyboardProc: vk=74 keyDown=0 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:19.995 [StageDiag] > entry vk=74 keyDown=0
2026-04-18T21:07:19.995 [StageDiag] > drainPendingReset vk=74 keyDown=0
2026-04-18T21:07:19.996 [StageDiag] > shouldBlockAllFeatures vk=74 keyDown=0      
2026-04-18T21:07:19.996 [StageDiag] > executePendingReplacementIfAny vk=74 keyDown=0
2026-04-18T21:07:19.996 [StageDiag] > hotkeyManager.processKeyEvent vk=74 keyDown=0
2026-04-18T21:07:19.996 [StageDiag] > getCurrentLayout vk=74 keyDown=0
2026-04-18T21:07:19.996 [StageDiag] > isAwaitingBuffer vk=74 keyDown=0
2026-04-18T21:07:19.996 [HookDiag] KeyUp vk=74 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:19.996 [StageDiag] > hotkeyDefs->snapshot vk=74 keyDown=0        
2026-04-18T21:07:19.996 [StageDiag] > handlePromptHotkey vk=74 keyDown=0
2026-04-18T21:07:19.996 [StageDiag] > handleAddWordHotkey vk=74 keyDown=0
2026-04-18T21:07:19.997 [StageDiag] > handleCaseSwitchHotkey vk=74 keyDown=0      
2026-04-18T21:07:19.997 [StageDiag] > handleTranslationHotkey vk=74 keyDown=0     
2026-04-18T21:07:19.997 [StageDiag] > handleLayoutSwitchCombo vk=74 keyDown=0     
2026-04-18T21:07:19.997 [StageDiag] > handleListContinuation vk=74 keyDown=0      
2026-04-18T21:07:19.997 [StageDiag] > handleTokenTracking vk=74 keyDown=0
2026-04-18T21:07:19.997 [TTTrack] htt: enter vk=74 keyDown=0
2026-04-18T21:07:19.997 [TTTrack] htt: after modifier check
2026-04-18T21:07:19.997 [TTTrack] htt: KeyUp branch, checking cachedSettings      
2026-04-18T21:07:19.997 [TTTrack] htt: KeyUp autoReplEnabled=1 isProcessing=0     
2026-04-18T21:07:19.997 [TTTrack] htt: KeyUp postRepl=0
2026-04-18T21:07:19.997 [TTTrack] htt: KeyUp hasPlannedTargetLayout=0
2026-04-18T21:07:19.997 [TTTrack] htt: KeyUp branch returning false
2026-04-18T21:07:20.404 [HookDiag] LowLevelKeyboardProc: vk=85 keyDown=1 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:20.404 [StageDiag] > entry vk=85 keyDown=1
2026-04-18T21:07:20.404 [StageDiag] > drainPendingReset vk=85 keyDown=1
2026-04-18T21:07:20.404 [StageDiag] > shouldBlockAllFeatures vk=85 keyDown=1      
2026-04-18T21:07:20.404 [StageDiag] > executePendingReplacementIfAny vk=85 keyDown=1
2026-04-18T21:07:20.404 [StageDiag] > hotkeyManager.processKeyEvent vk=85 keyDown=1
2026-04-18T21:07:20.405 [StageDiag] > getCurrentLayout vk=85 keyDown=1
2026-04-18T21:07:20.405 [StageDiag] > handleKeyDownWithCapture vk=85 keyDown=1    
2026-04-18T21:07:20.405 [StageDiag] > isAwaitingBuffer vk=85 keyDown=1
2026-04-18T21:07:20.405 [HookDiag] KeyDown vk=85 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:20.405 [StageDiag] > hotkeyDefs->snapshot vk=85 keyDown=1        
2026-04-18T21:07:20.405 [StageDiag] > handlePromptHotkey vk=85 keyDown=1
2026-04-18T21:07:20.405 [StageDiag] > handleAddWordHotkey vk=85 keyDown=1
2026-04-18T21:07:20.405 [StageDiag] > handleCaseSwitchHotkey vk=85 keyDown=1      
2026-04-18T21:07:20.405 [StageDiag] > handleTranslationHotkey vk=85 keyDown=1     
2026-04-18T21:07:20.405 [StageDiag] > handleLayoutSwitchCombo vk=85 keyDown=1     
2026-04-18T21:07:20.405 [StageDiag] > handleListContinuation vk=85 keyDown=1      
2026-04-18T21:07:20.405 [StageDiag] > handleTokenTracking vk=85 keyDown=1
2026-04-18T21:07:20.406 [TTTrack] htt: enter vk=85 keyDown=1
2026-04-18T21:07:20.406 [TTTrack] htt: after modifier check
2026-04-18T21:07:20.406 [TTTrack] htt: KeyDown branch past initial block
2026-04-18T21:07:20.406 [TTTrack] htt: before tracker.handleKeyEvent
2026-04-18T21:07:20.406 [TTTrack] htt: after tracker.handleKeyEvent
2026-04-18T21:07:20.406 [TTTrack] htt: KeyDown shouldAnalyze=1
2026-04-18T21:07:20.406 [TTTrack] htt: KeyDown shouldExecute=0
2026-04-18T21:07:20.506 [HookDiag] LowLevelKeyboardProc: vk=85 keyDown=0 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:20.506 [StageDiag] > entry vk=85 keyDown=0
2026-04-18T21:07:20.506 [StageDiag] > drainPendingReset vk=85 keyDown=0
2026-04-18T21:07:20.506 [StageDiag] > shouldBlockAllFeatures vk=85 keyDown=0      
2026-04-18T21:07:20.506 [StageDiag] > executePendingReplacementIfAny vk=85 keyDown=0
2026-04-18T21:07:20.506 [StageDiag] > hotkeyManager.processKeyEvent vk=85 keyDown=0
2026-04-18T21:07:20.506 [StageDiag] > getCurrentLayout vk=85 keyDown=0
2026-04-18T21:07:20.506 [StageDiag] > isAwaitingBuffer vk=85 keyDown=0
2026-04-18T21:07:20.507 [HookDiag] KeyUp vk=85 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:20.507 [StageDiag] > hotkeyDefs->snapshot vk=85 keyDown=0        
2026-04-18T21:07:20.507 [StageDiag] > handlePromptHotkey vk=85 keyDown=0
2026-04-18T21:07:20.507 [StageDiag] > handleAddWordHotkey vk=85 keyDown=0
2026-04-18T21:07:20.507 [StageDiag] > handleCaseSwitchHotkey vk=85 keyDown=0      
2026-04-18T21:07:20.507 [StageDiag] > handleTranslationHotkey vk=85 keyDown=0     
2026-04-18T21:07:20.507 [StageDiag] > handleLayoutSwitchCombo vk=85 keyDown=0     
2026-04-18T21:07:20.507 [StageDiag] > handleListContinuation vk=85 keyDown=0      
2026-04-18T21:07:20.507 [StageDiag] > handleTokenTracking vk=85 keyDown=0
2026-04-18T21:07:20.507 [TTTrack] htt: enter vk=85 keyDown=0
2026-04-18T21:07:20.507 [TTTrack] htt: after modifier check
2026-04-18T21:07:20.507 [TTTrack] htt: KeyUp branch, checking cachedSettings      
2026-04-18T21:07:20.507 [TTTrack] htt: KeyUp autoReplEnabled=1 isProcessing=0     
2026-04-18T21:07:20.507 [TTTrack] htt: KeyUp postRepl=0
2026-04-18T21:07:20.507 [TTTrack] htt: KeyUp hasPlannedTargetLayout=0
2026-04-18T21:07:20.508 [TTTrack] htt: KeyUp branch returning false
2026-04-18T21:07:20.578 [HookDiag] LowLevelKeyboardProc: vk=66 keyDown=1 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:20.579 [StageDiag] > entry vk=66 keyDown=1
2026-04-18T21:07:20.579 [StageDiag] > drainPendingReset vk=66 keyDown=1
2026-04-18T21:07:20.579 [StageDiag] > shouldBlockAllFeatures vk=66 keyDown=1      
2026-04-18T21:07:20.579 [StageDiag] > executePendingReplacementIfAny vk=66 keyDown=1
2026-04-18T21:07:20.579 [StageDiag] > hotkeyManager.processKeyEvent vk=66 keyDown=1
2026-04-18T21:07:20.579 [StageDiag] > getCurrentLayout vk=66 keyDown=1
2026-04-18T21:07:20.579 [StageDiag] > handleKeyDownWithCapture vk=66 keyDown=1    
2026-04-18T21:07:20.579 [StageDiag] > isAwaitingBuffer vk=66 keyDown=1
2026-04-18T21:07:20.580 [HookDiag] KeyDown vk=66 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:20.580 [StageDiag] > hotkeyDefs->snapshot vk=66 keyDown=1        
2026-04-18T21:07:20.580 [StageDiag] > handlePromptHotkey vk=66 keyDown=1
2026-04-18T21:07:20.580 [StageDiag] > handleAddWordHotkey vk=66 keyDown=1
2026-04-18T21:07:20.580 [StageDiag] > handleCaseSwitchHotkey vk=66 keyDown=1      
2026-04-18T21:07:20.580 [StageDiag] > handleTranslationHotkey vk=66 keyDown=1     
2026-04-18T21:07:20.580 [StageDiag] > handleLayoutSwitchCombo vk=66 keyDown=1     
2026-04-18T21:07:20.580 [StageDiag] > handleListContinuation vk=66 keyDown=1      
2026-04-18T21:07:20.580 [StageDiag] > handleTokenTracking vk=66 keyDown=1
2026-04-18T21:07:20.580 [TTTrack] htt: enter vk=66 keyDown=1
2026-04-18T21:07:20.581 [TTTrack] htt: after modifier check
2026-04-18T21:07:20.581 [TTTrack] htt: KeyDown branch past initial block
2026-04-18T21:07:20.581 [TTTrack] htt: before tracker.handleKeyEvent
2026-04-18T21:07:20.581 [TTTrack] htt: after tracker.handleKeyEvent
2026-04-18T21:07:20.581 [TTTrack] htt: KeyDown shouldAnalyze=1
2026-04-18T21:07:20.680 [HookDiag] LowLevelKeyboardProc: vk=66 keyDown=0 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:20.681 [StageDiag] > entry vk=66 keyDown=0
2026-04-18T21:07:20.681 [StageDiag] > drainPendingReset vk=66 keyDown=0
2026-04-18T21:07:20.681 [StageDiag] > shouldBlockAllFeatures vk=66 keyDown=0      
2026-04-18T21:07:20.681 [StageDiag] > executePendingReplacementIfAny vk=66 keyDown=0
2026-04-18T21:07:20.681 [StageDiag] > hotkeyManager.processKeyEvent vk=66 keyDown=0
2026-04-18T21:07:20.681 [StageDiag] > getCurrentLayout vk=66 keyDown=0
2026-04-18T21:07:20.681 [StageDiag] > isAwaitingBuffer vk=66 keyDown=0
2026-04-18T21:07:20.682 [HookDiag] KeyUp vk=66 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:20.682 [StageDiag] > hotkeyDefs->snapshot vk=66 keyDown=0        
2026-04-18T21:07:20.682 [StageDiag] > handlePromptHotkey vk=66 keyDown=0
2026-04-18T21:07:20.682 [StageDiag] > handleAddWordHotkey vk=66 keyDown=0
2026-04-18T21:07:20.682 [StageDiag] > handleCaseSwitchHotkey vk=66 keyDown=0      
2026-04-18T21:07:20.682 [StageDiag] > handleTranslationHotkey vk=66 keyDown=0     
2026-04-18T21:07:20.682 [StageDiag] > handleLayoutSwitchCombo vk=66 keyDown=0     
2026-04-18T21:07:20.682 [StageDiag] > handleListContinuation vk=66 keyDown=0      
2026-04-18T21:07:20.683 [StageDiag] > handleTokenTracking vk=66 keyDown=0
2026-04-18T21:07:20.683 [TTTrack] htt: enter vk=66 keyDown=0
2026-04-18T21:07:20.683 [TTTrack] htt: after modifier check
2026-04-18T21:07:20.683 [TTTrack] htt: KeyUp branch, checking cachedSettings      
2026-04-18T21:07:20.683 [TTTrack] htt: KeyUp autoReplEnabled=1 isProcessing=0     
2026-04-18T21:07:20.683 [TTTrack] htt: KeyUp postRepl=0
2026-04-18T21:07:20.683 [TTTrack] htt: KeyUp hasPlannedTargetLayout=0
2026-04-18T21:07:20.683 [TTTrack] htt: KeyUp branch returning false
2026-04-18T21:07:20.689 [HookDiag] LowLevelKeyboardProc: vk=82 keyDown=1 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:20.690 [StageDiag] > entry vk=82 keyDown=1
2026-04-18T21:07:20.690 [StageDiag] > drainPendingReset vk=82 keyDown=1
2026-04-18T21:07:20.690 [StageDiag] > shouldBlockAllFeatures vk=82 keyDown=1      
2026-04-18T21:07:20.690 [StageDiag] > executePendingReplacementIfAny vk=82 keyDown=1
2026-04-18T21:07:20.690 [StageDiag] > hotkeyManager.processKeyEvent vk=82 keyDown=1
2026-04-18T21:07:20.690 [StageDiag] > getCurrentLayout vk=82 keyDown=1
2026-04-18T21:07:20.691 [StageDiag] > handleKeyDownWithCapture vk=82 keyDown=1    
2026-04-18T21:07:20.691 [StageDiag] > isAwaitingBuffer vk=82 keyDown=1
2026-04-18T21:07:20.691 [HookDiag] KeyDown vk=82 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:20.691 [StageDiag] > hotkeyDefs->snapshot vk=82 keyDown=1        
2026-04-18T21:07:20.691 [StageDiag] > handlePromptHotkey vk=82 keyDown=1
2026-04-18T21:07:20.691 [StageDiag] > handleAddWordHotkey vk=82 keyDown=1
2026-04-18T21:07:20.691 [StageDiag] > handleCaseSwitchHotkey vk=82 keyDown=1      
2026-04-18T21:07:20.692 [StageDiag] > handleTranslationHotkey vk=82 keyDown=1     
2026-04-18T21:07:20.692 [StageDiag] > handleLayoutSwitchCombo vk=82 keyDown=1     
2026-04-18T21:07:20.692 [StageDiag] > handleListContinuation vk=82 keyDown=1      
2026-04-18T21:07:20.692 [StageDiag] > handleTokenTracking vk=82 keyDown=1
2026-04-18T21:07:20.692 [TTTrack] htt: enter vk=82 keyDown=1
2026-04-18T21:07:20.692 [TTTrack] htt: after modifier check
2026-04-18T21:07:20.692 [TTTrack] htt: KeyDown branch past initial block
2026-04-18T21:07:20.692 [TTTrack] htt: before tracker.handleKeyEvent
2026-04-18T21:07:20.693 [TTTrack] htt: after tracker.handleKeyEvent
2026-04-18T21:07:20.693 [TTTrack] htt: KeyDown shouldAnalyze=1
2026-04-18T21:07:20.731 [HookDiag] LowLevelKeyboardProc: vk=84 keyDown=1 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:20.731 [StageDiag] > entry vk=84 keyDown=1
2026-04-18T21:07:20.731 [StageDiag] > drainPendingReset vk=84 keyDown=1
2026-04-18T21:07:20.731 [StageDiag] > shouldBlockAllFeatures vk=84 keyDown=1      
2026-04-18T21:07:20.732 [StageDiag] > executePendingReplacementIfAny vk=84 keyDown=1
2026-04-18T21:07:20.732 [StageDiag] > hotkeyManager.processKeyEvent vk=84 keyDown=1
2026-04-18T21:07:20.732 [StageDiag] > getCurrentLayout vk=84 keyDown=1
2026-04-18T21:07:20.732 [StageDiag] > handleKeyDownWithCapture vk=84 keyDown=1    
2026-04-18T21:07:20.732 [StageDiag] > isAwaitingBuffer vk=84 keyDown=1
2026-04-18T21:07:20.732 [HookDiag] KeyDown vk=84 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:20.733 [StageDiag] > hotkeyDefs->snapshot vk=84 keyDown=1        
2026-04-18T21:07:20.733 [StageDiag] > handlePromptHotkey vk=84 keyDown=1
2026-04-18T21:07:20.733 [StageDiag] > handleAddWordHotkey vk=84 keyDown=1
2026-04-18T21:07:20.733 [StageDiag] > handleCaseSwitchHotkey vk=84 keyDown=1      
2026-04-18T21:07:20.733 [StageDiag] > handleTranslationHotkey vk=84 keyDown=1     
2026-04-18T21:07:20.733 [StageDiag] > handleLayoutSwitchCombo vk=84 keyDown=1     
2026-04-18T21:07:20.733 [StageDiag] > handleListContinuation vk=84 keyDown=1      
2026-04-18T21:07:20.733 [StageDiag] > handleTokenTracking vk=84 keyDown=1
2026-04-18T21:07:20.733 [TTTrack] htt: enter vk=84 keyDown=1
2026-04-18T21:07:20.733 [TTTrack] htt: after modifier check
2026-04-18T21:07:20.734 [TTTrack] htt: KeyDown branch past initial block
2026-04-18T21:07:20.734 [TTTrack] htt: before tracker.handleKeyEvent
2026-04-18T21:07:20.734 [TTTrack] htt: after tracker.handleKeyEvent
2026-04-18T21:07:20.734 [TTTrack] htt: KeyDown shouldAnalyze=1
2026-04-18T21:07:20.785 [HookDiag] LowLevelKeyboardProc: vk=82 keyDown=0 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:20.785 [StageDiag] > entry vk=82 keyDown=0
2026-04-18T21:07:20.785 [StageDiag] > drainPendingReset vk=82 keyDown=0
2026-04-18T21:07:20.785 [StageDiag] > shouldBlockAllFeatures vk=82 keyDown=0      
2026-04-18T21:07:20.785 [StageDiag] > executePendingReplacementIfAny vk=82 keyDown=0
2026-04-18T21:07:20.785 [StageDiag] > hotkeyManager.processKeyEvent vk=82 keyDown=0
2026-04-18T21:07:20.785 [StageDiag] > getCurrentLayout vk=82 keyDown=0
2026-04-18T21:07:20.786 [StageDiag] > isAwaitingBuffer vk=82 keyDown=0
2026-04-18T21:07:20.786 [HookDiag] KeyUp vk=82 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:20.786 [StageDiag] > hotkeyDefs->snapshot vk=82 keyDown=0        
2026-04-18T21:07:20.786 [StageDiag] > handlePromptHotkey vk=82 keyDown=0
2026-04-18T21:07:20.786 [StageDiag] > handleAddWordHotkey vk=82 keyDown=0
2026-04-18T21:07:20.786 [StageDiag] > handleCaseSwitchHotkey vk=82 keyDown=0      
2026-04-18T21:07:20.786 [StageDiag] > handleTranslationHotkey vk=82 keyDown=0     
2026-04-18T21:07:20.786 [StageDiag] > handleLayoutSwitchCombo vk=82 keyDown=0     
2026-04-18T21:07:20.786 [StageDiag] > handleListContinuation vk=82 keyDown=0      
2026-04-18T21:07:20.787 [StageDiag] > handleTokenTracking vk=82 keyDown=0
2026-04-18T21:07:20.787 [TTTrack] htt: enter vk=82 keyDown=0
2026-04-18T21:07:20.787 [TTTrack] htt: after modifier check
2026-04-18T21:07:20.787 [TTTrack] htt: KeyUp branch, checking cachedSettings      
2026-04-18T21:07:20.787 [TTTrack] htt: KeyUp autoReplEnabled=1 isProcessing=0     
2026-04-18T21:07:20.787 [TTTrack] htt: KeyUp postRepl=0
2026-04-18T21:07:20.787 [TTTrack] htt: KeyUp hasPlannedTargetLayout=0
2026-04-18T21:07:20.787 [TTTrack] htt: KeyUp branch returning false
2026-04-18T21:07:20.851 [HookDiag] LowLevelKeyboardProc: vk=84 keyDown=0 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:20.851 [StageDiag] > entry vk=84 keyDown=0
2026-04-18T21:07:20.851 [StageDiag] > drainPendingReset vk=84 keyDown=0
2026-04-18T21:07:20.851 [StageDiag] > shouldBlockAllFeatures vk=84 keyDown=0      
2026-04-18T21:07:20.851 [StageDiag] > executePendingReplacementIfAny vk=84 keyDown=0
2026-04-18T21:07:20.851 [StageDiag] > hotkeyManager.processKeyEvent vk=84 keyDown=0
2026-04-18T21:07:20.851 [StageDiag] > getCurrentLayout vk=84 keyDown=0
2026-04-18T21:07:20.852 [StageDiag] > isAwaitingBuffer vk=84 keyDown=0
2026-04-18T21:07:20.852 [HookDiag] KeyUp vk=84 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:20.852 [StageDiag] > hotkeyDefs->snapshot vk=84 keyDown=0        
2026-04-18T21:07:20.852 [StageDiag] > handlePromptHotkey vk=84 keyDown=0
2026-04-18T21:07:20.852 [StageDiag] > handleAddWordHotkey vk=84 keyDown=0
2026-04-18T21:07:20.852 [StageDiag] > handleCaseSwitchHotkey vk=84 keyDown=0      
2026-04-18T21:07:20.852 [StageDiag] > handleTranslationHotkey vk=84 keyDown=0     
2026-04-18T21:07:20.852 [StageDiag] > handleLayoutSwitchCombo vk=84 keyDown=0     
2026-04-18T21:07:20.852 [StageDiag] > handleListContinuation vk=84 keyDown=0      
2026-04-18T21:07:20.852 [StageDiag] > handleTokenTracking vk=84 keyDown=0
2026-04-18T21:07:20.852 [TTTrack] htt: enter vk=84 keyDown=0
2026-04-18T21:07:20.853 [TTTrack] htt: after modifier check
2026-04-18T21:07:20.853 [TTTrack] htt: KeyUp branch, checking cachedSettings      
2026-04-18T21:07:20.853 [TTTrack] htt: KeyUp autoReplEnabled=1 isProcessing=0     
2026-04-18T21:07:20.853 [TTTrack] htt: KeyUp postRepl=0
2026-04-18T21:07:20.853 [TTTrack] htt: KeyUp hasPlannedTargetLayout=0
2026-04-18T21:07:20.853 [TTTrack] htt: KeyUp branch returning false
2026-04-18T21:07:21.589 [HookDiag] LowLevelKeyboardProc: vk=13 keyDown=1 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:21.589 [StageDiag] > entry vk=13 keyDown=1
2026-04-18T21:07:21.589 [StageDiag] > drainPendingReset vk=13 keyDown=1
2026-04-18T21:07:21.589 [StageDiag] > shouldBlockAllFeatures vk=13 keyDown=1      
2026-04-18T21:07:21.589 [StageDiag] > executePendingReplacementIfAny vk=13 keyDown=1
2026-04-18T21:07:21.589 [StageDiag] > hotkeyManager.processKeyEvent vk=13 keyDown=1
2026-04-18T21:07:21.590 [StageDiag] > getCurrentLayout vk=13 keyDown=1
2026-04-18T21:07:21.590 [StageDiag] > handleKeyDownWithCapture vk=13 keyDown=1    
2026-04-18T21:07:21.590 [StageDiag] > isAwaitingBuffer vk=13 keyDown=1
2026-04-18T21:07:21.590 [HookDiag] KeyDown vk=13 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=0
2026-04-18T21:07:21.590 [StageDiag] > hotkeyDefs->snapshot vk=13 keyDown=1        
2026-04-18T21:07:21.590 [StageDiag] > handlePromptHotkey vk=13 keyDown=1
2026-04-18T21:07:21.590 [StageDiag] > handleAddWordHotkey vk=13 keyDown=1
2026-04-18T21:07:21.590 [StageDiag] > handleCaseSwitchHotkey vk=13 keyDown=1      
2026-04-18T21:07:21.590 [StageDiag] > handleTranslationHotkey vk=13 keyDown=1     
2026-04-18T21:07:21.591 [StageDiag] > handleLayoutSwitchCombo vk=13 keyDown=1     
2026-04-18T21:07:21.591 [StageDiag] > handleListContinuation vk=13 keyDown=1      
2026-04-18T21:07:21.595 [WinTextExtractor] UI Automation initialized
2026-04-18T21:07:21.606 [WinTextExtractor] Text: 41 chars, cursor: 41
2026-04-18T21:07:21.609 [StageDiag] > handleTokenTracking vk=13 keyDown=1
2026-04-18T21:07:21.610 [TTTrack] htt: enter vk=13 keyDown=1
2026-04-18T21:07:21.610 [TTTrack] htt: after modifier check
2026-04-18T21:07:21.610 [TTTrack] htt: KeyDown branch past initial block
2026-04-18T21:07:21.610 [TTTrack] htt: before tracker.handleKeyEvent
2026-04-18T21:07:21.610 [TTDiag] clearToken: enter
2026-04-18T21:07:21.610 [TTDiag] clearToken: before lock_guard(tokenMutex_)       
2026-04-18T21:07:21.611 [TTDiag] clearToken: lock acquired
2026-04-18T21:07:21.611 [TTDiag] clearToken: state cleared, releasing lock        
2026-04-18T21:07:21.611 [TTDiag] clearToken: lock released
2026-04-18T21:07:21.611 [TTDiag] clearToken: calling cleanupBuffer
2026-04-18T21:07:21.611 [TTDiag] cleanupBuffer: enter
2026-04-18T21:07:21.611 [TTDiag] cleanupBuffer: before lock_guard(bufferMutex_)   
2026-04-18T21:07:21.611 [TTDiag] cleanupBuffer: lock acquired, hasOnComplete=0    
2026-04-18T21:07:21.611 [TTDiag] cleanupBuffer: releasing lock
2026-04-18T21:07:21.611 [TTDiag] cleanupBuffer: lock released
2026-04-18T21:07:21.611 [TTDiag] cleanupBuffer: exit
2026-04-18T21:07:21.611 [TTDiag] clearToken: cleanupBuffer returned, exit
2026-04-18T21:07:21.611 [TTTrack] htt: after tracker.handleKeyEvent
2026-04-18T21:07:21.612 [TTTrack] htt: KeyDown shouldAnalyze=1
2026-04-18T21:07:21.612 [TTTrack] htt: KeyDown shouldExecute=0
2026-04-18T21:07:21.712 [HookDiag] LowLevelKeyboardProc: vk=13 keyDown=0 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:21.712 [StageDiag] > entry vk=13 keyDown=0
2026-04-18T21:07:21.712 [StageDiag] > drainPendingReset vk=13 keyDown=0
2026-04-18T21:07:21.712 [StageDiag] > shouldBlockAllFeatures vk=13 keyDown=0      
2026-04-18T21:07:21.712 [StageDiag] > executePendingReplacementIfAny vk=13 keyDown=0
2026-04-18T21:07:21.712 [StageDiag] > hotkeyManager.processKeyEvent vk=13 keyDown=0
2026-04-18T21:07:21.712 [StageDiag] > getCurrentLayout vk=13 keyDown=0
2026-04-18T21:07:21.713 [StageDiag] > isAwaitingBuffer vk=13 keyDown=0
2026-04-18T21:07:21.713 [HookDiag] KeyUp vk=13 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=1
2026-04-18T21:07:21.713 [StageDiag] > hotkeyDefs->snapshot vk=13 keyDown=0        
2026-04-18T21:07:21.713 [StageDiag] > handlePromptHotkey vk=13 keyDown=0
2026-04-18T21:07:21.713 [StageDiag] > handleAddWordHotkey vk=13 keyDown=0
2026-04-18T21:07:21.713 [StageDiag] > handleCaseSwitchHotkey vk=13 keyDown=0      
2026-04-18T21:07:21.713 [StageDiag] > handleTranslationHotkey vk=13 keyDown=0     
2026-04-18T21:07:21.713 [StageDiag] > handleLayoutSwitchCombo vk=13 keyDown=0     
2026-04-18T21:07:21.713 [StageDiag] > handleListContinuation vk=13 keyDown=0      
2026-04-18T21:07:21.713 [StageDiag] > handleTokenTracking vk=13 keyDown=0
2026-04-18T21:07:21.713 [TTTrack] htt: enter vk=13 keyDown=0
2026-04-18T21:07:21.713 [TTTrack] htt: after modifier check
2026-04-18T21:07:21.714 [TTTrack] htt: KeyUp branch, checking cachedSettings      
2026-04-18T21:07:21.714 [TTTrack] htt: KeyUp autoReplEnabled=1 isProcessing=0     
2026-04-18T21:07:21.714 [TTTrack] htt: KeyUp postRepl=0
2026-04-18T21:07:21.714 [TTTrack] htt: KeyUp hasPlannedTargetLayout=0
2026-04-18T21:07:21.714 [TTTrack] htt: KeyUp branch returning false
2026-04-18T21:07:31.264 [HookDiag] LowLevelKeyboardProc: vk=164 keyDown=1 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:31.264 [StageDiag] > entry vk=164 keyDown=1
2026-04-18T21:07:31.265 [StageDiag] > drainPendingReset vk=164 keyDown=1
2026-04-18T21:07:31.265 [StageDiag] > shouldBlockAllFeatures vk=164 keyDown=1     
2026-04-18T21:07:31.265 [StageDiag] > executePendingReplacementIfAny vk=164 keyDown=1
2026-04-18T21:07:31.265 [StageDiag] > hotkeyManager.processKeyEvent vk=164 keyDown=1
2026-04-18T21:07:31.265 [StageDiag] > getCurrentLayout vk=164 keyDown=1
2026-04-18T21:07:31.265 [StageDiag] > handleKeyDownWithCapture vk=164 keyDown=1   
2026-04-18T21:07:31.265 [StageDiag] > isAwaitingBuffer vk=164 keyDown=1
2026-04-18T21:07:31.265 [HookDiag] KeyDown vk=164 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=1
2026-04-18T21:07:31.265 [StageDiag] > hotkeyDefs->snapshot vk=164 keyDown=1       
2026-04-18T21:07:31.266 [StageDiag] > handlePromptHotkey vk=164 keyDown=1
2026-04-18T21:07:31.266 [StageDiag] > handleAddWordHotkey vk=164 keyDown=1        
2026-04-18T21:07:31.266 [StageDiag] > handleCaseSwitchHotkey vk=164 keyDown=1     
2026-04-18T21:07:31.266 [StageDiag] > handleTranslationHotkey vk=164 keyDown=1    
2026-04-18T21:07:31.266 [StageDiag] > handleLayoutSwitchCombo vk=164 keyDown=1    
2026-04-18T21:07:31.266 [StageDiag] > handleListContinuation vk=164 keyDown=1     
2026-04-18T21:07:31.266 [StageDiag] > handleTokenTracking vk=164 keyDown=1        
2026-04-18T21:07:31.266 [TTTrack] htt: enter vk=164 keyDown=1
2026-04-18T21:07:31.361 [HookDiag] LowLevelKeyboardProc: vk=9 keyDown=1 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:31.361 [StageDiag] > entry vk=9 keyDown=1
2026-04-18T21:07:31.361 [StageDiag] > drainPendingReset vk=9 keyDown=1
2026-04-18T21:07:31.361 [StageDiag] > shouldBlockAllFeatures vk=9 keyDown=1       
2026-04-18T21:07:31.362 [StageDiag] > executePendingReplacementIfAny vk=9 keyDown=1
2026-04-18T21:07:31.362 [StageDiag] > hotkeyManager.processKeyEvent vk=9 keyDown=1
2026-04-18T21:07:31.362 [StageDiag] > getCurrentLayout vk=9 keyDown=1
2026-04-18T21:07:31.362 [StageDiag] > handleKeyDownWithCapture vk=9 keyDown=1     
2026-04-18T21:07:31.362 [StageDiag] > isAwaitingBuffer vk=9 keyDown=1
2026-04-18T21:07:31.362 [HookDiag] KeyDown vk=9 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=1
2026-04-18T21:07:31.362 [StageDiag] > hotkeyDefs->snapshot vk=9 keyDown=1
2026-04-18T21:07:31.362 [StageDiag] > handlePromptHotkey vk=9 keyDown=1
2026-04-18T21:07:31.362 [StageDiag] > handleAddWordHotkey vk=9 keyDown=1
2026-04-18T21:07:31.362 [StageDiag] > handleCaseSwitchHotkey vk=9 keyDown=1       
2026-04-18T21:07:31.362 [StageDiag] > handleTranslationHotkey vk=9 keyDown=1      
2026-04-18T21:07:31.362 [StageDiag] > handleLayoutSwitchCombo vk=9 keyDown=1      
2026-04-18T21:07:31.363 [StageDiag] > handleListContinuation vk=9 keyDown=1       
2026-04-18T21:07:31.363 [StageDiag] > handleTokenTracking vk=9 keyDown=1
2026-04-18T21:07:31.363 [TTTrack] htt: enter vk=9 keyDown=1
2026-04-18T21:07:31.363 [TTTrack] htt: after modifier check
2026-04-18T21:07:31.363 [TTTrack] htt: KeyDown branch past initial block
2026-04-18T21:07:31.363 [TTTrack] htt: before tracker.handleKeyEvent
2026-04-18T21:07:31.363 [TTDiag] clearToken: enter
2026-04-18T21:07:31.363 [TTDiag] clearToken: before lock_guard(tokenMutex_)       
2026-04-18T21:07:31.363 [TTDiag] clearToken: lock acquired
2026-04-18T21:07:31.363 [TTDiag] clearToken: state cleared, releasing lock        
2026-04-18T21:07:31.363 [TTDiag] clearToken: lock released
2026-04-18T21:07:31.363 [TTDiag] clearToken: calling cleanupBuffer
2026-04-18T21:07:31.363 [TTDiag] cleanupBuffer: enter
2026-04-18T21:07:31.363 [TTDiag] cleanupBuffer: before lock_guard(bufferMutex_)   
2026-04-18T21:07:31.364 [TTDiag] cleanupBuffer: lock acquired, hasOnComplete=0    
2026-04-18T21:07:31.364 [TTDiag] cleanupBuffer: releasing lock
2026-04-18T21:07:31.364 [TTDiag] cleanupBuffer: lock released
2026-04-18T21:07:31.364 [TTDiag] cleanupBuffer: exit
2026-04-18T21:07:31.364 [TTDiag] clearToken: cleanupBuffer returned, exit
2026-04-18T21:07:31.364 [TTTrack] htt: after tracker.handleKeyEvent
2026-04-18T21:07:31.364 [TTTrack] htt: KeyDown shouldAnalyze=0
2026-04-18T21:07:31.367 [ExclusionService] ✅ App ALLOWED: C:\Windows\explorer.exe
2026-04-18T21:07:31.384 [ExclusionService] ✅ App ALLOWED: C:\Windows\explorer.exe
2026-04-18T21:07:31.386 [WinFocusMonitor] computeIsSecureField: queryMsaaProtected == 0
2026-04-18T21:07:31.387 [WinFocusMonitor] workerMain: hwnd=0000000000880BC8 idObject=-4 idChild=0 -> secure=0
2026-04-18T21:07:31.405 [HookDiag] LowLevelKeyboardProc: vk=164 keyDown=0 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:31.405 [StageDiag] > entry vk=164 keyDown=0
2026-04-18T21:07:31.405 [StageDiag] > drainPendingReset vk=164 keyDown=0
2026-04-18T21:07:31.405 [TTDiag] drainPendingReset -> clearToken (source=focus_change)
2026-04-18T21:07:31.406 [TTDiag] clearToken: enter
2026-04-18T21:07:31.406 [TTDiag] clearToken: before lock_guard(tokenMutex_)       
2026-04-18T21:07:31.406 [TTDiag] clearToken: lock acquired
2026-04-18T21:07:31.406 [TTDiag] clearToken: state cleared, releasing lock        
2026-04-18T21:07:31.406 [TTDiag] clearToken: lock released
2026-04-18T21:07:31.406 [TTDiag] clearToken: calling cleanupBuffer
2026-04-18T21:07:31.406 [TTDiag] cleanupBuffer: enter
2026-04-18T21:07:31.406 [TTDiag] cleanupBuffer: before lock_guard(bufferMutex_)   
2026-04-18T21:07:31.407 [TTDiag] cleanupBuffer: lock acquired, hasOnComplete=0    
2026-04-18T21:07:31.407 [TTDiag] cleanupBuffer: releasing lock
2026-04-18T21:07:31.407 [TTDiag] cleanupBuffer: lock released
2026-04-18T21:07:31.407 [TTDiag] cleanupBuffer: exit
2026-04-18T21:07:31.407 [TTDiag] clearToken: cleanupBuffer returned, exit
2026-04-18T21:07:31.407 [TTDiag] drainPendingReset -> clearToken RETURNED
2026-04-18T21:07:31.407 [StageDiag] > shouldBlockAllFeatures vk=164 keyDown=0     
2026-04-18T21:07:31.407 [StageDiag] > executePendingReplacementIfAny vk=164 keyDown=0
2026-04-18T21:07:31.407 [StageDiag] > hotkeyManager.processKeyEvent vk=164 keyDown=0
2026-04-18T21:07:31.407 [StageDiag] > getCurrentLayout vk=164 keyDown=0
2026-04-18T21:07:31.408 [StageDiag] > isAwaitingBuffer vk=164 keyDown=0
2026-04-18T21:07:31.408 [HookDiag] KeyUp vk=164 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=1
2026-04-18T21:07:31.408 [StageDiag] > hotkeyDefs->snapshot vk=164 keyDown=0       
2026-04-18T21:07:31.408 [StageDiag] > handlePromptHotkey vk=164 keyDown=0
2026-04-18T21:07:31.408 [StageDiag] > handleAddWordHotkey vk=164 keyDown=0        
2026-04-18T21:07:31.408 [StageDiag] > handleCaseSwitchHotkey vk=164 keyDown=0     
2026-04-18T21:07:31.408 [StageDiag] > handleTranslationHotkey vk=164 keyDown=0    
2026-04-18T21:07:31.408 [StageDiag] > handleLayoutSwitchCombo vk=164 keyDown=0    
2026-04-18T21:07:31.408 [StageDiag] > handleListContinuation vk=164 keyDown=0     
2026-04-18T21:07:31.408 [StageDiag] > handleTokenTracking vk=164 keyDown=0        
2026-04-18T21:07:31.409 [TTTrack] htt: enter vk=164 keyDown=0
2026-04-18T21:07:31.436 [ExclusionService] ✅ App ALLOWED: C:\Windows\explorer.exe
2026-04-18T21:07:31.441 [ExclusionService] ✅ App ALLOWED: C:\Users\Сергей\AppData\Local\Programs\cursor\Cursor.exe
2026-04-18T21:07:31.466 [WinFocusMonitor] computeIsSecureField: queryMsaaProtected == 0
2026-04-18T21:07:31.466 [WinFocusMonitor] workerMain: hwnd=0000000000120874 idObject=-4 idChild=0 -> secure=0
2026-04-18T21:07:31.489 [WinFocusMonitor] computeIsSecureField: queryMsaaProtected == 0
2026-04-18T21:07:31.490 [WinFocusMonitor] workerMain: hwnd=00000000003B0640 idObject=-4 idChild=-1154944 -> secure=0
2026-04-18T21:07:31.496 [HookDiag] LowLevelKeyboardProc: vk=9 keyDown=0 injected=0 extraInfo=0 ctrl=0 shouldTrack=1 skipInjected=0
2026-04-18T21:07:31.497 [StageDiag] > entry vk=9 keyDown=0
2026-04-18T21:07:31.497 [StageDiag] > drainPendingReset vk=9 keyDown=0
2026-04-18T21:07:31.497 [TTDiag] drainPendingReset -> clearToken (source=focus_change)
2026-04-18T21:07:31.497 [TTDiag] clearToken: enter
2026-04-18T21:07:31.497 [TTDiag] clearToken: before lock_guard(tokenMutex_)       
2026-04-18T21:07:31.497 [TTDiag] clearToken: lock acquired
2026-04-18T21:07:31.498 [TTDiag] clearToken: state cleared, releasing lock        
2026-04-18T21:07:31.498 [TTDiag] clearToken: lock released
2026-04-18T21:07:31.498 [TTDiag] clearToken: calling cleanupBuffer
2026-04-18T21:07:31.498 [TTDiag] cleanupBuffer: enter
2026-04-18T21:07:31.498 [TTDiag] cleanupBuffer: before lock_guard(bufferMutex_)   
2026-04-18T21:07:31.498 [TTDiag] cleanupBuffer: lock acquired, hasOnComplete=0    
2026-04-18T21:07:31.498 [TTDiag] cleanupBuffer: releasing lock
2026-04-18T21:07:31.498 [TTDiag] cleanupBuffer: lock released
2026-04-18T21:07:31.498 [TTDiag] cleanupBuffer: exit
2026-04-18T21:07:31.499 [TTDiag] clearToken: cleanupBuffer returned, exit
2026-04-18T21:07:31.499 [TTDiag] drainPendingReset -> clearToken RETURNED
2026-04-18T21:07:31.499 [StageDiag] > shouldBlockAllFeatures vk=9 keyDown=0       
2026-04-18T21:07:31.499 [StageDiag] > executePendingReplacementIfAny vk=9 keyDown=0
2026-04-18T21:07:31.499 [StageDiag] > hotkeyManager.processKeyEvent vk=9 keyDown=0
2026-04-18T21:07:31.499 [StageDiag] > getCurrentLayout vk=9 keyDown=0
2026-04-18T21:07:31.499 [StageDiag] > isAwaitingBuffer vk=9 keyDown=0
2026-04-18T21:07:31.500 [HookDiag] KeyUp vk=9 ctrl=0 isProcessingHotkey=0 isReplacing=0 activeHotkeyVk=0 trackerEmpty=1
2026-04-18T21:07:31.500 [StageDiag] > hotkeyDefs->snapshot vk=9 keyDown=0
2026-04-18T21:07:31.500 [StageDiag] > handlePromptHotkey vk=9 keyDown=0
2026-04-18T21:07:31.501 [StageDiag] > handleAddWordHotkey vk=9 keyDown=0
2026-04-18T21:07:31.501 [StageDiag] > handleCaseSwitchHotkey vk=9 keyDown=0       
2026-04-18T21:07:31.501 [StageDiag] > handleTranslationHotkey vk=9 keyDown=0      
2026-04-18T21:07:31.501 [StageDiag] > handleLayoutSwitchCombo vk=9 keyDown=0      
2026-04-18T21:07:31.502 [StageDiag] > handleListContinuation vk=9 keyDown=0       
2026-04-18T21:07:31.502 [StageDiag] > handleTokenTracking vk=9 keyDown=0
2026-04-18T21:07:31.502 [TTTrack] htt: enter vk=9 keyDown=0
2026-04-18T21:07:31.503 [TTTrack] htt: after modifier check
2026-04-18T21:07:31.503 [TTTrack] htt: KeyUp branch, checking cachedSettings      
2026-04-18T21:07:31.504 [TTTrack] htt: KeyUp autoReplEnabled=1 isProcessing=0     
2026-04-18T21:07:31.506 [TTTrack] htt: KeyUp postRepl=0
2026-04-18T21:07:31.506 [TTTrack] htt: KeyUp hasPlannedTargetLayout=0
2026-04-18T21:07:31.506 [TTTrack] htt: KeyUp branch returning false
"@

function Compress-Logs {
    param([string]$text)
    
    if ([string]::IsNullOrWhiteSpace($text) -or $text.Trim() -eq "PASTE_YOUR_LOGS_HERE") { 
        return "Please paste your logs into `$rawLog variable." 
    }
    
    # 0. Strip leading zeros
    $text = [regex]::Replace($text, '\b0{3,}(?=[1-9A-Fa-f][0-9A-Fa-f]*\b)', '')
    $text = [regex]::Replace($text, '\b0{3,}(?=0\b)', '')
    $text = [regex]::Replace($text, '(?<=\b0x)0{3,}(?=[1-9A-Fa-f][0-9A-Fa-f]*\b)', '')
    $text = [regex]::Replace($text, '(?<=\b0x)0{3,}(?=0\b)', '')
    
    $legend = New-Object System.Collections.ArrayList
    $script:varIdx = 0
    $base62 = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    function Get-NextToken {
        $num = $script:varIdx
        $script:varIdx++
        if ($num -eq 0) { return "#0" }
        $res = ""
        $n = $num
        while ($n -gt 0) {
            $rem = $n % 62
            $res = $base62[$rem] + $res
            $n = [math]::Floor($n / 62)
        }
        return "#" + $res
    }
    
    # 1. Timestamp Prefix
    $tsMatches = [regex]::Matches($text, '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:')
    if ($tsMatches.Count -gt 0) {
        $tsCounts = @{}
        foreach ($m in $tsMatches) { $tsCounts[$m.Value]++ }
        $bestTs = ($tsCounts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 1).Name
        $text = $text.Replace($bestTs, '#T')
        [void]$legend.Add("#T = $bestTs")
    }
    
    # 2. Components [XXX]
    $compMatches = [regex]::Matches($text, '\[[A-Za-z0-9_-]+\]')
    $compCounts = @{}
    foreach ($m in $compMatches) { $compCounts[$m.Value]++ }
    foreach ($kv in ($compCounts.GetEnumerator() | Sort-Object Value -Descending)) {
        if ($kv.Value -gt 1) {
            $token = Get-NextToken
            $text = $text.Replace($kv.Name, $token)
            [void]$legend.Add("$token = $($kv.Name)")
        }
    }
    
    # 3. Common Keys
    $keyMatches = [regex]::Matches($text, '\b[A-Za-z0-9_]+={1,2}')
    $keyCounts = @{}
    foreach ($m in $keyMatches) { $keyCounts[$m.Value]++ }
    foreach ($kv in ($keyCounts.GetEnumerator() | Sort-Object Value -Descending)) {
        if ($kv.Value -gt 1) {
            $token = Get-NextToken
            $text = $text.Replace($kv.Name, $token)
            [void]$legend.Add("$token = $($kv.Name)")
        }
    }
    
    # We'll use C# for the heavy lifting
    $csharpCode = @"
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Text;

public class FastCompressor {
    public static string RunBPE(string text, int maxIterations, bool isMeta, ref int varIdx, ArrayList legend) {
        string base62 = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        Regex metaSplit = new Regex(@"(#(?:T|[0-9a-zA-Z]+)|![0-9]+)");
        Regex normalSplit = new Regex(@"(#(?:T|[0-9a-zA-Z]+))");
        Regex metaTokenizer = new Regex(@"#[a-zA-Z0-9]+|[A-Za-z0-9_]+|[^A-Za-z0-9_#]+");
        Regex normalTokenizer = new Regex(@"[A-Za-z0-9_]+|[^A-Za-z0-9_]+");
        
        for (int iter = 0; iter < maxIterations; iter++) {
            var substringCounts = new Dictionary<string, int>();
            string[] parts;
            if (isMeta) {
                // For Meta-BPE we split by newlines to avoid matching across lines
                parts = text.Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.None);
            } else {
                parts = normalSplit.Split(text);
            }
            
            Regex tokenizer = isMeta ? metaTokenizer : normalTokenizer;
            
            foreach (string part in parts) {
                if (string.IsNullOrEmpty(part)) continue;
                if (!isMeta && normalSplit.IsMatch(part) && part == normalSplit.Match(part).Value) continue;
                
                MatchCollection matches = tokenizer.Matches(part);
                int len = matches.Count;
                string[] tokens = new string[len];
                for (int i = 0; i < len; i++) tokens[i] = matches[i].Value;
                
                int maxN = Math.Min(isMeta ? 15 : 20, len);
                for (int n = 2; n <= maxN; n++) {
                    for (int i = 0; i <= len - n; i++) {
                        StringBuilder sb = new StringBuilder();
                        for(int j=0; j<n; j++) sb.Append(tokens[i+j]);
                        string phrase = sb.ToString();
                        
                        if (phrase.Contains("\n") || phrase.Contains("\r")) continue;
                        if (phrase.Trim().Length < (isMeta ? 5 : 4)) continue;
                        if (isMeta && !phrase.Contains("#")) continue;
                        
                        if (substringCounts.ContainsKey(phrase)) {
                            substringCounts[phrase]++;
                        } else {
                            substringCounts[phrase] = 1;
                        }
                    }
                }
            }
            
            string bestPhrase = null;
            int bestSavings = 0;
            
            foreach (var kv in substringCounts) {
                if (kv.Value > 1) {
                    int tagLen = isMeta ? (varIdx.ToString().Length + 1) : (varIdx > 61 ? 3 : 2);
                    int savings = kv.Value * (kv.Key.Length - tagLen) - (tagLen + 3 + kv.Key.Length);
                    if (savings > bestSavings) {
                        bestSavings = savings;
                        bestPhrase = kv.Key;
                    }
                }
            }
            
            if (bestSavings < 5) break;
            
            string token = "";
            if (isMeta) {
                token = "!" + varIdx;
                varIdx++;
            } else {
                int num = varIdx++;
                if (num == 0) token = "#0";
                else {
                    string res = "";
                    int n = num;
                    while (n > 0) {
                        res = base62[n % 62] + res;
                        n /= 62;
                    }
                    token = "#" + res;
                }
            }
            
            string escaped = Regex.Escape(bestPhrase);
            if (Regex.IsMatch(bestPhrase[0].ToString(), @"^[A-Za-z0-9_]$")) escaped = @"(?<![A-Za-z0-9_])" + escaped;
            if (Regex.IsMatch(bestPhrase[bestPhrase.Length-1].ToString(), @"^[A-Za-z0-9_]$")) escaped = escaped + @"(?![A-Za-z0-9_])";
            
            if (isMeta) {
                text = Regex.Replace(text, escaped, token);
            } else {
                StringBuilder newText = new StringBuilder();
                string[] replaceParts = normalSplit.Split(text);
                foreach (string part in replaceParts) {
                    if (normalSplit.IsMatch(part) && part == normalSplit.Match(part).Value) {
                        newText.Append(part);
                    } else {
                        newText.Append(Regex.Replace(part, escaped, token));
                    }
                }
                text = newText.ToString();
            }
            
            string displayPhrase = bestPhrase;
            if (displayPhrase.StartsWith(" ") || displayPhrase.EndsWith(" ")) displayPhrase = "'" + displayPhrase + "'";
            legend.Add(token + " = " + displayPhrase);
        }
        return text;
    }
}
"@
    
    try {
        Add-Type -TypeDefinition $csharpCode -Language CSharp -ErrorAction SilentlyContinue
    } catch {}
    
    # 4. BPE
    $text = [FastCompressor]::RunBPE($text, 100, $false, [ref]$script:varIdx, $legend)
    
    # 4.5 Meta-BPE
    $script:metaIdx = 1
    $text = [FastCompressor]::RunBPE($text, 100, $true, [ref]$script:metaIdx, $legend)
    
        # 5. MACRO TEMPLATING (Option 1)
        $lines = $text -split "`r?`n"
        $templates = @{}
        
        for ($i = 0; $i -lt $lines.Count; $i++) {
            $lines[$i] = $lines[$i].TrimEnd()
            $line = $lines[$i]
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            
            # Find all tags in the line to use as potential variables
            $matches = [regex]::Matches($line, '(#(T|[0-9a-zA-Z]+)|![0-9]+)')
            foreach ($m in $matches) {
                # Create a template by replacing this specific tag with @
                $template = $line.Substring(0, $m.Index) + "@" + $line.Substring($m.Index + $m.Length)
                
                # Lowered length limit to 5 to catch short repeating structures like !26@!3
                if ($template.Length -lt 5) { continue }
                
                if (-not $templates.ContainsKey($template)) {
                    $templates[$template] = New-Object System.Collections.ArrayList
                }
                
                $matchData = New-Object PSObject -Property @{
                    LineIdx = $i
                    Var = $m.Value
                }
                [void]$templates[$template].Add($matchData)
            }
        }
        
        # Evaluate templates
        $templateScores = @{}
        foreach ($kv in $templates.GetEnumerator()) {
            $count = $kv.Value.Count
            # Calculate approximate savings
            # Savings = (Count - 1) * TemplateLength - 4 * Count - 5
            $savings = ($count - 1) * $kv.Name.Length - 4 * $count - 5
            
            # Allow if it saves space OR if it appears frequently (>= 4 times) for visual structure
            if ($savings -gt 0 -or $count -ge 4) {
                # Score prioritizes frequency and length
                $templateScores[$kv.Name] = $count * $kv.Name.Length
            }
        }
    
    $lineTemplated = New-Object bool[] $lines.Count
    $macroIdx = 1
    
    foreach ($kv in ($templateScores.GetEnumerator() | Sort-Object Value -Descending)) {
        $template = $kv.Name
        $matches = $templates[$template]
        
        # Filter matches that haven't been templated yet
        $validMatches = New-Object System.Collections.ArrayList
        foreach ($m in $matches) {
            if (-not $lineTemplated[$m.LineIdx]) {
                [void]$validMatches.Add($m)
            }
        }
        
        if ($validMatches.Count -gt 1) {
            $macroTag = "&$macroIdx"
            $macroIdx++
            [void]$legend.Add("$macroTag = $template")
            
            foreach ($m in $validMatches) {
                # Format: &1:C (remove the '#' or '!' from the variable)
                $varClean = $m.Var -replace '^[#!]', ''
                $lines[$m.LineIdx] = "$($macroTag):$varClean"
                $lineTemplated[$m.LineIdx] = $true
            }
        }
    }
    
    # 6. Intra-line deduplication
    $finalLines = New-Object System.Collections.ArrayList
    $dupCount = 0
    $lastLine = ""
    
    foreach ($line in $lines) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        
        $lineNoTime = $line -replace '^#T\d{2}\.\d{3}\s*', ''
        if ($lineNoTime -eq $lastLine -and $lineNoTime -ne "") {
            $dupCount++
            continue
        }
        
        if ($dupCount -gt 0) {
            [void]$finalLines.Add("    ... (repeated $dupCount more times)")
            $dupCount = 0
        }
        
        [void]$finalLines.Add($line)
        $lastLine = $lineNoTime
    }
    if ($dupCount -gt 0) {
        [void]$finalLines.Add("    ... (repeated $dupCount more times)")
    }
    
    $result = "--- LEGEND ---`n"
    $result += ($legend -join "`n")
    $result += "`n`n--- LOGS ---`n"
    $result += ($finalLines -join "`n")
    
    return $result
}

$compressed = Compress-Logs -text $rawLog
if ($compressed -match "Please paste your logs") {
    Write-Host $compressed -ForegroundColor Yellow
} else {
    $compressed | Out-File "c:\dev\KeyRay\.cursor\scripts\test-macro.txt" -Encoding utf8
    Write-Host "Original length: $($rawLog.Length)"
    Write-Host "Compressed length: $($compressed.Length)"
    Write-Host "Compression: $([math]::Round((1 - $compressed.Length / $rawLog.Length) * 100, 1))%"
    Write-Host "Output saved to test-macro.txt" -ForegroundColor Green
}
