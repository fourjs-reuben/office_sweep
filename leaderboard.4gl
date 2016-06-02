TYPE leaderboardType RECORD
   login CHAR(10),
   name CHAR(40),
   score INTEGER,
   rank INTEGER
END RECORD

DEFINE leaderboard_arr DYNAMIC ARRAY OF leaderboardType
DEFINE leaderboard_row leaderboardType

FUNCTION do_leaderboard()
   OPEN WINDOW leaderboard WITH FORM "leaderboard"

   CALL get_leaderboard()

   -- replace with ON FILL if entries get large
   DIALOG
      DISPLAY ARRAY leaderboard_arr TO leaderboard_scr.*
      END DISPLAY

      BEFORE DIALOG
        CALL DIALOG.setActionActive("result", leaderboard_arr.getLength()>0)
        CALL DIALOG.setActionActive("player_pick", leaderboard_arr.getLength()>0)

      ON ACTION result
         CALL do_result(leaderboard_arr[DIALOG.getCurrentRow("leaderboard_scr")].login)

      ON ACTION player_pick
         CALL do_player_pick(leaderboard_arr[DIALOG.getCurrentRow("leaderboard_scr")].login)

      ON ACTION cancel
         EXIT DIALOG
   END DIALOG
   CLOSE WINDOW leaderboard
END FUNCTION

PRIVATE FUNCTION get_leaderboard()
DEFINE sql STRING
DEFINE firstname, surname CHAR(30)
DEFINE i INTEGER

   LET sql = "SELECT pl_login, '', pl_score, pl_rank, pl_firstname, pl_surname ",
             "FROM player ",
             "WHERE pl_login != 'admin' ",
             "ORDER BY pl_rank, pl_login "

   DECLARE leaderboard_curs CURSOR FROM sql

   CALL leaderboard_arr.clear()
   LET i = 0
   FOREACH leaderboard_curs INTO leaderboard_row.*, firstname, surname
      LET leaderboard_row.name= SFMT("%1 %2", firstname CLIPPED, surname CLIPPED)
      LET i = i + 1
      LET leaderboard_arr[i].*=leaderboard_row.*
   END FOREACH
END FUNCTION
