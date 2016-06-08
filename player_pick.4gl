TYPE player_pick_rowType RECORD
game INTEGER,
team1 CHAR(20),
pick INTEGER,
team2 CHAR(20),
venue STRING,
kickoff DATETIME YEAR TO MINUTE
END RECORD

FUNCTION do_player_pick(player_login)
DEFINE player_login CHAR(10)
DEFINE player RECORD
   login CHAR(10),
   firstname CHAR(30),
   surname CHAR(30)
END RECORD
DEFINE sql STRING
DEFINE i INTEGER
DEFINE stadium, city CHAR(30)
DEFINE player_pick_row player_pick_rowType
DEFINE player_pick_arr DYNAMIC ARRAY OF player_pick_rowType

   OPEN WINDOW player_pick WITH FORM "player_pick"
   LET player.login= player_login

   LET sql = "SELECT pl_firstname, pl_surname ",
             "FROM player ",
             "WHERE pl_login = ? "

   DECLARE player_curs CURSOR FROM sql
   OPEN player_curs USING player.login
   FETCH player_curs INTO player.firstname, player.surname

   DISPLAY player.login TO login
   DISPLAY SFMT("%1 %2", player.firstname CLIPPED, player.surname CLIPPED ) TO name;

   LET sql = "SELECT gm_id, t1.tm_name, pk_pick, t2.tm_name, '', gm_kickoff, vn_stadium, vn_city ",
             "FROM pick, game ",
             "LEFT OUTER JOIN team as t1 ON t1.tm_id = game.gm_team1 ",
             "LEFT OUTER JOIN team as t2 ON t2.tm_id = game.gm_team2 ", 
             "LEFT OUTER JOIN venue ON venue.vn_id = game.gm_venue ",
             "WHERE pick.pk_login = ? ",
             "AND pk_game = gm_id ",
             "ORDER BY gm_id "

   DECLARE player_pick_curs CURSOR FROM sql
   LET i = 0
   CALL player_pick_arr.clear()
   FOREACH player_pick_curs USING player.login INTO player_pick_row.*, stadium, city
      LET i = i + 1
      LET player_pick_arr[i].*= player_pick_row.*
      LET player_pick_arr[i].venue= SFMT("%1 (%2)", stadium CLIPPED, city CLIPPED)
   END FOREACH

   DIALOG
      DISPLAY ARRAY player_pick_arr TO player_pick_scr.*
      END DISPLAY
      ON ACTION cancel
          EXIT DIALOG
   END DIALOG
   CLOSE WINDOW player_pick
END FUNCTION

   
