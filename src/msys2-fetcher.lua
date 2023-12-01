
local curl = require 'curl'
local op = require 'operator'

--[[
curl.with_easy_pcall_recv_do (
	function (curl_easy_handler)

        local pflag, setopt = curl_easy_handler (
            curl.curl_easy_httpheader_setopt_getinfo {
                httpheader	= {
                    Accept = 'application/json'
                },
                setopt		= {
                    url = 'https://packages.msys2.org/api/search?query=mingw-w64-pango',
                    verbose = false,
                    header = false,
                    ssl_verifypeer = true,
                    ssl_verifyhost = true,
                    --cainfo = replication_conf.curl.cainfo_file,
                    writefunction = true -- means that we just want the whole response, not interested in its chunks.
                }
            }
        )

        assert (pflag)		-- ensure everything went well.
        json_response = op.o { curl.assertCURLE_OK, setopt.writefunction } ()

        print (json_response)
                
                   
    end
)
]]


-- Lua implementation of PHP scandir function
function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

local seen = {}
local queue = {'mingw-w64-ucrt-x86_64-pango', ' mingw-w64-ucrt-x86_64-gtk3'}


while #queue > 0 do

    local package_name = table.remove (queue)
    
    if not seen[package_name] then

        seen[package_name] = true
        print('Fetching ' .. package_name .. ' ...')
        os.execute ('pacman -Sw --cachedir temp --noconfirm ' .. package_name)
        os.execute ('pacman -Q -i ' .. package_name .. ' > tmp.txt')

        for l in io.lines 'tmp.txt' do

            local i = string.find(l, ': ')
            if not i then break end

            local prefix, suffix = string.sub(l, 1, i-1), string.sub(l, i+2)

            if prefix == 'Depends On      ' then

                i = string.find(suffix, '  ')
                while i do
                    table.insert (queue, string.sub(suffix, 1, i - 1))
                    suffix = string.sub (suffix, i + 2)
                    i = string.find(suffix, '  ')
                end
            end
        end
    end

end

local temp_dir = scandir 'temp'

for i = 3, #temp_dir do

    local filename = temp_dir[i]
    if string.sub(filename, -3) == 'zst' then
        os.execute ('cd temp && unzstd ' .. filename)
        os.execute ('cd temp && tar xf ' .. string.sub(filename, 1, #filename - 4))
    end
end
    