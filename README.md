# shamey-doctor

A free, open-source RedM script for doctors and reviving

## Features
- Supports 3 levels of doctor career
- NPC healers ("Nancy")
- Doctor alert and map blip when a player is downed
- Downed players see how far the nearest doctor is
- Doctors can use `/heal` or `/revive` commands
- Doctors can clock-in/clock-out and get paid
- Configurable (locations, labels, alert blip duration, career abilities, distances, "Nancy" price)
- Discord logging (via webhook)
- Organized & documented
- Performant

## Requirements
- VORP Framework
- [jo_libs](https://github.com/Jump-On-Studios/RedM-jo_libs)
- [shamey-core](https://github.com/ShameyWinehouse/shamey-core) (for checking jobs)

NOTE: This script is tightly integrated with the VORP Framework. Additionally, we were running a customized version of `vorp_metabolism`, which I can't publish at this time, so this script's crafting and item-usage features will likely **not work** out-of-the-box, which is why I left those features off of the above list.

## License & Support
This software was formerly proprietary to Rainbow Railroad Roleplay, but I am now releasing it free and open-source under GNU GPLv3. I cannot provide any support.