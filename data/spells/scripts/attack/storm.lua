-- This is a script to define a spell that creates a storm with tornadoes spawning randomly within a 3x3 checkered area. I have not defined any specific damage within the spell since this was not specified. 

-- Firstly we have to create the area with possible tornado locations
local tornadoArea = {
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 0, 1, 0, 0},
    {0, 1, 0, 1, 0, 1, 0},
    {1, 0, 1, 3, 1, 0, 1},
    {0, 1, 0, 1, 1, 1, 0},
    {0, 0, 1, 0, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0}
}

-- Since the tornadoes should spawn randomly within this area, we need to create matrices that define a new area of tornadoes spawning in the possible spots. The input of this function will be the original "full matrix"
local function createRandomTornadoes(matrix)
    -- Create a new matrix to store the random locations
    local newMatrix = {}
    
    -- Iterate over each row in the original matrix
    for i, row in ipairs(matrix) do
        -- Create a new row in the new matrix
        newMatrix[i] = {}
        
        -- Iterate over each value in the row
        for j, value in ipairs(row) do
            -- If the value is 1 in the original matrix, multiply it by 0 or 1 randomly, otherwise keep the value unchanged (this ensures the 3 of the character position is unchanged)
            if value == 1 then
                newMatrix[i][j] = math.random(0, 1)
            else
                newMatrix[i][j] = value
            end
        end
    end
    
    -- Return the new matrix with the assigned random tornado locations
    return newMatrix
end

-- To get the scattered effect along time we will need to create combat phases, several combat objects with different random tornado locations that will be triggered with a specified delay between them. The following function creates a combat object with a given area of random tornado locations.
local function createNewCombat(area)
    local combat = createCombatObject()
    combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
    combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
    combat:setArea(area)
    return combat
end

-- We create an empty list of combat objects and establish our random seed
local combatList = {}
math.randomseed(os.time())

-- Now we define the number of phases and delay between phases of this spell. These numbers will determine the duration of the spell and how often a the new tornadoes spawn.  
local phases = 5
local waitDelay = 300

--We create the different combat objects in the following loop; for each phase an area of random tornado locations is determined and a combat object created (and added to the combatList).
for i = 1, phases do
    local randomArea = createRandomTornadoes(tornadoArea)
    local combat = createNewCombat(createCombatArea(randomArea))
    table.insert(combatList, combat)
end

--The function executeCombat allows us to trigger a specific combat phase, ensuring that the player, specific combat object and variant all exist before calling the execution to avoid any crashes
function executeCombat(creature, variant, index)
    local player = Player(creature)
    local combat = combatList[index]
    local var = Variant(variant)
    -- Check if player, combat, and variant are valid
    if player and combat and var then
        combat:execute(player, var)
    else
        print("Error executing combat: Invalid spell.")
    end
end

--This function is called when the spell is casted.
function onCastSpell(creature, variant)
    local player = Player(creature)
	-- First we make sure the player object exists, and in that case we get its creature ID
    if player then
        local id = player:getId()
		-- We create a loop through all of the defined phases to execute them. waitDelay is used to determine the wait between phases
        for i = 1, phases do
            local delay = (i - 1) * waitDelay
            addEvent(executeCombat, delay, id, variant:getNumber(), i)
        end
        return true
    end
    return false
end