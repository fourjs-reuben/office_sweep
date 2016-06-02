GLOBALS "global.4gl"


FUNCTION do_pick()
TYPE pickType RECORD
   game INTEGER,
   team1 INTEGER,
   pick SMALLINT,
   team2 INTEGER,
   venue INTEGER,
   kickoff DATETIME YEAR TO MINUTE,
   gametype INTEGER
END RECORD
DEFINE pick_rec pickType
DEFINE pick_arr DYNAMIC ARRAY OF pickType
DEFINE now DATETIME YEAR TO MINUTE
DEFINE sql STRING
DEFINE i INTEGER
DEFINE action STRING
DEFINE update_ok SMALLINT


   LET now = get_now_utc()

   LET sql = "SELECT gm_id, gm_team1, pk_pick, gm_team2, gm_venue, gm_kickoff, gm_gametype ",
             "FROM game ", 
             "LEFT OUTER JOIN pick ON game.gm_id = pick.pk_game AND pick.pk_login = ?  ",
             "WHERE game.gm_kickoff > ? ",
             "ORDER BY gm_kickoff"

   DECLARE pick_curs CURSOR  FROM sql

   LET i = 0
   FOREACH pick_curs USING login, now INTO pick_rec.*
      LET i = i + 1
      LET pick_arr[i].* = pick_rec.*
   END FOREACH

   

   OPEN WINDOW pick WITH FORM "pick"

   DISPLAY pick_arr.getLength()
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT ARRAY pick_arr FROM pick_scr.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE, INSERT ROW=FALSE, APPEND ROW=FALSE, DELETE ROW=FALSE)
         ON ACTION game_pick
            CALL do_game_pick(pick_arr[DIALOG.getCurrentRow("pick_scr")].game)
      END INPUT

      ON ACTION accept
         LET action = "accept"
         EXIT DIALOG
         
      ON ACTION cancel
         LET action = "cancel"
         EXIT DIALOG
         
      ON ACTION close
         EXIT PROGRAM 1
   END DIALOG

   CASE action
      WHEN "accept"
        -- do insert
         LET update_ok = TRUE
         BEGIN WORK
         LET now = get_now_utc()
         
         FOR i = 1 TO pick_arr.getLength()
            IF now <= pick_arr[i].kickoff THEN
               IF pick_arr[i].pick IS NOT NULL THEN

                  UPDATE pick
                  SET pk_pick = pick_arr[i].pick
                  WHERE pk_login = login
                  AND pk_game = pick_arr[i].game

                  IF rows_updated() = 0 THEN
                     INSERT INTO pick(pk_login, pk_game, pk_pick)
                     VALUES(login, pick_arr[i].game,pick_arr[i].pick)
                  END IF

                  INSERT INTO pick_audit(pa_login, pa_game, pa_pick, pa_when) 
                  VALUES(login, pick_arr[i].game,pick_arr[i].pick, CURRENT YEAR TO SECOND)
               END IF
            ELSE
               LET update_ok = FALSE
            END IF
         END FOR
         
         COMMIT WORK
         IF NOT update_ok THEN
            CALL FGL_WINMESSAGE("Error","One or more games were not updated as the game has now kicked off","")
         END IF
   END CASE
   CLOSE WINDOW pick
END FUNCTION
