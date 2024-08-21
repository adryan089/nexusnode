#!/bin/bash

echo "Start Nexus Node..."
echo "Intalling Package.."
sudo apt update -y && sudo apt upgrade -y && sudo apt install cmake -y && sudo apt install build-essential -y && sudo apt install pkg-config -y && sudo apt install libssl-dev -y && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo "Install Done!"
echo "Installing Script"
. "$HOME/.cargo/env"
rustup target add riscv32i-unknown-none-elf
RUST_BACKTRACE=1
cargo install --git https://github.com/nexus-xyz/nexus-zkvm cargo-nexus --tag 'v0.2.2'
cargo nexus new nexus-project && cd nexus-project && cd src && rm -rf main.rs && cat <<EOT >> main.rs
#![no_std]
#![no_main]

fn fib(n: u32) -> u32 {
    match n {
        0 => 0,
        1 => 1,
        _ => fib(n - 1) + fib(n - 2),
    }
}

#[nexus_rt::main]
fn main() {
    let n = 7;
    let result = fib(n);
    assert_eq!(result, 13);
}
EOT
echo "Install Done!"

echo "Run Nexus"
cargo nexus run

echo "Run Nexus Prove"
cargo nexus prove

echo "cargo nexus verify"
cargo nexus verify
