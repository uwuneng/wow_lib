WelcomeHome = LibStub("AceAddon-3.0"):NewAddon("WelcomeHome", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("WelcomeHome")


local options = {
    name = "WelcomeHome",
    handler = WelcomeHome,
    type = "group",
    args = {
        msg = {
            type = "input",
            name = L["Message"],
            desc = L["The message to be displayed when you get home."],
            usage = L["<Your message>"],
            get = "GetMessage",
            set = "SetMessage",
        },
        showInChat = {
            type = "toggle",
            name = L["Show in Chat"],
            desc = L["Toggles the display of the message in the chat window."],
            get = "IsShowInChat",
            set = "ToggleShowInChat",
        },
        showOnScreen = {
            type = "toggle",
            name = L["Show on Screen"],
            desc = L["Toggles the display of the message on the screen."],
            get = "IsShowOnScreen",
            set = "ToggleShowOnScreen",
        },
    },
}

local defaults = {
    profile =  {
        message = L["Welcome Home!"],
        showInChat = false,
        showOnScreen = true,
    },
}

function WelcomeHome:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub("AceDB-3.0"):New("WelcomeHomeDB", defaults, true)

    LibStub("AceConfig-3.0"):RegisterOptionsTable("WelcomeHome", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WelcomeHome", "WelcomeHome")
    self:RegisterChatCommand("wh", "ChatCommand")
    self:RegisterChatCommand("welcomehome", "ChatCommand")
end

function WelcomeHome:OnEnable()
    -- Called when the addon is enabled
    self:RegisterEvent("ZONE_CHANGED")
end

function WelcomeHome:ZONE_CHANGED()
    if GetBindLocation() == GetSubZoneText() then
        if self.db.profile.showInChat then
            self:Print(self.db.profile.message)
        end

        if self.db.profile.showOnScreen then
            UIErrorsFrame:AddMessage(self.db.profile.message, 1.0, 1.0, 1.0, 5.0)
        end
    end
end

function WelcomeHome:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("wh", "WelcomeHome", input)
    end
end

function WelcomeHome:GetMessage(info)
    return self.db.profile.message
end

function WelcomeHome:SetMessage(info, newValue)
    self.db.profile.message = newValue
end

function WelcomeHome:IsShowInChat(info)
    return self.db.profile.showInChat
end

function WelcomeHome:ToggleShowInChat(info, value)
    self.db.profile.showInChat = value
end

function WelcomeHome:IsShowOnScreen(info)
    return self.db.profile.showOnScreen
end

function WelcomeHome:ToggleShowOnScreen(info, value)
    self.db.profile.showOnScreen = value
end