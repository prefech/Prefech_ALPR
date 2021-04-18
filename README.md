# JD_Perms

<h4 align="center">
	<a href="https://github.com/JokeDevil/JD_Perms/releases/latest" title=""><img alt="Licence" src="https://img.shields.io/github/release/JokeDevil/JD_Perms.svg"></a>
	<a href="LICENSE" title=""><img alt="Licence" src="https://img.shields.io/github/license/JokeDevil/JD_Perms.svg"></a>
	<a href="https://discord.gg/m4BvmkG" title=""><img alt="Discord Status" src="https://discordapp.com/api/guilds/721339695199682611/widget.png"></a>
</h4>

<h4 align="center">
A state wide CCTV network monitors all vehicle activities 24/7. This way you will find your suspect in no time.
</h5>

### Requirements
- A Discord Server (Optional for Logs)
- FiveM FXServer

### V1.0.0
 - Add/remove permission groups to players with just a command.
    - No restarts required.

- Default group you can give is Admin (You can add as many as you need.)
- Default donator groups are VIP and VIP PLUS. (You can add as many as you need.)

For more info in adding groups you need to have knowledge about lua.
If you need support with adding groups you can join my discord: https://discord.gg/m4BvmkG

# Commands
- `/addperms [server_id/SteamHex] [group] [Note]`   This will add a permission group to a player
- `/delperms [server_id/SteamHex] [group]`          This will remove a permission group to a player
- `/perms [server_id]`                              This will show you the highest permission groups a player has.

# Download & Installation
1. Download the files
2. Put the JD_Perms folder in the server resource directory
3. Add this to your `server.cfg`
```
ensure JD_Perms
```
4. And to make the permissions load on serer restart you need to add this to your `server.cfg`
```
exec resources/JD_Perms/Permissions/JD_Perms.cfg
```
#### If you changed the path to the permission file make sure to add the right path:
```
exec <pathToPermissionsFile>/JD_Perms.cfg
```

### For more support join my discord: https://discord.gg/m4BvmkG