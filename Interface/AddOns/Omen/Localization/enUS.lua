-- English localization file for enUS and enGB.
local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("Omen", "enUS", true)
if not L then return end

-- Main Omen window
L["<Unknown>"] = true
L["Omen Quick Menu"] = true
L["Use Focus Target"] = true
L["Test Mode"] = true
L["Open Config"] = true
L["Open Omen's configuration panel"] = true
L["Hide Omen"] = true
L["Name"] = true
L["Threat [%]"] = true
L["Threat"] = true
L["TPS"] = true
L["Toggle Focus"] = true
L["> Pull Aggro <"] = true

-- Warnings
L["|cffff0000Error:|r Omen cannot use shake warning if you have turned on nameplates at least once since logging in."] = true
L["Passed %s%% of %s's threat!"] = true

-- Config module titles
L["General Settings"] = true
L["Profiles"] = true
L["Slash Command"] = true

-- Config strings, general settings section
L["OMEN_DESC"] = "Omen is a lightweight threat meter that shows you the threat of mobs you are engaged in combat with. You can change how Omen looks and behaves, and configure different profiles for every of your characters."
L["Alpha"] = true
L["Controls the transparency of the main Omen window."] = true
L["Scale"] = true
L["Controls the scaling of the main Omen window."] = true
L["Frame Strata"] = true
L["Controls the frame strata of the main Omen window. Default: MEDIUM"] = true
L["Clamp To Screen"] = true
L["Controls whether the main Omen window can be dragged offscreen"] = true
L["Tells Omen to additionally check your 'focus' and 'focustarget' before your 'target' and 'targettarget' in that order for threat display."] = true
L["Tells Omen to enter Test Mode so that you can configure Omen's display much more easily."] = true
L["Collapse to show a minimum number of bars"] = true
L["Lock Omen"] = true
L["Locks Omen in place and prevents it from being dragged or resized."] = true
L["Show minimap button"] = true
L["Show the Omen minimap button"] = true
L["Ignore Player Pets"] = true
L["IGNORE_PLAYER_PETS_DESC"] = [[
Tells Omen to skip enemy player pets when determining which unit to display threat data on.

Player pets maintain a threat table when in |cffffff78Aggressive|r or |cffffff78Defensive|r mode and behave just like normal mobs, attacking the target with the highest threat. If the pet is instructed to attack a specific target, the pet still maintains the threat table, but sticks on the assigned target which by definition has 100% threat. Player pets can be taunted to force them to attack you.

However, player pets on |cffffff78Passive|r mode do not have a threat table, and taunt does not work on them. They only attack their assigned target when instructed and do so without any threat table.

When a player pet is instructed to |cffffff78Follow|r, the pet's threat table is wiped immediately and stops attacking, although it may immediately reacquire a target based on its Aggressive/Defensive mode.
]]
L["Click Through"] = true
L["Makes the Omen window non-interactive"] = true
L["Autocollapse"] = true
L["Autocollapse Options"] = true
L["Grow bars upwards"] = true
L["Hide Omen on 0 bars"] = true
L["Hide Omen entirely if it collapses to show 0 bars"] = true
L["Max bars to show"] = true
L["Max number of bars to show"] = true
L["Background Options"] = true
L["Background Texture"] = true
L["Texture to use for the frame's background"] = true
L["Border Texture"] = true
L["Texture to use for the frame's border"] = true
L["Background Color"] = true
L["Frame's background color"] = true
L["Border Color"] = true
L["Frame's border color"] = true
L["Tile Background"] = true
L["Tile the background texture"] = true
L["Background Tile Size"] = true
L["The size used to tile the background texture"] = true
L["Border Thickness"] = true
L["The thickness of the border"] = true
L["Bar Inset"] = true
L["Sets how far inside the frame the threat bars will display from the 4 borders of the frame"] = true

-- Config strings, title bar section
L["Title Bar Settings"] = true
L["Configure title bar settings."] = true
L["Show Title Bar"] = true
L["Show the Omen Title Bar"] = true
L["Title Bar Height"] = true
L["Height of the title bar. The minimum height allowed is twice the background border thickness."] = true
L["Title Text Options"] = true
L["The font that the title text will use"] = true
L["The outline that the title text will use"] = true
L["The color of the title text"] = true
L["Control the font size of the title text"] = true
L["Use Same Background"] = true
L["Use the same background settings for the title bar as the main window's background"] = true
L["Title Bar Background Options"] = true

