# slightly slow but handles "-I" being split over two arguments
def filterI:
    (reduce .[] as $item (
        [false,[]];
        [ $item=="-I"
        , if .[0] then .[1]+[$item] 
          elif ($item | test("^-I.","")) then .[1]+[$item | ltrimstr("-I")]
          else .[1] end
        ]
    ))[1];
def extractArgs:
    (.args + (.command | split(" ")));
def unquote: ltrimstr("\"") | rtrimstr("\"");
# . | map(extractArgs | filterI) | flatten | map(unquote) | group_by(.) | map(.[0]) | .[]
. | map(extractArgs | map(select(startswith("-I")) | ltrimstr("-I"))) | flatten | map(unquote) | group_by(.) | map(.[0]) | .[]
