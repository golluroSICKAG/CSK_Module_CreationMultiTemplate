---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter
--*****************************************************************
-- Inside of this script, you will find the module definition
-- including its parameters and functions
--*****************************************************************

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************
local nameOfModule = 'CSK_ModuleName'

-- Create kind of "class"
local moduleName = {}
moduleName.__index = moduleName

moduleName.styleForUI = 'None' -- Optional parameter to set UI style
moduleName.version = Engine.getCurrentAppVersion() -- Version of module

--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--- Function to react on UI style change
local function handleOnStyleChanged(theme)
  moduleName.styleForUI = theme
  Script.notifyEvent("ModuleName_OnNewStatusCSKStyle", moduleName.styleForUI)
end
Script.register('CSK_PersistentData.OnNewStatusCSKStyle', handleOnStyleChanged)

--- Function to create new instance
---@param moduleNameInstanceNo int Number of instance
---@return table[] self Instance of moduleName
function moduleName.create(moduleNameInstanceNo)

  local self = {}
  setmetatable(self, moduleName)

  self.moduleNameInstanceNo = moduleNameInstanceNo -- Number of this instance
  self.moduleNameInstanceNoString = tostring(self.moduleNameInstanceNo) -- Number of this instance as string
  self.helperFuncs = require('Mainfolder/Subfolder/helper/funcs') -- Load helper functions

  -- Optionally check if specific API was loaded via
  --[[
  if _G.availableAPIs.specific then
  -- ... doSomething ...
  end
  ]]

  -- Create parameters etc. for this module instance
  self.activeInUI = false -- Check if this instance is currently active in UI

  -- Check if CSK_PersistentData module can be used if wanted
  self.persistentModuleAvailable = CSK_PersistentData ~= nil or false

  -- Check if CSK_UserManagement module can be used if wanted
  self.userManagementModuleAvailable = CSK_UserManagement ~= nil or false

  -- Default values for persistent data
  -- If available, following values will be updated from data of CSK_PersistentData module (check CSK_PersistentData module for this)
  self.parametersName = 'CSK_ModuleName_Parameter' .. self.moduleNameInstanceNoString -- name of parameter dataset to be used for this module
  self.parameterLoadOnReboot = false -- Status if parameter dataset should be loaded on app/device reboot

  --self.object = Image.create() -- Use any AppEngine CROWN
  --self.counter = 1 -- Short docu of variable
  --self.varA = 'value' -- Short docu of variable

  -- Parameters to be saved permanently if wanted
  self.parameters = {}
  self.parameters.flowConfigPriority = CSK_FlowConfig ~= nil or false -- Status if FlowConfig should have priority for FlowConfig relevant configurations
  self.parameters.registeredEvent = '' -- If thread internal function should react on external event, define it here, e.g. 'CSK_OtherModule.OnNewInput'
  self.parameters.processingFile = 'CSK_ModuleName_Processing' -- which file to use for processing (will be started in own thread)
  --self.parameters.showImage = true -- Short docu of variable
  --self.parameters.paramA = 'paramA' -- Short docu of variable
  --self.parameters.paramB = 123 -- Short docu of variable

  self.parameters.internalObject = {} -- optionally
  --self.parameters.selectedObject = 1 -- Which object is currently selected
  --[[
    for i = 1, 10 do
    local obj = {}

    obj.objectName = 'Object' .. tostring(i) -- name of the object
    obj.active = false  -- is this object active
    -- ...

    table.insert(self.parameters.internalObject, obj)
  end

  local internalObjectContainer = self.helperFuncs.convertTable2Container(self.parameters.internalObject)
  ]]

  -- Parameters to give to the processing script
  self.moduleNameProcessingParams = Container.create()
  self.moduleNameProcessingParams:add('moduleNameInstanceNumber', moduleNameInstanceNo, "INT")
  self.moduleNameProcessingParams:add('registeredEvent', self.parameters.registeredEvent, "STRING")
  --self.moduleNameProcessingParams:add('showImage', self.parameters.showImage, "BOOL")
  --self.moduleNameProcessingParams:add('viewerId', 'moduleNameViewer' .. self.moduleNameInstanceNoString, "STRING")

  --self.moduleNameProcessingParams:add('internalObjects', internalObjectContainer, "OBJECT") -- optionally
  --self.moduleNameProcessingParams:add('selectedObject', self.parameters.selectedObject, "INT")

  -- Handle processing
  Script.startScript(self.parameters.processingFile, self.moduleNameProcessingParams)

  return self
end

--[[
--- Some internal code docu for local used function to do something
function moduleName:doSomething()
  self.object:doSomething()
end

--- Some internal code docu for local used function to do something else
function moduleName:doSomethingElse()
  self:doSomething() --> access internal function
end
]]

return moduleName

--*************************************************************************
--********************** End Function Scope *******************************
--*************************************************************************