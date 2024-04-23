-- In this piece of code I found two errors, using resultID and result as if they were the same variable, and not looping through all of the found guilds. This would be my attempt at solving said issues:

function printSmallGuildNames(memberCount)
    -- Prepare the SQL query to select guild names with fewer than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    
    -- Execute the query and get the result set
    local result = db.storeQuery(string.format(selectGuildQuery, memberCount))
    
    -- Check if the query returned one or more guilds
    if result then
        -- Loop over each row in the result
        while result.next() do
            -- Get and print the guild name from the current row
            local guildName = result.getString("name")
            print(guildName)
        end
    else
        -- Print a message if no guilds are found
        print("No guilds found with less than " .. memberCount .. " members.")
    end
end