IMPORT os
IMPORT util
GLOBALS "global.4gl"

DEFINE iotd_arr DYNAMIC ARRAY OF STRING
DEFINE last_iotd INTEGER

MAIN
DEFINE w ui.Window

    WHENEVER ANY ERROR STOP
    CALL STARTLOG("sweep.log")
    OPTIONS FIELD ORDER FORM
    OPTIONS INPUT WRAP

    CONNECT TO "sweep"
    SET LOCK MODE TO WAIT 30
    CLOSE WINDOW SCREEN
   
    OPEN WINDOW sweep WITH FORM "main"
    LET w = ui.Window.getCurrent()

    -- For testing purposes, if env variable set, use that for login
    IF NOT is_blank(FGL_GETENV("SWEEP_LOGIN")) >0 THEN
        LET login = FGL_GETENV("SWEEP_LOGIN")
        CALL w.setText(SFMT("Office Sweep - Logged in as %1",get_name()))
    END IF 

    -- Message and image of the day
    CALL init_iotd()
    CALL do_motd()
    CALL do_iotd()
  
    MENU   
        BEFORE MENU
            CALL menu_state(DIALOG)

        ON ACTION login
            CALL do_login()
            CALL w.setText(SFMT("Office Sweep - Logged in as %1",get_name()))
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

        ON ACTION register
            CALL do_register(TRUE)

        ON ACTION update
            CALL do_register(FALSE)

        ON ACTION iotd
            CALL do_iotd()

        ON ACTION logoff
            INITIALIZE login TO NULL
            CALL w.setText("Office Sweep")
            CALL menu_state(DIALOG)

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



-- motd = Message of The Day
FUNCTION do_motd()
DEFINE motd TEXT

    LOCATE motd IN FILE "motd.txt"
    DISPLAY BY NAME motd
END FUNCTION

-- iotd = Image of The Day


FUNCTION init_iotd()
DEFINE hdl INTEGER
DEFINE l_filename STRING
DEFINE l_ext STRING

    CALL iotd_arr.clear()
    LET hdl = os.Path.dirOpen("iotd")
    WHILE TRUE
        LET l_filename = os.Path.dirNext(hdl)
        IF l_filename IS  NULL THEN
            EXIT WHILE
        END IF
        LET l_ext = os.Path.extension(l_filename)
        LET l_ext = l_ext.toLowerCase()
        IF l_ext = "png" 
        OR l_ext = "jpg" THEN
            LET iotd_arr[iotd_arr.getLength()+1] = l_filename
        END IF
    END WHILE
END FUNCTION



FUNCTION do_iotd()
DEFINE i INTEGER

    IF iotd_arr.getLength() = 0 THEN
        DISPLAY "fa-photo" TO iotd
    ELSE
        
        WHILE TRUE
            LET i = util.Math.rand(iotd_arr.getLength())+1
            -- Avoid last iotd
            IF iotd_arr.getLength() > = 2 THEN
                IF i = last_iotd THEN
                    CONTINUE WHILE
                END IF
            END IF
            EXIT WHILE
        END WHILE
        DISPLAY SFMT("iotd/%1",iotd_arr[i]) TO iotd
        LET last_iotd = i
    END IF
END FUNCTION