-- Config strings, show when... section
L["Show When..."] = true
L["Show Omen when..."] = true
L["This section controls when Omen is automatically shown or hidden."] = true
L["Use Auto Show/Hide"] = true
L["Show Omen when any of the following are true"] = true
L["You have a pet"] = true
L["Show Omen when you have a pet out"] = true
L["You are alone"] = true
L["Show Omen when you are alone"] = true
L["You are in a party"] = true
L["Show Omen when you are in a 5-man party"] = true
L["You are in a raid"] = true
L["Show Omen when you are in a raid"] = true
L["However, hide Omen if any of the following are true (higher priority than the above)."] = true
L["You are resting"] = true
L["Turning this on will cause Omen to hide whenever you are in a city or inn."] = true
L["You are in a battleground"] = true
L["Turning this on will cause Omen to hide whenever you are in a battleground or arena."] = true
L["You are not in combat"] = true
L["Turning this on will cause Omen to hide whenever you are not in combat."] = true
L["AUTO_SHOW/HIDE_NOTE"] = "Note: If you manually toggle Omen to show or hide, it will remain shown or hidden regardless of Auto Show/Hide settings until you next zone, join or leave a party or raid, or change any Auto Show/Hide settings."

-- Config strings, show classes... section
L["Show Classes..."] = true
L["SHOW_CLASSES_DESC"] = "Show Omen threat bars for the following classes. The classes here refer to those people in your party/raid only with the exception of the 'Not In Party' option."
L["Show bars for these classes"] = true
L["DEATHKNIGHT"] = "Death Knight"
L["DRUID"] = "Druid"
L["HUNTER"] = "Hunter"
L["MAGE"] = "Mage"
L["PALADIN"] = "Paladin"
L["PET"] = "Pet"
L["PRIEST"] = "Priest"
L["ROGUE"] = "Rogue"
L["SHAMAN"] = "Shaman"
L["WARLOCK"] = "Warlock"
L["WARRIOR"] = "Warrior"
L["*Not in Party*"] = true

-- Config strings, bar settings section
L["Bar Settings"] = true
L["Configure bar settings."] = true
L["Animate Bars"] = true
L["Smoothly animate bar changes"] = true
L["Short Numbers"] = true
L["Display large numbers in Ks"] = true
L["Bar Texture"] = true
L["The texture that the bar will use"] = true
L["Bar Height"] = true
L["Height of each bar"] = true
L["Bar Spacing"] = true
L["Spacing between each bar"] = true
L["Show TPS"] = true
L["Show threat per second values"] = true
L["TPS Window"] = true
L["TPS_WINDOW_DESC"] = "The threat per second calculation is based on a real time sliding window of the last X seconds."
L["Show Threat Values"] = true
L["Show Threat %"] = true
L["Show Headings"] = true
L["Show column headings"] = true
L["Heading BG Color"] = true
L["Heading background color"] = true
L["Use 'My Bar' color"] = true
L["Use a different colored background for your threat bar in Omen"] = true
L["'My Bar' BG Color"] = true
L["The background color for your threat bar"] = true
L["Use Tank Bar color"] = true
L["Use a different colored background for the tank's threat bar in Omen"] = true
L["Tank Bar Color"] = true
L["The background color for your tank's threat bar"] = true
L["Show Pull Aggro Bar"] = true
L["Show a bar for the amount of threat you will need to reach in order to pull aggro."] = true
L["Pull Aggro Bar Color"] = true
L["The background color for your Pull Aggro bar"] = true
L["Use Class Colors"] = true
L["Use standard class colors for the background color of threat bars"] = true
L["Pet Bar Color"] = true
L["The background color for pets"] = true
L["Use !ClassColors"] = true
L["Use !ClassColors addon for class colors for the background color of threat bars"] = true
L["Temp Threat Bar Color"] = true
L["The background color for players under the effects of Fade, Mirror Image, glyphed Hand of Salvation, Tricks of the Trade and Misdirection"] = true
L["Bar BG Color"] = true
L["The background color for all threat bars"] = true
L["Always Show Self"] = true
L["Always show your threat bar on Omen (ignores class filter settings), showing your bar on the last row if necessary"] = true
L["Invert Bar/Text Colors"] = true
L["Switch the colors so that the bar background colors and the text colors are swapped."] = true
L["Bar Label Options"] = true
L["Font"] = true
L["The font that the labels will use"] = true
L["Font Size"] = true
L["Control the font size of the labels"] = true
L["Font Color"] = true
L["The color of the labels"] = true
L["Font Outline"] = true
L["The outline that the labels will use"] = true
L["None"] = true
L["Outline"] = true
L["Thick Outline"] = true

