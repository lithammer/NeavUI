# Neav UI

This is the development repository for Neav UI on WoWInterface.

## Addons included

- !Beautycase
- !Colorz
- [evl\_RaidStatus](http://www.wowinterface.com/downloads/info15178-RaidStatus.html)
- nBuff
- nChat
- nCore
- nMainbar
- nMinimap
- nPower
- [nPlates](http://www.wowinterface.com/downloads/info24129-nPlates2.0.html)
- nTooltip
- [oUF](http://www.wowinterface.com/downloads/info9994-oUF.html)
- oUF\_Neav
- oUF\_NeavRaid

## Known issues

- !Colorz cause an ui-block-error (not lua error!), because we change
  the value of the global table, ignore this or delete
  `PowerBarColor['MANA'] = {r = 0/255, g = 0.55, b = 1}` in the
  `!Colorz.lua` file.

## Credits

- [Neav](https://github.com/Neav) for creating Neav UI.
- [Grimsbain](https://github.com/Grimsbain) for an updated version of
  [nPlates](https://github.com/Grimsbain/nPlates) and providing most fixes and
  updates for Legion. And also taking his time to address feature requests from
  the community.

## License

MIT
