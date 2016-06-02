GLOBALS "global.4gl"

TYPE resultType RECORD
   game INTEGER,
   team1 INTEGER,
   pick INTEGER,
   team2 INTEGER,
   score1 INTEGER,
   score2 INTEGER,
   result CHAR(10)
END RECORD

FUNCTION do_result(l_login)
DEFINE result_rec resultType
DEFINE result_arr DYNAMIC ARRAY OF resultType
DEFINE sql STRING
DEFINE i INTEGER
DEFINE now DATETIME YEAR TO MINUTE
DEFINE l_login CHAR(10)

   OPEN WINDOW result WITH FORM "result"

   LET now = get_now_utc()

   LET sql = "SELECT gm_id, gm_team1, pk_pick, gm_team2, gm_score1, gm_score2, pk_point ",
             "FROM game LEFT OUTER JOIN pick ON game.gm_id = pick.pk_game AND pick.pk_login = ? ",
             "WHERE game.gm_kickoff < ? ",
             "ORDER BY gm_kickoff"

   DECLARE result_curs CURSOR  FROM sql

   LET i = 0
   FOREACH result_curs USING l_login, now INTO result_rec.*
      LET i = i + 1
      LET result_arr[i].* = result_rec.*
      IF result_arr[i].result > 0 THEN
         LET result_arr[i].result = "accept"
      ELSE
         LET result_arr[i].result = "cancel"
      END IF
   END FOREACH

   DIALOG
      DISPLAY ARRAY result_arr TO result_scr.*
        BEFORE DISPLAY
            CALL DIALOG.setActionActive("game_pick", result_arr.getLength()>0)
            
         ON ACTION game_pick
            CALL do_game_pick(result_arr[DIALOG.getCurrentRow("result_scr")].game)
      END DISPLAY
        
      ON ACTION cancel
         EXIT DIALOG
         
      ON ACTION close
         EXIT PROGRAM 1
   END DIALOG 

   CLOSE WINDOW result

END FUNCTION
