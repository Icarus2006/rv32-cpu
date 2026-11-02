#!/bin/bash
# Τρέχει όλα τα tests στον CPU (χρειάζεται tb/tb_cpu.v, Μέρος Ι, κεφ. 1.9).
make sim/tb_cpu.vvp > /dev/null || exit 1
pass=0; fail=0
for h in sim/tests/*.hex; do
    out=$(vvp -n sim/tb_cpu.vvp +hex=$h)
    if echo "$out" | grep -q '^PASS'; then
        pass=$((pass + 1))
    else
        fail=$((fail + 1))
        echo "FAIL $(basename $h .hex): $(echo "$out" | tail -1)"
    fi
done
echo "Passed: $pass   Failed: $fail"
[ $fail -eq 0 ]
