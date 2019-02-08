(require 'sb-bsd-sockets)

(defparameter *address* '(0 0 0 0))
(defparameter *port* 8080)
(defparameter *body* "<html><head><title>cl-server</title><body><h1>cl-server</h1><p>inet-socket please!</body></html>")
(defparameter *body-length* (length *body*))
(defparameter *crlf* (format nil "~C~C" #\return #\linefeed))

(defparameter *response*
  (concatenate 'string
   "HTTP/1.1 200 OK" *crlf*
   (format nil "Content-Length: ~a" *body-length*) *crlf*
   "Content-Type: text/html" *crlf*
   "X-Powered-By: cl-server" *crlf*
   *crlf*
   *body*))

(defparameter *response-length* (length *response*))

(defun format-line(line)
  (format t "~a~%" line))

(defun print-stream(stream)
    (loop for line = (read-line stream)
         while line 
         do (format-line line))
    (print "end")
)

(defun ok(stream)
  ;; (print-stream stream)
  (write-string *response* stream) 
  (finish-output stream)
)

(defun stream-connection (socket) 
    (sb-bsd-sockets:socket-make-stream (sb-bsd-sockets:socket-accept socket) :output t :input t))

(defun event-loop (socket)
  (loop  
    (with-open-stream 
      (stream (stream-connection socket))
      (ok stream)
    )
  ))

(defun create-socket ()
  (let 
    ((socket (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp)))
    (setf (sb-bsd-sockets:sockopt-reuse-address socket) t)
    (sb-bsd-sockets:socket-bind socket *address* *port*)
    (sb-bsd-sockets:socket-listen socket 1)
    socket))

(defun main ()
  (let ((socket (create-socket)))
    (unwind-protect
        (event-loop socket)
        (print "closing sockets...")
        (sb-bsd-sockets:socket-close socket)
        (print "bye"))))
