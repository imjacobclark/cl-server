(require 'sb-bsd-sockets)

; Create an inet-socket instance
(defparameter *socket* (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp))
; Define our address to be 0.0.0.0 (public interface)
(defparameter *address* '(0 0 0 0))
; Define our port to be 8080
(defparameter *port* 8080)

; Bind our inet-socket to 0.0.0.0:8080
(sb-bsd-sockets:socket-bind *socket* *address* *port*)

; Start the socket listening on 0.0.0.0:8080 for connections
(sb-bsd-sockets:socket-listen *socket* 1)

; Loop forever
(loop
  (let (
      ; Accept incoming client connections
      (accepted-socket (sb-bsd-sockets:socket-accept *socket*)))
    ; Respond to accepted client connections with a UTF-8 string of "hi" with length 2
    (sb-bsd-sockets:socket-send accepted-socket "hi" 2 :external-format :utf-8)
    ; Close the client connection
    (sb-bsd-sockets:socket-close accepted-socket)))