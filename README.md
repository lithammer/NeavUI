# Neav UI

## Overview

### !Beautycase:

- Just a addon for create easy and cool border, does nothing by itself, but a lot of the addons in this ui pack need it

### !Colorz:

- This addon change the default manabar color to be more blue (not so extreme dark blue like the default manabarcolor) and a function for a better coloring of friendly/hostile/enemy units. This addon can cause some errors, just ignore this or remove it.

### nBuff:

- A lightweight buff addon. It modify the standard buffframe.

- Size and Scale of the Buff and Debuff button can be changed
- The space between the buffs can be changed
- Clean and simple look
- Rightclick to cancle buff works (because this is the standard bufframe)
- Debuff border are more visible
- Buff duration inside the buff icons

### nChat:

- A lightweight chat addon. It modify the standard chatframe.

- Modify the chattabs
- More choosable fontsizes
- Remove chatbuttons
- Whispertarget and URL Copy include
- Rightclick on the tab > CopyChat, ChatLog and CombatLog
- Better mousewheel scrolling + to bottom scroll button
- Shorter channel names
- More Channel stickies
- Editbox on the top of the chat
- Hyperlink mouseover
- Optional disable chatfade
- Optional outline font

### nCore:

- A addon with some tweaks I want..

- Alt+click to buy an stack of an Item (vendor)
- Simple coords on the worldmap
- Durability and helmet/cloak toggle button on the character frame
- Spell IDs on the tooltips
- Move the raidwarning some pixel to the top
- !Beautycase skin module for omen/recount etc.
- Change some client fonts
- Remove the pesky error frame (not enough energy etc.)
- Make the WatchFrame moveable

### nMainbar:

- My shorter blizzbar

- Hides Bag and MicroMenu buttons
- Skins the buttons
- Shapeshiftbar and Petbar is moveable
- Enable Mouseover bars
- ... and many more ;)

### nMinimap:

- A small Minimap addon

- Square minimap
- Hides all Minimap buttons
- Make some buttons simplier
- Drawer on the top or bottom of the minimap to see guild and friendlist
- Mouseover zonetext (hold shift when hover the minimap to prevent these)
- Mouseover instance difficulty text
- Minimap Clock: Addon and latency into on mouseover
- Minimap Clock: MicroMenu on leftclick
- Mousewheel zooming

### nPlates:

- A nameplate addon

- Add a new border to the nameplates
- Make some Layout changes
- Add mobhealth to the nameplates

### nPower:

- A simple powerbar with deathknight runes and combopoints

### nTooltip:

- A simple, fast and lightweight tooltip addon

- Player titles are hideable
- Healthbar inside the tooltip (default coloring, custom coloring or reaction coloring)
- Optional health text
- Optional tooltip target
- Optional pvp icons
- Optional unit role icon
- Optional Realm name abbreviating
- Optional itemquality border coloring
- Optional reaction border coloring
- Raidtarget icons for tooltip unit and its target

### oUF_Neav:

- oUF layout

- Look and feel of the standard unitframes
- Support Player, Pet, Target, TargetTarget, Focus, FocusTarget, Party, Boss and Arena units
- Support castbars for Player, Pet, Target and Focus
- High customizable
- oUF_Vengeance support
- oUF_SwingTimer support
- oUF_CombatFeedback support
- oUF_Smooth support


### oUF_NeavRaid:

- oUF layout

- Shows health deficit (if health is below 95%)
- Heal prediction support
- Healing indicators for all classes.
- Healing indicators have a "cooldown spiral" for duration.
- Debuff / Bufficon with Debuffcoloring and Timer
- Debuff / Bufffilter customizeable
- Mouse-over highlight (darkening the color when hovering over a frame).
- Optional Mana bars
- Abrev names with special character support
- Threat highlight
- Optional Threat text
- Optional Maintank icon
- Optional Afk and Offline timer
- Optional Role indicator
- Optional playertarget border
- oUF_Smooth support
- oUF_AuraWatch support
- oUF_SpellRange support
- Horizontal and vertical ortientation of the health or manabar
- added a /rm command for raidmarkers (topleft ot the screen)


## Known issues

- Sometimes, the quest area overlay on the world map gets blocked from showing if you open the map while in combat. This is a generally problem and blizzs fault.
- !Colorz cause an ui-block-error (not lua error!), because we change the value of a global table, ignore this or delete `PowerBarColor['MANA'] = {r = 0/255, g = 0.55, b = 1}` in the `!Colorz.lua` file.

## Plans For The Future 

- nCore module for open all mails (and ignore mails with COD).

## Bugs?
