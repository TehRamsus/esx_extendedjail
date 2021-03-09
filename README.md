What you can do with this script?

```
  You can jail players to prison or to lockup.
  Escape is possible! Your friends can try to release you, but police officers get alarm from it.
  Time is in minutes, not seconds.
  Optimized, used json.
  Full support to script and includes new updates.
  Permissions, can’t jail people without that you are admin or police.
  Possible to configure it yourself. Also possible to add your own webhooks (discord).
  Your sentence continues, when you join back to server.
  Cool animations.
```

Coming soon

```
  Prison job
  Anticheat, can’t judge all players in server :smiley:
  Drop down your own suggestions :slight_smile:
```

Requirements

```
  es_extended (version 1.2) or latest extendedmode.
  MHacking (optional) https://github.com/GHMatti/FiveM-Scripts/tree/master/mhacking
  Permissions
```

Permissions

```diff
- You don't have permissions to release script again, or leak it. 
- You have to mention my name and github, if you use this script on your server.
```

Police Menu
- You can add jail functions to police menu. It's use normal export, so it's really easy to install. Please complain code below this on your own scripts.
- Script rename is not needed, because then exports might not works.

Example use on esx_policejob. Add labels under "Citizen_interaction" section
```lua
{label = _U('Jail'),            value = 'jail_menu'},
{label = _U('Pjail'), value = 'pjail_menu'}
```

And add these below to the citizen_interaction ESX Menu
```lua
if action == 'jail_menu' then
	exports.esx_extendedjail:OpenJailMenu('prison')

elseif action == 'pjail_menu' then
	exports.esx_extendedjail:OpenJailMenu('pjail')
end
```

*Please use your own brains. Don't ask everything, if something not works on the first time.*

**• Owner: TehRamsus**
