def filterI($ls; $acc):
    if (ls | length) == 0 then acc
    elif ls[0] == "-I" then filterI(ls[2:]; acc+[ls[1]])
    else filterI(ls[2:]; acc) end;
map(filterI(.arguments;[])) | flatten | group_by(.) | map(.[0]) | .[]
