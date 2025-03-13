-- Include all relevant FlowConfig scripts

--*****************************************************************
-- Here you will find all the required content to provide specific
-- features of this module via the 'CSK FlowConfig'.
--*****************************************************************

require('Mainfolder.Subfolder.FlowConfig.ModuleName_Consumer')
require('Mainfolder.Subfolder.FlowConfig.ModuleName_Provider')
require('Mainfolder.Subfolder.FlowConfig.ModuleName_Process')


-- Reference to the moduleName_Instances handle
local moduleName_Instances

--- Function to react if FlowConfig was updated
local function handleOnClearOldFlow()
  if _G.availableAPIs.default and _G.availableAPIs.specific then
    for i = 1, #moduleName_Instances do
      if moduleName_Instances[i].parameters.flowConfigPriority then
        CSK_ModuleName.clearFlowConfigRelevantConfiguration()
        break
      end
    end
  end
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)

--- Function to get access to the moduleName_Instances
---@param handle handle Handle of moduleName_Instances object
local function setModuleName_Instances_Handle(handle)
  moduleName_Instances = handle
end

return setModuleName_Instances_Handle