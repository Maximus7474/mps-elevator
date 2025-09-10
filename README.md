# 5M-Elevator
> By [Maximus7474](https://github.com/Maximus7474)

If you like this resource please drop a star, it's always appreciated and gives motivation to continue !

  ![](https://img.shields.io/github/downloads/Maximus7474/mps-elevator/total?logo=github)
  ![](https://img.shields.io/github/v/release/Maximus7474/mps-elevator?logo=github)

⚠️ If you are not planning on developping this script download the latest release.

- For any issues or feature requests please use the [issues tab](https://github.com/Maximus7474/mps-elevator/issues)
- [CFX Forum Post](https://forum.cfx.re/t/free-elevator-interface/5241372/1)

> Preview:

![image](https://github.com/Maximus7474/mps-elevator/assets/94017712/75fcdbda-4ba5-4935-862a-b84d222f5497)

> Without access the panel doesn't allow the user to access the elevator, if he has access the light is then green and he can move around freely

![image](https://github.com/user-attachments/assets/74788f52-7e37-40be-a5a0-f199e2d590f4)

## Requirements:
- [ox_lib](https://github.com/overextended/ox_lib/releases)
- (optionnal) [es_extended](https://github.com/esx-framework/esx_core/releases) or [ox_core](https://github.com/overextended/ox_core/releases) or [qbx_core](https://github.com/Qbox-Project/qbx_core/releases)
  - For using job/group restricted elevators
- (optionnal) [ox_target](https://github.com/overextended/ox_target/releases) or [qb-target](https://github.com/qbcore-framework/qb-target)
  - For target enable it in the config.
  - If you don't use any of these scripts you can add your own in `client/modules/targets`
  - Also possible to add another zone script handler in `client/modules/zones` but it is handled by `ox_lib`

## Configuration:
All configuration actions are available in the [config.lua file](https://github.com/Maximus7474/mps-elevator/blob/1.0.1/shared/config.lua).
To add more elevators copy the template and alter the values by respecting the structure, not respecting it will lead to errors and the resource not working properly.
- The floors will show in the same order as listed in the config file.

## Specifications:
- To add a restriction use the following table structure:
  - `{ ["jobname"] = minimum_rank, ["job2name"] = minimum_rank }` with minimum_rank being an integer
  - `{ "jobname", "job2name" }` making only the job required regardless of the rank
  - `false` to disable all restrictions
- The index of the floors table needs to be a string and is suggested to not be longer than 3 characters long.

## FAQ:
Q: Why does my character/vehicle drop when changing floor
A: You copy pasted the raw coords from a character position, this is 0.98 distance units above the ground. Either add ` - 0.98` after the z coordinate or subtract it from it.

## Credits:
- [Project Error](https://github.com/project-error) for the react boilerplate [Github Repo](https://github.com/project-error/fivem-react-boilerplate-lua)
