(!) **Disclaimer**: This was a quick one time project to see if I can easily make the original (https://github.com/Ahava/project-zomboid) work smoothly on my Synology NAS. I am not sure if I will update this ever, so feel free to fork and update as you wish.

# Project Zomboid server - Docker image

Docker version of the Project Zomboid steam server.

This fork contains modifications to make setup easier on Synology NAS servers. There are now UID and GID environmental variables where you can input your user's UID & GID from synology environment.

## How to use this image outside of a Synology NAS

**Don't**, see https://github.com/Ahava/project-zomboid and use that instead.

## How to use this image in Synology NAS

Clone this into any Synology folder of choice and run `docker build -t <name> project-zomboid` as root.

The image should automatically appear in your Docker app with the `name` you have given in the build command.

### Before starting

Follow https://drfrankenstein.co.uk/step-2-setting-up-a-restricted-docker-user-and-obtaining-ids/ to see how to set up a user with specific rights to a synology folder of your choice, and retrieve it's uid and gid. Note the values down for later.

### First setup

After first running the image, you will be able to edit some of the settings in the dialog that shows up.

#### Volume

Map the folders `/server-data` and `/server-files` to your Synology folder or it's subfolders.

The result should look like this, if I assume you have a volume 'docker' set up on your synology, and two subfolders for each of the container folders:
| File/Folder        | Mount path           | Read - only  |
| ------------- |:-------------:| -----:|
| docker/server-data     | /server-data |  |
| docker/server-files      | server-files      |    |

#### Port Settings

**Do not leave "local port" column on "Automatic" on any of the ports!**

You have to assign specific local port numbers, otherwise the ports can change every server restart in Synology. You can simply copy over the container port to the local port column, if you are sure the port number is not taken by something else already (usually isn't).

#### Environment

Here you can modify the environment variables. For Synology the most important ones are the **UID** and **GID** variables. Assign them the values of your Synology user.

The rest of the variables is up to you, see the Variables section if needed.

### After starting

Once you have run the docker for the first time, you can edit your config file in your mapped directory `/server-data/Server/$SERVER_NAME.ini`. When it's done, restart your server.

Some of options are not used in these two examples. Look below if you want to adjust your settings.

## Variables

Some variables are inherited from [ahava/linuxgsm](https://github.com/ahava/linuxgsm#variables).

- **UID** uid of Synology user (default: 1000)
- **GID** gid of Synology user (default: 1000)

- **STEAM_PORT_1** Steam port 1 (default: 8766)
- **STEAM_PORT_2** Steam port 2 (default: 8767)
- **RCON_PORT** RCON port (default: 27015)
- **RCON_PASSWORD** RCON password
- **SERVER_NAME** Name of your server (for db & ini file). **Warning:** don't use special characters or spaces.
- **SERVER_PASSWORD** Password of your server used to connect to it
- **SERVER_PUBLIC_NAME** Public name of your server
- **SERVER_PUBLIC_DESC** Public description of your server
- **SERVER_BRANCH** Name of the beta branch
- **SERVER_BETA_PASSWORD** Password for the beta branch
- **SERVER_MODS** Mod IDs list, separated by `;`
- **SERVER_WORKSHOP_ITEMS** Mod Steam Workshop IDs list, separated by `;`
- **ADMIN_PASSWORD** Admin password on your server
- **SERVER_PORT** Game server port
- **PLAYER_PORTS** Game ports to allow player to contact the server (by default : 16262-16272 to allow 10 players)

**STEAM_PORT_1**, **STEAM_PORT_2**, **RCON_PORT**, **RCON_PASSWORD**, **SERVER_PASSWORD**, **SERVER_PUBLIC_NAME**, **SERVER_PUBLIC_DESC** and **SERVER_PORT** are optional if you have access to the file `/server-data/Server/$SERVER_NAME.ini` where the values are.

**SERVER_BRANCH**, **SERVER_BETA_PASSWORD** and **ADMIN_PASSWORD** are not used if these values are set by **LGSM_COMMON_CONFIG**, **LGSM_COMMON_CONFIG_FILE**, **LGSM_SERVER_CONFIG** or **LGSM_SERVER_CONFIG_FILE**. These 4 variables from [ahava/linuxgsm](https://github.com/ahava/linuxgsm#variables) can override default settings from LinuxGSM\_: [\_default.cfg](https://github.com/GameServerManagers/LinuxGSM/blob/master/lgsm/config-default/config-lgsm/pzserver/_default.cfg).

## Volumes

- **/server-data** Data directory of the server. Contains db, config files...
- **/server-files** Application dir of the server.

## Expose

- **8766** Steam port 1 (udp)
- **8767** Steam port 2 (udp)
- **27015** RCON
- **16261** Game server (udp)
- **16262-16XXX** Clients slots

You need to bind X ports for client connection. (Example: If you have 10 slots, you need to put `-p 16262-16272:16262-16272`, if you have 100 slots, you need to put `-p 16262-16362:16262-16362`).

## Credits

https://hub.docker.com/r/afey/zomboid - the first inspiration to try to run such a thing on Synology

https://github.com/Ahava/project-zomboid - the fork from Cyrale's project from which this was forked

https://github.com/itzg/docker-minecraft-server for inspiration on the Synology specific additions
