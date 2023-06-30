# Changelog
All notable changes to this project will be documented in this file.

## Release 3.5.0

### Improvements
- Using recursive helper functions to convert Container <-> Lua table

## Release 3.4.0

### Improvements
- Update to EmmyLua annotations
- Usage of lua diagnostics
- Documentation updates

## Release 3.3.0

### Improvements
- Using internal moduleName variable to be usable in merged apps instead of _APPNAME, as this did not work with PersistentData module in merged apps.

## Release 3.2.2

### Improvements
- Naming of UI elements and adding some mouse over info texts
- Appname added to log messages
- Minor edits

### Bugfix
- UI events notified after pageLoad after 300ms instead of 100ms to not miss

## Release 3.2.1

### Improvements
- Minor edits

## Release 3.2.0

### Improvements
- Per default use 'LuaLoadAllEngineAPI = true' to make it easier to start
- Update of helper funcs
- Hiding  SOPAS Login
- Minor code edits / docu updates

## Release 3.1.0

### Improvements
- Loading only required APIs ('LuaLoadAllEngineAPI = false') -> less time for GC needed
- Changed status type of user levels from string to bool (usable with CSK_Module_UserManagement since version 1.2.1)
- Renamed page folder accordingly to module name

## Release 3.0.0

### New features
- Compatible to PersistentData Module ver >= 3.0.0 to store InstanceAmount within Parameter binary file instead of CID Parameter
  - By this, multiple instances are created now after PersistentData loaded and provides data

### Improvements
- Renaming of "Objects" to "Instances", so that it makes more sense if internal "objects" are used within the module (e.g. 'colorObjects' within the 'CSK_MultiColorSelection'-module)
- Provide sample code to use optionally internal extra objects
- Using of example manifest entries to automatically adapt events accordingly to created instances (e.g. 'processInstanceNUM', 'OnNewValueUpdateNUM', 'OnNewValueToForwardNUM'
- Including forward functions like 'handleOnNewValueToForward', 'handleOnNewValueUpdate' to make it easier to forward content from internal threads/instances to general app/UI

## Release 2.1.0

### New features
- Integration of CSK_UserManagement functionality

## Release 2.0.0

### New features
- Update handling of persistent data according to CSK_PersistentData module ver. 2.0.0

## Release 1.1.1

### Improvements
- Make use of variable "instanceAmount" of PersistentData module if available for amount of instances

## Release 1.1.0

### Improvements
- Setup of Parameter name (PersistentData) added to UI
- Support of 2-dim tables within parameters to save in PersistentData CSK module

## Release 1.0.0
- Initial commit