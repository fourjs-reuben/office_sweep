GLOBALS "global.4gl"

FUNCTION do_rules()

   OPEN WINDOW rules WITH FORM "rules"  
   CALL display_rules()
   
   MENU ""
      ON ACTION cancel
         EXIT MENU
      ON ACTION close
         EXIT MENU
   END MENU

   CLOSE WINDOW rules
END FUNCTION



FUNCTION display_rules()
DEFINE line STRING
DEFINE sb base.StringBuffer
DEFINE ch base.Channel

   LET ch = base.Channel.create()
   LET sb = base.StringBuffer.create()
   CALL ch.openFile("rules.txt","r")
   WHILE TRUE
      LET line =  ch.readLine()
      IF line IS NULL THEN
         EXIT WHILE
      END IF
      CALL sb.append(line)
      CALL sb.append("\n")
   END WHILE
   CALL ch.close()
   DISPLAY sb.toString() TO  rules
END FUNCTION
