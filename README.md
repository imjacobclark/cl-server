# cl-servers
A variety of servers implemented in Common Lisp

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
$ sbcl --load http-server.lisp --eval "(server)"
```
