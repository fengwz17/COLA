# randltl -n50 a b c --output=aut
a=0
rm output/compare.log
rm output/verify.log
while read line
do
    echo "File$a: $line"
    echo "File$a: $line" >> output/compare.log
    ltl2tgba -f "$line" --output=ltlaut/aut$a.hoa
    seminator --complement=spot ltlaut/aut$a.hoa >> output/compare.log
    seminator --complement=pldi ltlaut/aut$a.hoa >> output/compare.log
    seminator --complement=pldib ltlaut/aut$a.hoa >> output/compare.log
    seminator --complement=nsbc ltlaut/aut$a.hoa >> output/compare.log
    autfilt ltlaut/aut$a.hoa --complement -B --output=true/tcom$a.hoa
    autfilt true/tcom$a.hoa --stats='autfilt state: %s   edges: %e' >> output/compare.log
    echo -e '\n' >> output/compare.log
    
    r="autfilt true/tcom"$a".hoa --equivalent-to=nsbc/com.hoa" # --output=results/re$a
    if $r >> results/re$a; then
	    echo "File$a: equivalent" >> output/verify.log
    else
	    echo "File$a: not equivalent" >> output/verify.log
    fi
    let a++
done <../formulae/random_sd.ltl
