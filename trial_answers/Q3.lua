-- From what I could understand, this function aims to remove a member with memberName from the party which the payer with the given ID is part of.

-- Changed function name to better convey its functionality
function removeMemberFromParty(playerId, membername)
	player = Player(playerId)
	local party = player:getParty()
	-- Check if party exists
	if not party then
		print("Player is not in a party.")
		return
    end
	
	for k,v in pairs(party:getMembers()) do
		if v == Player(membername) then
			party:removeMember(Player(membername))
			-- Add a break because Player(membername) is unique
			break
		end
	end
end

-- Assuming the party looks the same regardless of which player is fetched from, the following could potentially be a more efficient alternative:

function removeMemberFromParty(playerId, membername)
	player1 = Player(playerId)
	player2 = Player(membername)
	local party1 = player1:getParty()
	local party2 = player2:getParty()
	-- Check if party exists for both playerID and membername
	if not party1 or not party2 then
		print("Player is not in the party.")
		return
    end
	
	if party1 == party2
		party1:removeMember(Player(membername))
	end
end