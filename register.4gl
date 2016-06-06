GLOBALS "global.4gl"

FUNCTION do_register(new_mode)
DEFINE new_mode BOOLEAN
DEFINE password, password2 CHAR(10)
DEFINE firstname CHAR(30)
DEFINE surname CHAR(30)
DEFINE email CHAR(30)
DEFINE encrypted_password STRING

DEFINE count INTEGER

   OPEN WINDOW register WITH FORM "register"

   IF new_mode THEN
      INITIALIZE login, password, password2, firstname, surname, email TO NULL
   ELSE
      SELECT pl_password, pl_firstname, pl_surname, pl_email
      INTO encrypted_password, firstname, surname, email
      FROM player
      WHERE pl_login = login

      LET password = decrypt_password(encrypted_password CLIPPED)
      LET password2= password
   END IF

   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT BY NAME login, password, password2, firstname, surname, email ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
      END INPUT
      
      ON ACTION accept
         IF new_mode THEN
            IF is_blank(login) THEN
               ERROR "Login must be entered"
               NEXT FIELD login
            END IF
            SELECT COUNT(*) INTO count FROM player WHERE pl_login = login
            IF count > 0 THEN
               ERROR "Login has already been used"
               NEXT FIELD login
            END IF
         END IF
         
         -- check login unique
         IF is_blank(password) THEN
            ERROR "Password must be entered"
            NEXT FIELD password
         END IF
         IF password = password2 THEN
            #OK
         ELSE
            ERROR "Check the entered password"
            NEXT FIELD password
         END IF
         IF is_blank(firstname) THEN
            ERROR "Firstname must be entered"
            NEXT FIELD firstname
         END IF
         IF is_blank(surname) THEN
            ERROR "Surname must be entered"
            NEXT FIELD surname
         END IF

         LET encrypted_password = encrypt_password(password CLIPPED)
         IF new_mode THEN
            INSERT INTO player (pl_login, pl_password, pl_firstname, pl_surname, pl_email)
            VALUES(login, encrypted_password, firstname, surname, email)
         ELSE
             UPDATE player
             SET pl_password = encrypted_password,
                 pl_firstname = firstname,
                 pl_surname = surname,
                 pl_email = email
               WHERE pl_login = login
         END IF
         EXIT DIALOG
         
      ON ACTION cancel
         IF new_mode THEN
            INITIALIZE login TO NULL
         END IF
         EXIT DIALOG

      ON ACTION close
         IF new_mode THEN
            INITIALIZE login TO NULL
         END IF
         EXIT DIALOG
         
   END DIALOG

   CLOSE WINDOW register

END FUNCTION
