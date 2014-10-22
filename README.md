# Neav UI

This is a development repository for Neav UI on WoWInterface.

## Addons included

- !Beautycase
- !Colorz
- [ActionButtonText](http://www.wowinterface.com/downloads/info11009-ActionButtonText.html) (heavily modified)
- [evl_RaidStatus](http://www.wowinterface.com/downloads/info15178-RaidStatus.html)
- nBuff
- nChat
- nCore
- nMainbar
- nMinimap
- nPlates
- nPower
- nTooltip
- [oUF](http://www.wowinterface.com/downloads/info9994-oUF.html)
- oUF_Neav
- oUF_NeavRaid

## Known issues

Known issues

- !Colorz cause an ui-block-error (not lua error!), because we change
  the value of the global table, ignore this or delete
  `PowerBarColor['MANA'] = {r = 0/255, g = 0.55, b = 1}` in the
  `!Colorz.lua` file.
