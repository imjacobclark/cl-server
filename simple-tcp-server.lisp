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
; Receive buffer length
(defparameter *receive-buffer-lenth* 1)
; Buffer to recieve data sent from the client as an octet stream
(defparameter *receive-buffer* (make-array *receive-buffer-lenth* :element-type '(unsigned-byte 8) :initial-element 0 :adjustable :fill-pointer))

(defun force-print-buffer(data)
  (format t data)
  (force-output t))

(defun read-into-buffer(buffer socket bytes-left)
  ; Dynamically sized buffer
  (adjust-array buffer (list (1+ (length buffer))) :initial-element 0)
  (cond 
    ; If there are no bytes left - we've reached the end of the input - print
    ((= bytes-left 0) (force-print-buffer (octets-to-string buffer)))
    ; There are bytes left, recurse until there are not
    (t (read-into-buffer buffer socket (nth-value 1 (sb-bsd-sockets:socket-receive socket buffer (length buffer)))))))
 
; Bind our inet-socket to 0.0.0.0:8080
(sb-bsd-sockets:socket-bind *socket* *address* *port*)

; Start the socket listening on 0.0.0.0:8080 for connections
(sb-bsd-sockets:socket-listen *socket* *socket-backlog*)

; Loop forever
(loop
  (let (
      ; Accept incoming client connections
      (accepted-socket (sb-bsd-sockets:socket-accept *socket*)))
    ; Read octet stream into buffer recursively
    (fill *receive-buffer* 0)
    (read-into-buffer *receive-buffer* accepted-socket *receive-buffer-lenth*)
    ; Respond to accepted client connections with a UTF-8 string of "hi" with length 2
    (sb-bsd-sockets:socket-send accepted-socket *response* *response-length*)
    ; Close the client connection
    (sb-bsd-sockets:socket-close accepted-socket)))