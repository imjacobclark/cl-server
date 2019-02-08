# cl-server
A Common Lisp HTTP server

Depends on SBCL's sb-bsd-sockets

## Requirements

* OS X
* SBCL

## Running

### Simple TCP server

```
$ sbcl --load simple-tcp-server.lisp
```

### Full HTTP server

```
$ sbcl --load server.lisp --eval "(server)"
```