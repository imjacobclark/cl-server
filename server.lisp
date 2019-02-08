(require 'sb-bsd-sockets)

(defparameter *response-content-length* 5)
(defparameter *address* '(0 0 0 0))
(defparameter *port* 8080)

(defparameter CRLF (format nil "~C~C" #\return #\linefeed))

(defparameter *response*
  (concatenate 'string
   "HTTP/1.1 200 OK" CRLF
   (format nil "Content-Length: ~a" *response-content-length*) CRLF
   "Content-Type: text/html" CRLF
   CRLF
   (coerce "Hello" 'string)))

(defparameter *response-length* (length *response*))

(defun stream-connection (socket) 
    (sb-bsd-sockets:socket-make-stream (sb-bsd-sockets:socket-accept socket) :output t :input t))

(defun accept-respond-close (socket)
  (let ((accepted-socket (sb-bsd-sockets:socket-accept socket)))
    (unwind-protect
        (sb-bsd-sockets:socket-send accepted-socket *response* *response-length* :external-format :utf-8)
        (sb-bsd-sockets:socket-close accepted-socket))))

(defun event-loop (socket)
  ;; (loop (with-open-stream (stream (stream-connection socket))
  ;;   (print (read-line stream))))
  (accept-respond-close socket)
  (event-loop socket))

(defun create-socket ()
  (let ((socket (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp)))
    (setf (sb-bsd-sockets:sockopt-reuse-address socket) t)
    (sb-bsd-sockets:socket-bind socket *address* *port*)
    (sb-bsd-sockets:socket-listen socket 1)
    socket))

(defun main ()
  (let ((socket (create-socket)))
    (unwind-protect
        (event-loop socket)
        (sb-bsd-sockets:socket-close socket))))
