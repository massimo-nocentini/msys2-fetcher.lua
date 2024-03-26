
function scandir(directory)
    local i, t = 0, {}
    local pfile = io.popen('ls -a "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

local seen = {None = true}
local queue = {}
local error_placeholder = 'error:'

for i, name in ipairs(arg) do table.insert (queue, name) end

while #queue > 0 do

    local package_name = table.remove (queue)
    
    if not seen[package_name] then

        local allok = true  -- innocent until proven guilty.

        print('Fetching ' .. package_name .. ' ...')
        
        local ppackage = io.popen ('pacman -Sw --cachedir temp --noconfirm ' .. package_name)
        local retmsg = ppackage:read 'a'

        print ('Retmsg: ' .. retmsg)
        
        if string.sub(retmsg, 1, #error_placeholder) == error_placeholder then
            allok = false
            print ('Package ' .. package_name .. ' needs retry because of ' .. retmsg)
        end
            
        ppackage:close()

        if allok then
        
            local ptmp = io.popen('pacman -Q -i --cachedir temp ' .. package_name)

            for l in ptmp:lines () do

                local i = string.find(l, ': ')
                if not i then break end

                local prefix, suffix = string.sub(l, 1, i-1), string.sub(l, i+2)

                if string.sub(prefix, 1, 10) == 'Depends On' then

                    for dep in string.gmatch (suffix, '(%g+)') do table.insert (queue, dep) end
                end
            end

            ptmp:close()
            
            seen[package_name] = true

        else table.insert (queue, package_name) end

    end
end

seen.None = nil

-- local packages = {}
-- for name, i in pairs (seen) do packages[i] = name end

-- print ('Downloading ' .. #packages .. ' packages ...')
-- os.execute ('pacman -Swv --cachedir temp --noconfirm ' .. table.concat(packages, ' '))

local temp_dir = scandir 'temp'

for i = 3, #temp_dir do

    local filename = temp_dir[i]
    if string.sub(filename, -3) == 'zst' then
        os.execute ('cd temp && unzstd ' .. filename)
        os.execute ('cd temp && tar xf ' .. string.sub(filename, 1, #filename - 4))
    end
end