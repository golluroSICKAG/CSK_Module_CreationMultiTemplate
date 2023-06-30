# CSK_Module_CreationMultiTemplate

Module to give an example/template of how to create a SICK AppSpace Coding Starter Kit module with multiple instances processed in multiple threads.

## How to Run

This module tempalte can be used to create a new CSK module by renaming specific parts of it without the need to start from scratch.

- Copy the app to your AppStudio working directory
- Rename App name accordingly to the module feature -> e.g. CSK_Module_MultiRemoteCamera
- Right-click on the app and select "Refactor" to refactor the Crown accordingly to the modules feature.
  - E.g.: Select Type="Crown", Crown="CSK_ModuleName", Parent="no parent", Name=CSK_MultiRemoteCamera
- Rename all relevant parts containing "ModuleName"/"moduleName" according to the desired module name (e.g. "MultiRemoteCamera"/"multiRemoteCamera")

For further information regarding the internal used functions / events check out the [documentation](https://raw.githack.com/SICKAppSpaceCodingStarterKit/CSK_Module_CreationMultiTemplate/main/docu/CSK_Module_ModuleName.html) in the folder "docu".

## Information

Tested on  

1. SIM1012        - Firmware 2.2.0
2. SICK AppEngine - Firmware 1.3.2

This module is part of the SICK AppSpace Coding Starter Kit developing approach.  
It is programmed in an object oriented way. Some of these modules use kind of "classes" in Lua to make it possible to reuse code / classes in other projects.  
In general it is not neccessary to code this way, but the architecture of this app can serve as a sample to be used especially for bigger projects and to make it easier to share code.  
Please check the [documentation](https://github.com/SICKAppSpaceCodingStarterKit/.github/blob/main/docu/SICKAppSpaceCodingStarterKit_Documentation.md) of CSK for further information.  

## Topics

Coding Starter Kit, CSK, Module, Multi, SICK-AppSpace, Template
