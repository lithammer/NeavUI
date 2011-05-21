# Neav UI

## Changes and additions

#### oUF_Neav:

- Different short value formatting (e.g. 1.1m instead of 1M 100K).
- Added Blizzards holy power, eclipse and soulshard bars, they fit the UI very nicely.
- Added boss frames

#### Raid frames:

- Now using the built-in heal prediction from oUF (kind of like healcomm).
- Healing indicators for all classes, as well as soulstone, focus magic and dark intent.
- Healing indicators have a "cooldown spiral" for duration.
- Mouse-over highlight (darkening the color when hovering over a frame).
- Disabled smooth updates for healing classes (can be enabled via `oUF_NeavConfig.lua`).
- Mana bars (enabled in `oUF_NeavConfig.lua`)

#### nMainbar:

- Option to have a vertical petbar (see `nMainbar_Config.lua`).

#### Misc:

- Healthbar on tooltips now have a textual representation on it as well.
- Added a copy chat function to nChat, use it by right-clicking on the chat tab. Also added a URL copy function.
- nRunes has been removed and replaced by nPower, which is essentially the same thing except with support for energy, focus and rage as well. The energy module also shows combo points in a similar fashion as nRunes showed runes.
- nTooltip: the target of the mouseover unit has now a raidtarget support.
- nTooltip has now a reaction coloring for the border and healthbar and itemquality border support!
- Skin module for external addons like omen, recount etc is now online, with some example code snippets.

## Known issues

- Sometimes, the quest area overlay on the world map gets blocked from showing if you open the map while in combat.
- !Colorz cause an ui-block-error (not lua error!), because we change the value of a global table, ignore this or delete `PowerBarColor['MANA'] = {r = 0/255, g = 0.55, b = 1}` in the `!Colorz.lua` file.

## Plans For The Future 

- nCore module for open all mails (and ignore mails with COD).
- Make nPower compact, add config file and put it on WoWI.

## Bugs?

## Credits

- ballagarba for updated this UI.
- Neav for creating this UI.
