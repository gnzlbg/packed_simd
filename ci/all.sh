#!/usr/bin/env sh
#
# Performs an operation on all targets

set -ex

: "${1?The all.sh script requires one argument.}"

op=$1

cargo_clean() {
    cargo clean
}

cargo_check_fmt() {
    cargo fmt --all -- --check
}

cargo_fmt() {
    cargo fmt --all
}

cargo_clippy() {
    cargo clippy --all -- -D clippy::pedantic
}

CMD="-1"

case $op in
    clean*)
        CMD=cargo_clean
        ;;
    check_fmt*)
        CMD=cargo_check_fmt
        ;;
    fmt*)
        CMD=cargo_fmt
        ;;
    clippy)
        CMD=cargo_clippy
        ;;
    *)
        echo "Unknown operation: \"${op}\""
        exit 1
        ;;
esac

echo "Operation is: ${CMD}"

# On src/
$CMD

# Check examples/
for dir in examples/*/
do
    (
    dir=${dir%*/}
    cd "${dir%*/}" || exit
    $CMD
    )
done

(
cd verify/verify || exit
$CMD
)

