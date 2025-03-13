-- Block namespace
local BLOCK_NAMESPACE = 'ModuleName_FC.Consumer'
local nameOfModule = 'CSK_ModuleName'

--*************************************************************
--*************************************************************

-- Required to keep track of already allocated resource
local instanceTable = {}

local function consume(handle, source)

  local instance = Container.get(handle, 'Instance')

  -- Check incoming value
  if source then

    -- Check if amount of instances is valid
    -- if not: add multiple additional instances
    while true do
      local amount = CSK_ModuleName.getInstancesAmount()
      if amount < instance then
        CSK_ModuleName.addInstance()
      else
        CSK_ModuleName.setSelectedInstance(instance)

        -- Do something like
        -- CSK_ModuleName.doSomething(source)
        -- or normally
        CSK_ModuleName.setRegisterEvent(source)
        break
      end
    end
  end
end
Script.serveFunction(BLOCK_NAMESPACE .. '.consume', consume)

--*************************************************************
--*************************************************************

local function create(instance)

  -- Check if same instance is already configured
  if instance < 1 or nil ~= instanceTable[instance] then
    _G.logger:warning(nameOfModule .. ': Instance invalid or already in use, please choose another one')
    return nil
  else
    -- Otherwise create handle and store the restriced resource
    local handle = Container.create()
    instanceTable[instance] = instance
    Container.add(handle, 'Instance', instance)
    -- Optionally add other parameters (check manifest as well)
    return handle
  end
end
Script.serveFunction(BLOCK_NAMESPACE .. '.create', create)

--- Function to reset instances if FlowConfig was cleared
local function handleOnClearOldFlow()
  Script.releaseObject(instanceTable)
  instanceTable = {}
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)