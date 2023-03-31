ReShade Varjo "RedShift Fix" Shader
====================================

This repository contains a chromatic aberration shader that helps fix the "redshift" experienced
on Varjo HMDs (Aero, XR-3, VR-3). Not compatible with Quad Views.

To get ReShade visit https://reshade.me


Installation using the ReShade Setup Tool (easy)
------------------------------------------------

1. Select the game or application you want to use ReShade on
2. select the appropriate rendering API (DX9,DX10/11/12,OpenGL,Vulkan) if ReShade asks for it. You can look at the 
[PcGamingWiki](https://www.pcgamingwiki.com/) in the section "API" if you're unsure which rendering API to choose
3. add this link `https://github.com/bernhardberger/reshade-varjo-redshift-fix/archive/main.zip` in the installer when it asks you which effect packages to install
4. select the newly added repository
5. start your game and enable the technique in ReShade. See section "Usage" or "Quickstart" for further details

Installation (manual)
---------------------

1. [Download](https://github.com/bernhardberger/reshade-varjo-redshift-fix/archive/main.zip) this repository
2. Extract the downloaded archive file somewhere
3. Start your game, open the ReShade in-game menu and switch to the "Settings" tab
4. Add the path to the extracted [Shaders](/Shaders) folder to "Effect Search Paths"
5. Add the path to the extracted [Textures](/Textures) folder to "Texture Search Paths"
6. Switch back to the "Home" tab and click on "Reload" to load the shaders

Usage
-----

1. enable the `ZZZ_VarjoRedshiftFix` technique in ReShade (doesn't have a VR overlay, needs to be done in 2D!)
2. make sure the `ZZZ_VarjoRedshiftFix` technique is **last** in the list
3. as far as I can tell ReShade doesn't support on-the-fly changes in VR. You need to restart the game to see changes


Quickstart
----------

The quickest way to get the correction values is to use my [RedShiftTester](https://github.com/bernhardberger/RedShiftTester/releases) app
in combination with [OpenXR Toolkit](https://mbucchia.github.io/OpenXR-Toolkit/) to get the correction values. The resulting numbers for
my ReShade shader are exactly the same as you determine through the RedShiftTester app and OpenXR-Toolkit.

You can edit your ReShade preset (e.g. `ReShadePreset.ini`) and add the following content if you don't want to deal with the sliders in 
the ReShade UI:

```ini
[VarjoCA.fx]
offsetBlue=-0.115
offsetRed=0.085
```


Credits
-------
Special thanks to Matthieu Bucchianeri ([mbucchia](https://github.com/mbucchia)) for writing the initial HLSL pixel shader for his awesome [OpenXR-Toolkit](https://mbucchia.github.io/OpenXR-Toolkit/) project!
