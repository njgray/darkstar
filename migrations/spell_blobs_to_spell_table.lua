require "migrate"

local spellLimit = 1024
local con = migrate.connect()

-- ensure new table exists
local cur = assert(con:execute("SHOW TABLES LIKE 'char_spells'"))

if (cur:numrows() == 0) then
    print("char_spells table does not exist. Please run sql/char_spells.sql")
    cur:close()
    migrate.close()
    return
end

cur:close()

-- grab all char rows from chars
cur = assert(con:execute("SELECT charid, HEX(spells) as spells FROM chars"))

print("Migrating spells of all " .. cur:numrows() .. " characters")

-- insert spells one by one
row = cur:fetch({}, "a")

while row do

    if (row.spells ~= '0' and row.spells ~= nil) then
        io.write(string.format("Migrating Charid: %d", row.charid))

        local spellId = 0;

        -- loop through each spell
        for character in row.spells:gmatch"." do

            -- convert from F to 1111
            local binary = hex2bin[character];

            -- loop through each bit and add spell if set
            for bit in binary:gmatch"." do
                if (bit == "1") then
                    -- printf("Added spell %d", spellId)
                    assert(con:execute(string.format("INSERT IGNORE INTO char_spells VALUES (%d, %d);", row.charid, spellId)))
                end

                spellId = spellId + 1

                if (spellId >= spellLimit) then
                    printf("Going over spell limit of %d, adding them anyway", spellLimit);
                end
            end
        end

        print(" [OK]")

    else
        printf("Charid %d has no spells, skipping", row.charid)
    end

    row = cur:fetch(row, "a")
end

cur:close()
migrate.close()

