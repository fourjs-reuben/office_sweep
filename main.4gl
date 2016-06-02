
GLOBALS "global.4gl"




MAIN
   WHENEVER ANY ERROR STOP
   CALL STARTLOG("sweep.log")
   OPTIONS FIELD ORDER FORM
   OPTIONS INPUT WRAP

   CONNECT TO "sweep"
   CLOSE WINDOW SCREEN
   
   OPEN WINDOW sweep WITH FORM "main"

   CALL do_motd()
  
   MENU   
      BEFORE MENU
         CALL menu_state(DIALOG)

      ON ACTION register
         CALL do_register(TRUE)

      ON ACTION update
         CALL do_register(FALSE)

      ON ACTION login
         CALL do_login()
         DISPLAY get_name() TO name
         CALL menu_state(DIALOG)

      ON ACTION logoff
         INITIALIZE login TO NULL
         CLEAR name
         CALL menu_state(DIALOG)

      ON ACTION pick
         CALL do_pick()

      ON ACTION result
         CALL do_result(login)

      ON ACTION leaderboard
         CALL do_leaderboard()

      ON ACTION rules
         CALL do_rules()

      ON ACTION admin
         CALL do_admin()

      ON ACTION close
         EXIT MENU

   END MENU
      
   CLOSE WINDOW sweep
END MAIN

PRIVATE FUNCTION menu_state(d)
DEFINE d ui.Dialog

   CALL d.setActionActive("register", login IS NULL)
   CALL d.setActionActive("login", login IS NULL)
   CALL d.setActionActive("update", login IS NOT NULL)
   CALL d.setActionActive("logoff", login IS NOT NULL)
   
   CALL d.setActionActive("pick", login IS NOT NULL)
   CALL d.setActionActive("result", login IS NOT NULL)
   
   CALL d.setActionHidden("register", login IS NOT NULL)
   CALL d.setActionHidden("login", login IS NOT NULL)
   CALL d.setActionHidden("update", login IS NULL)
   CALL d.setActionHidden("logoff", login IS NULL)

   CALL d.setActionHidden("admin", login IS NULL OR login != 'admin')
   
END FUNCTION

FUNCTION get_name()
DEFINE firstname, surname CHAR(30)
   SELECT pl_firstname, pl_surname
   INTO  firstname, surname
   FROM player
   WHERE pl_login = login

   IF status = NOTFOUND THEN
      RETURN ""
   ELSE
      RETURN SFMT("%1 %2", firstname CLIPPED, surname CLIPPED)
   END IF
END FUNCTION

FUNCTION do_motd()
DEFINE line STRING
DEFINE sb base.StringBuffer
DEFINE ch base.Channel

   LET ch = base.Channel.create()
   LET sb = base.StringBuffer.create()
   CALL ch.openFile("motd.txt","r")
   WHILE TRUE
      LET line =  ch.readLine()
      IF line IS NULL THEN
         EXIT WHILE
      END IF
      CALL sb.append(line)
      CALL sb.append("\n")
   END WHILE
   CALL ch.close()
   DISPLAY sb.toString() TO  motd
END FUNCTION