-- Config strings, slash command section
L["OMEN_SLASH_DESC"] = "These buttons execute the same functions as the ones in the slash command /omen"
L["Toggle Omen"] = true
L["Center Omen"] = true
L["Configure"] = true
L["Open the configuration dialog"] = true
L["Show Omen"] = true

-- Config strings, warning settings section
L["Warning Settings"] = true
L["OMEN_WARNINGS_DESC"] = "This section allows you to customize when and how Omen notifies you if you are about to pull aggro."
L["Enable Sound"] = true
L["Causes Omen to play a chosen sound effect"] = true
L["Enable Screen Flash"] = true
L["Causes the entire screen to flash red momentarily"] = true
L["Enable Screen Shake"] = true
L["Causes the entire game world to shake momentarily. This option only works if nameplates are turned off."] = true
L["Enable Warning Message"] = true
L["Print a message to screen when you accumulate too much threat"] = true
L["Warning Threshold %"] = true
L["Sound to play"] = true
L["Disable while tanking"] = true
local TOC = select(4, GetBuildInfo())
if TOC < 40000 then
L["DISABLE_WHILE_TANKING_DESC"] = "Do not give out any warnings if Defensive Stance, Bear Form, Righteous Fury or Frost Presence is active."
else
L["DISABLE_WHILE_TANKING_DESC"] = "Do not give out any warnings if Defensive Stance, Bear Form, Righteous Fury or Blood Presence is active."
end
L["Test warnings"] = true

-- Config strings, for Fubar
L["Click|r to toggle the Omen window"] = true
L["Right-click|r to open the options menu"] = true
L["FuBar Options"] = true
L["Attach to minimap"] = true
L["Hide minimap/FuBar icon"] = true
L["Show icon"] = true
L["Show text"] = true
L["Position"] = true
L["Left"] = true
L["Center"] = true
L["Right"] = true

-- FAQ
L["Help File"] = true
L["A collection of help pages"] = true
L["FAQ Part 1"] = true
L["FAQ Part 2"] = true
L["Frequently Asked Questions"] = true
L["Warrior"] = true

