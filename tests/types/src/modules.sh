#!/bin/sh
#
# This script is used to test that the module system is working as expected.
# By default it test the version of nixpkgs which is defined in the NIX_PATH.

cd ./modules

echo $NIX_PATH

pass=0
fail=0

evalConfig() {
    local attr=$1
    shift;
    local script="import ./default.nix { modules = [ $@ ];}"
    nix-instantiate --timeout 1 -E "$script" -A "$attr" --eval-only --show-trace
}

reportFailure() {
    local attr=$1
    shift;
    local script="import ./default.nix { modules = [ $@ ];}"
    echo 2>&1 "$ nix-instantiate -E '$script' -A '$attr' --eval-only"
    evalConfig "$attr" "$@"
    fail=$((fail + 1))
}

checkConfigOutput() {
    local outputContains=$1
    shift;
    if evalConfig "$@" 2>/dev/null | grep --silent "$outputContains" ; then
        pass=$((pass + 1))
        return 0;
    else
        echo 2>&1 "error: Expected result matching '$outputContains', while evaluating"
        reportFailure "$@"
        return 1
    fi
}

checkConfigError() {
    local errorContains=$1
    local err=""
    shift;
    if err==$(evalConfig "$@" 2>&1 >/dev/null); then
        echo 2>&1 "error: Expected error code, got exit code 0, while evaluating"
        reportFailure "$@"
        return 1
    else
        if echo "$err" | grep --silent "$errorContains" ; then
            pass=$((pass + 1))
            return 0;
        else
            echo 2>&1 "error: Expected error matching '$errorContains', while evaluating"
            reportFailure "$@"
            return 1
        fi
    fi
}

# String types.
checkConfigOutput "foo" config.value ./declare-non-empty-string.nix ./define-value-string.nix
checkConfigError "The option .* in .* is not of type \`string (with check: non-empty)'." config.value ./declare-non-empty-string.nix ./define-value-empty-string.nix
checkConfigError "The option .* in .* is not of type \`string (with check: non-empty)'." config.value ./declare-non-empty-string.nix ./define-value-empty-string-2.nix

# Ports.
checkConfigOutput "8000" config.value ./declare-port.nix ./define-value-port-8000.nix
checkConfigOutput "0" config.value ./declare-port.nix ./define-value-port-0.nix
checkConfigError "The option .* in .* is not of type \`integer between 0 and 65535 (both inclusive)'." config.value ./declare-port.nix ./define-value-negative-int.nix
checkConfigError "The option .* in .* is not of type \`integer between 0 and 65535 (both inclusive)'." config.value ./declare-port.nix ./define-value-int-65536.nix

cat <<EOF
====== module tests ======
$pass Pass
$fail Fail
EOF

if test $fail -ne 0; then
    exit 1
fi
exit 0