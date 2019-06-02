# magnet-handler #
PowerShell script to handle BT magnet links, and send them to a Transmission queue via the [RPC protocol specification](https://github.com/transmission/transmission/wiki/RPC-Protocol-Specification).

When registered as the handler for magnet: links, this script sends the file to the Transmission server using the `torrent-add` method. This is useful if your BT client is running on a different computer than your browser and you want to easily add items into its download queue.

## Installation ##
### The Script ###
* Put the .ps1 file somewhere
* Edit the values of the __$Root__ , __$User__ and __$Pass__ variables to point to your server running Transmission. These values are the same specified on the _config.json_ file in the server.
### Registering the handler ###
* Put the .reg file somewhere
* Modify the __HKEY_CLASSES_ROOT\\Magnet\\shell\\open\\command__ value with the path to your .ps1 file. Remember to escape your "\\"s.
* Merge the .reg

## Usage ##
* Click on a magnet link to start the download on the targeted server
* No further action is needed if everything is OK
* An error popup is shown if there is an error either during the communication with the server or in the creation of the download.
