using JSON

dict2 = Dict()
open(ARGS[1], "r") do f
    global dict2
    dict2=JSON.parse(f)  
end

gstr = "";

for a in dict2["cells"]
    if "#export\n" in a["source"]
        temp = a["source"]
        temp = filter!(e->e≠"#export\n",temp)
        gstr*= join(temp)
        gstr*="\n"
    end
end

io = open(ARGS[2]*".jl", "w")
write(io, gstr)
close(io)