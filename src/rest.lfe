(defmodule rest 
  (behaviour application)
  (export all))

(defun start (type args)
  (www:start 'rest))

(defun stop (state) 'ok )

(defun do
  
  ((#"login")
    (tuple 'relaxed 'anonymous '(#(text #"code")) 
      (match-lambda ((_ _ (list code)) 
        (facebook:login code (lambda (t expires) 
          (app:with_default (lambda (app)
            (tuple 'redirect (maps:get 'location app) 
                   'cookie #"stoken" t "/" expires)))))))))

  ((#"create.session")
    (tuple 'anonymous '(#(text #"stoken") #(text #"lang") #(text #"ua") #(text #"ip"))
      (match-lambda ((app _ (list t lang ua ip))
        (users:create_session t app lang ua ip (lambda (s) s))))))

  ((#"get.session")
    (tuple 'signed_in '()
      (match-lambda ((app u '()) u))))
  
  ((#"get.events")
    (tuple 'signed_in '()
      (match-lambda ((app u '())
        (facebook:with_events u (lambda (events) events))))))

  (((= _ a)) (kit:err 'not_implemented a)))
