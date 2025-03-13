---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter

--***************************************************************
-- Inside of this script, you will find the necessary functions,
-- variables and events to communicate with the ModuleName_Model and _Instances
--***************************************************************

--**************************************************************************
--************************ Start Global Scope ******************************
--**************************************************************************
local nameOfModule = 'CSK_ModuleName'

local funcs = {}

-- Timer to update UI via events after page was loaded
local tmrModuleName = Timer.create()
tmrModuleName:setExpirationTime(300)
tmrModuleName:setPeriodic(false)

local moduleName_Model -- Reference to model handle
local moduleName_Instances -- Reference to instances handle
local selectedInstance = 1 -- Which instance is currently selected
local helperFuncs = require('Mainfolder/Subfolder/helper/funcs')

-- ************************ UI Events Start ********************************
-- Only to prevent WARNING messages, but these are only examples/placeholders for dynamically created events/functions
----------------------------------------------------------------
local function emptyFunction()
end
Script.serveFunction("CSK_ModuleName.processInstanceNUM", emptyFunction)

Script.serveEvent("CSK_ModuleName.OnNewResultNUM", "ModuleName_OnNewResultNUM")
Script.serveEvent("CSK_ModuleName.OnNewValueToForwardNUM", "ModuleName_OnNewValueToForwardNUM")
Script.serveEvent("CSK_ModuleName.OnNewValueUpdateNUM", "ModuleName_OnNewValueUpdateNUM")
----------------------------------------------------------------

-- Real events
--------------------------------------------------
-- Script.serveEvent("CSK_ModuleName.OnNewEvent", "ModuleName_OnNewEvent")
Script.serveEvent('CSK_ModuleName.OnNewResult', 'ModuleName_OnNewResult')

Script.serveEvent('CSK_ModuleName.OnNewStatusModuleVersion', 'ModuleName_OnNewStatusModuleVersion')
Script.serveEvent('CSK_ModuleName.OnNewStatusCSKStyle', 'ModuleName_OnNewStatusCSKStyle')
Script.serveEvent('CSK_ModuleName.OnNewStatusModuleIsActive', 'ModuleName_OnNewStatusModuleIsActive')

Script.serveEvent('CSK_ModuleName.OnNewStatusRegisteredEvent', 'ModuleName_OnNewStatusRegisteredEvent')

Script.serveEvent("CSK_ModuleName.OnNewStatusLoadParameterOnReboot", "ModuleName_OnNewStatusLoadParameterOnReboot")
Script.serveEvent("CSK_ModuleName.OnPersistentDataModuleAvailable", "ModuleName_OnPersistentDataModuleAvailable")
Script.serveEvent("CSK_ModuleName.OnNewParameterName", "ModuleName_OnNewParameterName")

Script.serveEvent("CSK_ModuleName.OnNewInstanceList", "ModuleName_OnNewInstanceList")
Script.serveEvent("CSK_ModuleName.OnNewProcessingParameter", "ModuleName_OnNewProcessingParameter")
Script.serveEvent("CSK_ModuleName.OnNewSelectedInstance", "ModuleName_OnNewSelectedInstance")
Script.serveEvent("CSK_ModuleName.OnDataLoadedOnReboot", "ModuleName_OnDataLoadedOnReboot")

Script.serveEvent('CSK_ModuleName.OnNewStatusFlowConfigPriority', 'ModuleName_OnNewStatusFlowConfigPriority')
Script.serveEvent("CSK_ModuleName.OnUserLevelOperatorActive", "ModuleName_OnUserLevelOperatorActive")
Script.serveEvent("CSK_ModuleName.OnUserLevelMaintenanceActive", "ModuleName_OnUserLevelMaintenanceActive")
Script.serveEvent("CSK_ModuleName.OnUserLevelServiceActive", "ModuleName_OnUserLevelServiceActive")
Script.serveEvent("CSK_ModuleName.OnUserLevelAdminActive", "ModuleName_OnUserLevelAdminActive")

-- ...

-- ************************ UI Events End **********************************

--[[
--- Some internal code docu for local used function
local function functionName()
  -- Do something

end
]]

