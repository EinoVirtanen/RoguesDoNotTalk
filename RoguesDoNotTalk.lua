local function Say(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cffffd100[RoguesDoNotTalk]|r " .. msg)
end

local function SetChatDisabled(disabled)
    if not (C_SocialRestrictions and C_SocialRestrictions.SetChatDisabled) then
        return false
    end

    C_SocialRestrictions.SetChatDisabled(disabled)

    -- Syncs the chat frames and the checkbox in the options window
    if ChatConfigFrame_OnChatDisabledChanged then
        ChatConfigFrame_OnChatDisabledChanged(disabled)
    end
    return true
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    local _, class = UnitClass("player")

    -- Short delay so the chat frame is ready
    C_Timer.After(2, function()
        if class == "ROGUE" then
            -- Print first: once chat is disabled, you may not see the message
            Say("Chat is disabled because Rogues do not talk.")
            if not SetChatDisabled(true) then
                Say("C_SocialRestrictions.SetChatDisabled is not available on this client.")
            end
        else
            if SetChatDisabled(false) then
                Say("Chat is enabled.")
            else
                Say("C_SocialRestrictions.SetChatDisabled is not available on this client.")
            end
        end
    end)
end)

-- /rdnt : shows the current state
SLASH_RDNT1 = "/rdnt"
SlashCmdList["RDNT"] = function()
    if C_SocialRestrictions and C_SocialRestrictions.IsChatDisabled then
        Say("Chat disabled: " .. tostring(C_SocialRestrictions.IsChatDisabled()))
    else
        Say("C_SocialRestrictions.IsChatDisabled is not available on this client.")
    end
end