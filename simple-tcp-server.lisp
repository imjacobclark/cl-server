(require 'sb-bsd-sockets)

; Create an inet-socket instance
(defparameter *socket* (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp))
; Define our address to be 0.0.0.0 (public interface)
(defparameter *address* '(0 0 0 0))
; Define our port to be 8080
(defparameter *port* 8080)
; Connections to hold on the backlog
(defparameter *socket-backlog* 100)
; Response to emit from the server
(defparameter *response* "hi")
; Length of the response
(defparameter *response-length* (length *response*))

; Bind our inet-socket to 0.0.0.0:8080
(sb-bsd-sockets:socket-bind *socket* *address* *port*)

; Start the socket listening on 0.0.0.0:8080 for connections
(sb-bsd-sockets:socket-listen *socket* *socket-backlog*)

; Loop forever
(loop
  (let (
      ; Accept incoming client connections
      (accepted-socket (sb-bsd-sockets:socket-accept *socket*)))
    ; Respond to accepted client connections with a UTF-8 string of "hi" with length 2
    (sb-bsd-sockets:socket-send accepted-socket *response* *response-length* :external-format :utf-8)
    ; Close the client connection
    (sb-bsd-sockets:socket-close accepted-socket)))