--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

-- Functions to forward logged in user roles via CSK_UserManagement module (if available)
-- ***********************************************
--- Function to react on status change of Operator user level
---@param status boolean Status if Operator level is active
local function handleOnUserLevelOperatorActive(status)
  Script.notifyEvent("ModuleName_OnUserLevelOperatorActive", status)
end

--- Function to react on status change of Maintenance user level
---@param status boolean Status if Maintenance level is active
local function handleOnUserLevelMaintenanceActive(status)
  Script.notifyEvent("ModuleName_OnUserLevelMaintenanceActive", status)
end

--- Function to react on status change of Service user level
---@param status boolean Status if Service level is active
local function handleOnUserLevelServiceActive(status)
  Script.notifyEvent("ModuleName_OnUserLevelServiceActive", status)
end

--- Function to react on status change of Admin user level
---@param status boolean Status if Admin level is active
local function handleOnUserLevelAdminActive(status)
  Script.notifyEvent("ModuleName_OnUserLevelAdminActive", status)
end
-- ***********************************************

--- Function to forward data updates from instance threads to Controller part of module
---@param eventname string Eventname to use to forward value
---@param value auto Value to forward
local function handleOnNewValueToForward(eventname, value)
  Script.notifyEvent(eventname, value)
end

--- Optionally: Only use if needed for extra internal objects -  see also Model
--- Function to sync paramters between instance threads and Controller part of module
---@param instance int Instance new value is coming from
---@param parameter string Name of the paramter to update/sync
---@param value auto Value to update
---@param selectedObject int? Optionally if internal parameter should be used for internal objects
local function handleOnNewValueUpdate(instance, parameter, value, selectedObject)
    moduleName_Instances[instance].parameters.internalObject[selectedObject][parameter] = value
end

--- Function to get access to the moduleName_Model object
---@param handle handle Handle of moduleName_Model object
local function setModuleName_Model_Handle(handle)
  moduleName_Model = handle
  Script.releaseObject(handle)
end
funcs.setModuleName_Model_Handle = setModuleName_Model_Handle

--- Function to get access to the moduleName_Instances object
---@param handle handle Handle of moduleName_Instances object
local function setModuleName_Instances_Handle(handle)
  moduleName_Instances = handle
  if moduleName_Instances[selectedInstance].userManagementModuleAvailable then
    -- Register on events of CSK_UserManagement module if available
    Script.register('CSK_UserManagement.OnUserLevelOperatorActive', handleOnUserLevelOperatorActive)
    Script.register('CSK_UserManagement.OnUserLevelMaintenanceActive', handleOnUserLevelMaintenanceActive)
    Script.register('CSK_UserManagement.OnUserLevelServiceActive', handleOnUserLevelServiceActive)
    Script.register('CSK_UserManagement.OnUserLevelAdminActive', handleOnUserLevelAdminActive)
  end
  Script.releaseObject(handle)

  for i = 1, #moduleName_Instances do
    Script.register("CSK_ModuleName.OnNewValueToForward" .. tostring(i) , handleOnNewValueToForward)
  end

  for i = 1, #moduleName_Instances do
    Script.register("CSK_ModuleName.OnNewValueUpdate" .. tostring(i) , handleOnNewValueUpdate)
  end

end
funcs.setModuleName_Instances_Handle = setModuleName_Instances_Handle

--- Function to update user levels
local function updateUserLevel()
  if moduleName_Instances[selectedInstance].userManagementModuleAvailable then
    -- Trigger CSK_UserManagement module to provide events regarding user role
    CSK_UserManagement.pageCalled()
  else
    -- If CSK_UserManagement is not active, show everything
    Script.notifyEvent("ModuleName_OnUserLevelAdminActive", true)
    Script.notifyEvent("ModuleName_OnUserLevelMaintenanceActive", true)
    Script.notifyEvent("ModuleName_OnUserLevelServiceActive", true)
    Script.notifyEvent("ModuleName_OnUserLevelOperatorActive", true)
  end
end

