![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)

# PDP-0, a PDP-1/TX-0 Inspired 4-bit CPU

With ~ 200 gates and 8-inputs, 8-outputs, can we make a full CPU?  If
we depend on external memory, we can do like the Intel 4004 and
multiplex nibbles in and out.  However for this submission, we keep
the memory on-chip which puts some severe constaints on the size of
everything.  The only architeture that I could managed in that space
is one that relies heavily on self-modifying code, like the beloved
DEC PDP-8.

Features:
- Updatable code and data storage
- Instructions include load, store, alu, and conditional branches
- Can execute Fibonacci

CPU state
- 8 words of 6-bit memory, split into 2-bit of instruction and 4-bit
  of operand.
- 3-bit PC
- 4-bit Accumulator (ACC)

## The Instruction Set

All instructions have an opcode and an argument.

- `load` value (loads value to the accumulator)
- `store` address (stores the accumulator at the address, top bit ignored)
- `add` value  (adds value to the accumulator)
- `brzero` address (branches to address if the accumulator is zero)

Obviously this is very limiting, but it does show the basic structure
and could probably be tweaked to be more general with more time (but
space is limited).

## Example Fibonacci Program

``` C
 int a = 1, b = 1;
 for (;;) {
   int t = a;
   a += b;
   b = t;
   if (b == 8) for (;;)
 }
```

``` assembly
0: load 1  // a is here
1: store 4 // store to t at address 4

2: add 1   // b is here
3: store 0 // Update a at address 0

4: load _  // t is here, value overwritten
5: store 2 // update b

6: add 8  //  -8 == 8
7: brzero 7 // if acc - 8 == 0 we stop
// otherwise roll over to 0
```

Execution trace:

```
$ make -C src -f test.mk | tail -50 | head -17
        Running 0 (insn 0,  8)
00500  pc 1 acc  8
        Running 1 (insn 1,  4)
00510  pc 2 acc  8
        Running 2 (insn 2,  5)
00520  pc 3 acc 13
        Running 3 (insn 1,  0)
00530  pc 4 acc 13
        Running 4 (insn 0,  8)
00540  pc 5 acc  8
        Running 5 (insn 1,  2)
00550  pc 6 acc  8
        Running 6 (insn 2,  8)
00560  pc 7 acc  0
        Running 7 (insn 3,  7)
        Running 7 (insn 3,  7)
        Running 7 (insn 3,  7)
```

We actually computed fib all the way to 13 (largest that will fit in 4-bits).

<p>

# Genenic Tiny Tapeout README.md follows belowe

<p>


# Tiny Tapeout Verilog Project Template

- [Read the documentation for project](docs/info.md)

## What is Tiny Tapeout?

TinyTapeout is an educational project that aims to make it easier and cheaper than ever to get your digital designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.

## Verilog Projects

1. Add your Verilog files to the `src` folder.
2. Edit the [info.yaml](info.yaml) and update information about your project, paying special attention to the `source_files` and `top_module` properties. If you are upgrading an existing Tiny Tapeout project, check out our [online info.yaml migration tool](https://tinytapeout.github.io/tt-yaml-upgrade-tool/).
3. Edit [docs/info.md](docs/info.md) and add a description of your project.
4. Optionally, add a testbench to the `test` folder. See [test/README.md](test/README.md) for more information.

The GitHub action will automatically build the ASIC files using [OpenLane](https://www.zerotoasiccourse.com/terminology/openlane/).

## Enable GitHub actions to build the results page

- [Enabling GitHub Pages](https://tinytapeout.com/faq/#my-github-action-is-failing-on-the-pages-part)

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://tinytapeout.com/discord)
- [Build your design locally](https://docs.google.com/document/d/1aUUZ1jthRpg4QURIIyzlOaPWlmQzr-jBn3wZipVUPt4)

## What next?

- [Submit your design to the next shuttle](https://app.tinytapeout.com/).
- Edit [this README](README.md) and explain your design, how it works, and how to test it.
- Share your project on your social network of choice:
  - LinkedIn [#tinytapeout](https://www.linkedin.com/search/results/content/?keywords=%23tinytapeout) [@TinyTapeout](https://www.linkedin.com/company/100708654/)
  - Mastodon [#tinytapeout](https://chaos.social/tags/tinytapeout) [@matthewvenn](https://chaos.social/@matthewvenn)
  - X (formerly Twitter) [#tinytapeout](https://twitter.com/hashtag/tinytapeout) [@matthewvenn](https://twitter.com/matthewvenn)
