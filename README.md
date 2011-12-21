# Neav UI

This is a Github mirror of Neav UI on Wowinterface.

## Addons included

- !Beautycase
- !Colorz
- ActionButtonText
- OmniCC
- evl_RaidStatus
- nBuff
- nChat
- nCore
- nMainbar
- nMinimap
- nPlates
- nPower
- nTooltip
- oGlow
- oUF
- oUF_Neav
- oUF_NeavRaid

## Known issues

Known issues

- !Colorz cause an ui-block-error (not lua error!), because we change
  the value of a global table, ignore this or delete
  PowerBarColor['MANA'] = {r = 0/255, g = 0.55, b = 1} in the
  !Colorz.lua file.