--- Function to send all relevant values to UI on resume
local function handleOnExpiredTmrModuleName()
  -- Script.notifyEvent("ModuleName_OnNewEvent", false)

  Script.notifyEvent("ModuleName_OnNewStatusModuleVersion", 'v' .. moduleName_Model.version)
  Script.notifyEvent("ModuleName_OnNewStatusCSKStyle", moduleName_Model.styleForUI)
  Script.notifyEvent("ModuleName_OnNewStatusModuleIsActive", _G.availableAPIs.default and _G.availableAPIs.specific)

  if _G.availableAPIs.default and _G.availableAPIs.specific then

    updateUserLevel()

    Script.notifyEvent('ModuleName_OnNewSelectedInstance', selectedInstance)
    Script.notifyEvent("ModuleName_OnNewInstanceList", helperFuncs.createStringListBySize(#moduleName_Instances))

    Script.notifyEvent("ModuleName_OnNewStatusRegisteredEvent", moduleName_Instances[selectedInstance].parameters.registeredEvent)

    Script.notifyEvent("ModuleName_OnNewStatusFlowConfigPriority", moduleName_Instances[selectedInstance].parameters.flowConfigPriority)
    Script.notifyEvent("ModuleName_OnNewStatusLoadParameterOnReboot", moduleName_Instances[selectedInstance].parameterLoadOnReboot)
    Script.notifyEvent("ModuleName_OnPersistentDataModuleAvailable", moduleName_Instances[selectedInstance].persistentModuleAvailable)
    Script.notifyEvent("ModuleName_OnNewParameterName", moduleName_Instances[selectedInstance].parametersName)
  end
  -- ...
end
Timer.register(tmrModuleName, "OnExpired", handleOnExpiredTmrModuleName)

-- ********************* UI Setting / Submit Functions Start ********************

local function pageCalled()
  if _G.availableAPIs.default and _G.availableAPIs.specific then
    updateUserLevel() -- try to hide user specific content asap
  end
  tmrModuleName:start()
  return ''
end
Script.serveFunction("CSK_ModuleName.pageCalled", pageCalled)

local function setSelectedInstance(instance)
  if #moduleName_Instances >= instance then
    selectedInstance = instance
    _G.logger:fine(nameOfModule .. ": New selected instance = " .. tostring(selectedInstance))
    moduleName_Instances[selectedInstance].activeInUI = true
    Script.notifyEvent('ModuleName_OnNewProcessingParameter', selectedInstance, 'activeInUI', true)
    tmrModuleName:start()
  else
    _G.logger:warning(nameOfModule .. ": Selected instance does not exist.")
  end
end
Script.serveFunction("CSK_ModuleName.setSelectedInstance", setSelectedInstance)

local function getInstancesAmount ()
  if multiSerialCom_Instances then
    return #moduleName_Instances
  else
    return 0
  end
end
Script.serveFunction("CSK_ModuleName.getInstancesAmount", getInstancesAmount)

local function addInstance()
  _G.logger:fine(nameOfModule .. ": Add instance")
  table.insert(moduleName_Instances, moduleName_Model.create(#moduleName_Instances+1))
  Script.deregister("CSK_ModuleName.OnNewValueToForward" .. tostring(#moduleName_Instances) , handleOnNewValueToForward)
  Script.register("CSK_ModuleName.OnNewValueToForward" .. tostring(#moduleName_Instances) , handleOnNewValueToForward)
  handleOnExpiredTmrModuleName()
end
Script.serveFunction('CSK_ModuleName.addInstance', addInstance)

local function resetInstances()
  _G.logger:info(nameOfModule .. ": Reset instances.")
  setSelectedInstance(1)
  local totalAmount = #moduleName_Instances
  while totalAmount > 1 do
    Script.releaseObject(moduleName_Instances[totalAmount])
    moduleName_Instances[totalAmount] =  nil
    totalAmount = totalAmount - 1
  end
  handleOnExpiredTmrModuleName()
end
Script.serveFunction('CSK_ModuleName.resetInstances', resetInstances)

local function setRegisterEvent(event)
  moduleName_Instances[selectedInstance].parameters.registeredEvent = event
  Script.notifyEvent('ModuleName_OnNewProcessingParameter', selectedInstance, 'registeredEvent', event)
end
Script.serveFunction("CSK_ModuleName.setRegisterEvent", setRegisterEvent)

--- Function to share process relevant configuration with processing threads
local function updateProcessingParameters()
  Script.notifyEvent('ModuleName_OnNewProcessingParameter', selectedInstance, 'activeInUI', true)

  Script.notifyEvent('ModuleName_OnNewProcessingParameter', selectedInstance, 'registeredEvent', moduleName_Instances[selectedInstance].parameters.registeredEvent)

  --Script.notifyEvent('ModuleName_OnNewProcessingParameter', selectedInstance, 'value', moduleName_Instances[selectedInstance].parameters.value)

  -- optionally for internal objects...
  --[[
  -- Send config to instances
  local params = helperFuncs.convertTable2Container(moduleName_Instances[selectedInstance].parameters.internalObject)
  Container.add(data, 'internalObject', params, 'OBJECT')
  Script.notifyEvent('ModuleName_OnNewProcessingParameter', selectedInstance, 'FullSetup', data)
  ]]

end

local function getStatusModuleActive()
  return _G.availableAPIs.default and _G.availableAPIs.specific
end
Script.serveFunction('CSK_ModuleName.getStatusModuleActive', getStatusModuleActive)

local function clearFlowConfigRelevantConfiguration()
  for i = 1, #moduleName_Instances do
    moduleName_Instances[i].parameters.registeredEvent = ''
    Script.notifyEvent('ModuleName_OnNewProcessingParameter', i, 'deregisterFromEvent', '')
    Script.notifyEvent('ModuleName_OnNewStatusRegisteredEvent', '')
  end
end
Script.serveFunction('CSK_ModuleName.clearFlowConfigRelevantConfiguration', clearFlowConfigRelevantConfiguration)

local function getParameters(instanceNo)
  if instanceNo <= #moduleName_Instances then
    return helperFuncs.json.encode(moduleName_Instances[instanceNo].parameters)
  else
    return ''
  end
end
Script.serveFunction('CSK_ModuleName.getParameters', getParameters)

-- *****************************************************************
-- Following function can be adapted for CSK_PersistentData module usage
-- *****************************************************************

local function setParameterName(name)
  _G.logger:fine(nameOfModule .. ": Set parameter name = " .. tostring(name))
  moduleName_Instances[selectedInstance].parametersName = name
end
Script.serveFunction("CSK_ModuleName.setParameterName", setParameterName)

local function sendParameters(noDataSave)
  if moduleName_Instances[selectedInstance].persistentModuleAvailable then
    CSK_PersistentData.addParameter(helperFuncs.convertTable2Container(moduleName_Instances[selectedInstance].parameters), moduleName_Instances[selectedInstance].parametersName)

    -- Check if CSK_PersistentData version is >= 3.0.0
    if tonumber(string.sub(CSK_PersistentData.getVersion(), 1, 1)) >= 3 then
      CSK_PersistentData.setModuleParameterName(nameOfModule, moduleName_Instances[selectedInstance].parametersName, moduleName_Instances[selectedInstance].parameterLoadOnReboot, tostring(selectedInstance), #moduleName_Instances)
    else
      CSK_PersistentData.setModuleParameterName(nameOfModule, moduleName_Instances[selectedInstance].parametersName, moduleName_Instances[selectedInstance].parameterLoadOnReboot, tostring(selectedInstance))
    end
    _G.logger:fine(nameOfModule .. ": Send ModuleName parameters with name '" .. moduleName_Instances[selectedInstance].parametersName .. "' to CSK_PersistentData module.")
    if not noDataSave then
      CSK_PersistentData.saveData()
    end
  else
    _G.logger:warning(nameOfModule .. ": CSK_PersistentData module not available.")
  end
end
Script.serveFunction("CSK_ModuleName.sendParameters", sendParameters)

local function loadParameters()
  if moduleName_Instances[selectedInstance].persistentModuleAvailable then
    local data = CSK_PersistentData.getParameter(moduleName_Instances[selectedInstance].parametersName)
    if data then
      _G.logger:info(nameOfModule .. ": Loaded parameters for moduleNameObject " .. tostring(selectedInstance) .. " from CSK_PersistentData module.")
      moduleName_Instances[selectedInstance].parameters = helperFuncs.convertContainer2Table(data)

      -- If something needs to be configured/activated with new loaded data
      --updateProcessingParameters()

      tmrModuleName:start()
      return true
    else
      _G.logger:warning(nameOfModule .. ": Loading parameters from CSK_PersistentData module did not work.")
      tmrModuleName:start()
      return false
    end
  else
    _G.logger:warning(nameOfModule .. ": CSK_PersistentData module not available.")
    tmrModuleName:start()
    return false
  end
end
Script.serveFunction("CSK_ModuleName.loadParameters", loadParameters)

local function setLoadOnReboot(status)
  moduleName_Instances[selectedInstance].parameterLoadOnReboot = status
  _G.logger:fine(nameOfModule .. ": Set new status to load setting on reboot: " .. tostring(status))
  Script.notifyEvent("ModuleName_OnNewStatusLoadParameterOnReboot", status)
end
Script.serveFunction("CSK_ModuleName.setLoadOnReboot", setLoadOnReboot)

local function setFlowConfigPriority(status)
  moduleName_Instances[selectedInstance].parameters.flowConfigPriority = status
  _G.logger:fine(nameOfModule .. ": Set new status of FlowConfig priority: " .. tostring(status))
  Script.notifyEvent("ModuleName_OnNewStatusFlowConfigPriority", moduleName_Instances[selectedInstance].parameters.flowConfigPriority)
end
Script.serveFunction('CSK_ModuleName.setFlowConfigPriority', setFlowConfigPriority)

--- Function to react on initial load of persistent parameters
local function handleOnInitialDataLoaded()

  if _G.availableAPIs.default and _G.availableAPIs.specific then

    _G.logger:fine(nameOfModule .. ': Try to initially load parameter from CSK_PersistentData module.')
    if string.sub(CSK_PersistentData.getVersion(), 1, 1) == '1' then

      _G.logger:warning(nameOfModule .. ': CSK_PersistentData module is too old and will not work. Please update CSK_PersistentData module.')

      for j = 1, #moduleName_Instances do
        moduleName_Instances[j].persistentModuleAvailable = false
      end
    else
      -- Check if CSK_PersistentData version is >= 3.0.0
      if tonumber(string.sub(CSK_PersistentData.getVersion(), 1, 1)) >= 3 then
        local parameterName, loadOnReboot, totalInstances = CSK_PersistentData.getModuleParameterName(nameOfModule, '1')
        -- Check for amount if instances to create
        if totalInstances then
          local c = 2
          while c <= totalInstances do
            addInstance()
            c = c+1
          end
        end
      end

      if not moduleName_Instances then
        return
      end

      for i = 1, #moduleName_Instances do
        local parameterName, loadOnReboot = CSK_PersistentData.getModuleParameterName(nameOfModule, tostring(i))

        if parameterName then
          moduleName_Instances[i].parametersName = parameterName
          moduleName_Instances[i].parameterLoadOnReboot = loadOnReboot
        end

        if moduleName_Instances[i].parameterLoadOnReboot then
          setSelectedInstance(i)
          loadParameters()
        end
      end
      Script.notifyEvent('ModuleName_OnDataLoadedOnReboot')
    end
  end
end
Script.register("CSK_PersistentData.OnInitialDataLoaded", handleOnInitialDataLoaded)

local function resetModule()
  if _G.availableAPIs.default and _G.availableAPIs.specific then
    clearFlowConfigRelevantConfiguration()
    pageCalled()
  end
end
Script.serveFunction('CSK_ModuleName.resetModule', resetModule)
Script.register("CSK_PersistentData.OnResetAllModules", resetModule)

-- *************************************************
-- END of functions for CSK_PersistentData module usage
-- *************************************************

return funcs

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************

