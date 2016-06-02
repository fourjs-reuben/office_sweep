GLOBALS "global.4gl"

FUNCTION do_login()
DEFINE password CHAR(10)
   INITIALIZE password TO NULL
   OPEN WINDOW login WITH FORM "login"
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT BY NAME login, password ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
         ON ACTION accept
            IF login_test(password) THEN
               EXIT DIALOG
            ELSE
               ERROR "Invalid password.  Please try again" 
               CALL ERRORLOG(SFMT("Invalid password attempt %1 - %2", login CLIPPED, password CLIPPED))
               NEXT FIELD CURRENT
            END IF
         ON ACTION cancel
            INITIALIZE login TO NULL
            EXIT DIALOG
         ON ACTION close
            INITIALIZE login TO NULL
            EXIT DIALOG
      END INPUT
   END DIALOG
   CLOSE WINDOW login
END FUNCTION

PRIVATE FUNCTION login_test(password_entered)
DEFINE password_test, password_entered STRING
DEFINE sql STRING
DEFINE enc_password STRING

   LET sql = "SELECT pl_password ",
             "FROM player ",
             "WHERE pl_login = ? "

   DECLARE login_curs CURSOR FROM sql
   OPEN login_curs USING login
   FETCH login_curs INTO password_test

   IF status=NOTFOUND THEN
      RETURN FALSE
   END IF

   LET password_test = decrypt_password(password_test CLIPPED)
   RETURN (password_entered CLIPPED = password_test CLIPPED) 
END FUNCTION
