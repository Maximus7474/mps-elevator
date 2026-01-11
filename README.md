# MPS-Elevator
> By [Maximus7474](https://github.com/Maximus7474)

If you like this resource please drop a star, it's always appreciated ~~and gives motivation to continue~~ (not anymore, thank the leeches and entitled server owners).
If you want to go the extra step and show gratitude you can consider a donation on KoFi ([ko-fi.com/maximus_prime](https://ko-fi.com/maximus_prime)).

  ![](https://img.shields.io/github/downloads/Maximus7474/mps-elevator/total?logo=github)
  ![](https://img.shields.io/github/v/release/Maximus7474/mps-elevator?logo=github)
  ![](https://img.shields.io/github/downloads/Maximus7474/mps-elevator/total?logo=github)

⚠️ If you are not planning on developping this script download the latest release.

- For any issues or feature requests please use the [issues tab](https://github.com/Maximus7474/mps-elevator/issues)
- [CFX Forum Post](https://forum.cfx.re/t/free-elevator-interface/5241372/1) - Don't expect support here

> Preview:

![image](https://github.com/Maximus7474/mps-elevator/assets/94017712/75fcdbda-4ba5-4935-862a-b84d222f5497)
![image](https://github.com/Maximus7474/mps-elevator/assets/94017712/75fcdbda-4ba5-4935-862a-b84d222f5497)

> Without access the panel doesn't allow the user to access the elevator, if he has access the light is then green and he can move around freely

![image](https://github.com/user-attachments/assets/74788f52-7e37-40be-a5a0-f199e2d590f4)

## Requirements:
- [ox_lib](https://github.com/overextended/ox_lib/releases)
- (optionnal) Framework:
  - [es_extended](https://github.com/esx-framework/esx_core/releases)
  - [ox_core](https://github.com/overextended/ox_core/releases)
  - [qbx_core](https://github.com/Qbox-project/qbx_core/releases)
  - For using job/group restricted elevators
- (optionnal)
  - [ox_target](https://github.com/overextended/ox_target/releases)
  - For target enable it in the config

## Configuration:
All configuration actions are available in the [config.lua file](./shared/config.lua).
To add more elevators copy the template and alter the values by respecting the structure, not respecting it will lead to errors and the resource not working properly.
- The floors will show in the same order as listed in the config file.

## Specifications:
- Maybe, read the code still need to update this stuff. As if someone really reads this
- Group limitations, Item limitations, one or both or none your choice

## Adding elevators
Do as you please, create a new server file to register them with `Elevator:new` or use the export.

```lua
local res = exports['mps-elevator']:NewElevator({
  id = 'weazel-plaza',
  name = 'Weazel Plaza',
  floors = {
    {
      name = 'Ground Floor',
      coords = vector4(-906.4411, -451.6770, 39.6053, 115.6468),
    },
    {
      name = 'Apartment',
      coords = vector4(-906.2990, -455.9241, 126.5344, 208.8212),
    },
  }
} --[[ @as ElevatorData ]])

-- or within server files

local res = Elevator:New({
  id = 'weazel-plaza',
  name = 'Weazel Plaza',
  floors = {
    {
      name = 'Ground Floor',
      coords = vector4(-906.4411, -451.6770, 39.6053, 115.6468),
    },
    {
      name = 'Apartment',
      coords = vector4(-906.2990, -455.9241, 126.5344, 208.8212),
    },
  }
} --[[ @as ElevatorData ]])
```

## FAQ:
Q: Why does my character/vehicle drop when changing floor
A: You copy pasted the raw coords from a character position, this is 0.98 distance units above the ground. Either add ` - 0.98` after the z coordinate or subtract it from it.

Q: I need help using this.
A: If this is too hard to use then you can either:
  * Create a suggestion for simplification (one that is **detailled** containing what is hard to grasp and especially **HOW** to improve it)
  * PR a change to simplify (explain **why** and **how** it helps the issue)
  * Want me to do it ? I'm kind enough to release stuff for free and open source, not like the rest of forum posts. Go buy one if you want support.

## Credits:
- [Project Error](https://github.com/project-error) for the react boilerplate [Github Repo](https://github.com/project-error/fivem-react-boilerplate-lua)