L["GENERAL_FAQ"] = [[
|cffffd200How is Omen3 different from Omen2?|r

Omen3 relies completely on the Blizzard threat API and threat events. It does not attempt to calculate or extrapolate threat unlike Omen2.

Omen2 used what we called the Threat-2.0 library. This library was responsible for monitoring the combat log, spellcasting, buffs, debuffs, stances, talents and gear modifiers for calculating each individuals threat. Threat was calculated based on what was known or approximated from observed behaviors. Many abilities such as knockbacks were just assumed (to be a 50% threat reduction) as they were mostly impossible to confirm.

The Threat-2.0 library also included addon communication to broadcast your threat to the rest of the raid as long as they were also using Threat-2.0. This data was then used to provide a raid wide display of threat information.

Since patch 3.0.2, Omen no longer does any of these things and the need for a threat library is no longer necessary. Omen3 uses Blizzard's new in-built threat monitor to obtain exact values of every members threat. This means Omen3 has no need for synchronisation of data, combat log parsing or guessing, resulting in a significant increase in performance with regards to network traffic, CPU time and memory used. The implementation of boss modules for specific threat events (such as Nightbane wiping threat on landing) are also no longer necessary.

Further benefits of this new implementation include the addition of NPC threat on a mob (eg, Human Kalecgos). However, there are some drawbacks; frequency of updates are much slower, threat details cannot be obtained unless somebody in your party/raid are targetting the mob and it is also not possible to obtain threat from a mob you are not in direct combat with.

|cffffd200How do I get rid of the 2 vertical gray lines down the middle?|r

Lock your Omen. Locking Omen will prevent it from being moved or resized, as well as prevent the columns from being resized. If you haven't realized it, the 2 vertical gray lines are column resizing handles.

|cffffd200How do I make Omen3 look like Omen2?|r

Change the both the Background Texture and Border Texture to Blizzard Tooltip, change the Background Color to black (by dragging the luminance bar to the bottom), and the Border Color to blue.

|cffffd200Why does no threat data show on a mob when I target it even though it is in combat?|r

The Blizzard threat API does not return threat data on any mob you are not in direct combat with. We suspect this is an effort on Blizzard's part to save network traffic.

|cffffd200Is there ANY way around this Blizzard limitation? Not being able to see my pet's threat before I attack has set me back to guessing.|r

There is no way around this limitation short of us doing the guessing for you (which is exactly how Omen2 did it).

The goal of Omen3 is to provide accurate threat data, we no longer intend to guess for you and in the process lower your FPS. Have some confidence in your pet/tank, or just wait 2 seconds before attacking and use a low damage spell such as Ice Lance so that you can get initial threat readings.
]]
L["GENERAL_FAQ2"] = [[
|cffffd200Can we get AoE mode back?|r

Again, this is not really possible without guessing threat values. Blizzard's threat API only allows us to query for threat data on units that somebody in the raid is targetting. This means that if there are 20 mobs and only 6 of them are targetted by the raid, there is no way to obtain accurate threat data on the other 14.

This is also extremely complicated to guess particularly for healing and buffing (threat gets divided by the number of mobs you are in combat with) because mobs that are under crowd control effects (sheep, banish, sap, etc) do not have their threat table modified and addons cannot reliably tell how many mobs you are in combat with. Omen2's guess was almost always wrong.

|cffffd200The tooltips on unit mouseover shows a threat % that does not match the threat % reported by Omen3. Why?|r

Blizzard's threat percentage is scaled to between 0% and 100%, so that you will always pull aggro at 100%. Omen reports the raw unscaled values which has pulling aggro percentages at 110% while in melee range and 130% otherwise.

By universal agreement, the primary target of a mob is called the tank and is defined to be at 100% threat.

|cffffd200The threat updates are slow...|r

Omen3 updates the threat values you see as often as Blizzard updates the threat values to us.

In fact, Blizzard updates them about once per second, which is much faster than what Omen2 used to sync updates. In Omen2, you only transmitted your threat to the rest of the raid once every 3 seconds (or 1.5s if you were a tank).

|cffffd200Where can I report bugs or give suggestions?|r

http://forums.wowace.com/showthread.php?t=14249

|cffffd200Who wrote Omen3?|r

Xinhuan (Blackrock/Barthilas US Alliance) did.

|cffffd200Do you accept Paypal donations?|r

Yes, send to xinhuan AT gmail DOT com.
]]
L["WARRIOR_FAQ"] = [[The following data is obtained from |cffffd200http://www.tankspot.com/forums/f200/39775-wow-3-0-threat-values.html|r on 2nd Oct 2008 (credits to Satrina). The numbers are for a level 80.

|cffffd200Modifiers|r
Battle Stance ________ x 80
Berserker Stance _____ x 80
Tactical Mastery _____ x 121/142/163
Defensive Stance _____ x 207.35

Note that in our original threat estimations (that we use now in WoW 2.0), we equated 1 damage to 1 threat, and used 1.495 to represent the stance+defiance multiplier. We see that Blizzard's method is to use the multiplier without decimals, so in 2.x it would've been x149 (maybe x149.5); it is x207 (maybe 207.3) in 3.0. I expect that this is to allow the transport of integer values instead of decimal values across the Internet for efficiency. It appears that threat values are multiplied by 207.35 at the server, then rounded.

If you still want to use the 1 damage = 1 threat method, the stance modifiers are 0.8 and 2.0735, etc.

|cffffd200Threat Values  (stance modifiers apply unless otherwise noted):|r
Battle Shout _________ 78 (split)
Cleave _______________ damage + 225 (split)
Commanding Shout _____ 80 (split)
Concussion Blow ______ damage only
Damage Shield ________ damage only
Demoralising Shout ___ 63 (split)
Devastate ____________ damage + 5% of AP *** Needs re-checking for 8982 **
Dodge/Parry/Block_____ 1 (in defensive stance with Improved Defensive Stance only)
Heroic Strike ________ damage + 259
Heroic Throw _________ 1.50 x damage
Rage Gain ____________ 5 (stance modifier is not applied)
Rend _________________ damage only
Revenge ______________ damage + 121
Shield Bash __________ 36
Shield Slam __________ damage + 770
Shockwave ____________ damage only
Slam _________________ damage + 140
Spell Reflect ________ damage only (only for spells aimed at you)
Social Aggro _________ 0
Sunder Armour ________ 345 + 5%AP
Thunder Clap _________ 1.85 x damage
Vigilance ____________ 10% of target's generated threat (stance modifier is not applied)

You do not gain threat for reflecting spells targetted at allies with Improved Spell Reflect. When you reflect a spell for an ally, your ally gains the threat for the damage dealt by the reflected spell.
]]

