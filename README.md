
To compile JS file to wasm file (Js file are complied using pre-compiled javy)
```
(cd lib/plugins && ./javy build example.js -o example.wasm)
```

To run wasm file from command line.
```
echo '{ "n": 2, "bar": "baz" }' | wasmtime index.wasm
```
Please note that you need to install wasmtime on you machine. https://wasmtime.dev/

To test.
Visit root path and append name param. The greeting message is generated from the WebAssembly code.
```
/?name=kaung
```
