TYPE game_pick_rowType RECORD
   login CHAR(10),
   name CHAR(30),
   pick INTEGER,
   point CHAR(10)
END RECORD

FUNCTION do_game_pick(id)
DEFINE id INTEGER
DEFINE game RECORD
   id INTEGER,
   team1 CHAR(20),
   score1 INTEGER,
   team2 CHAR(20),
   score2 INTEGER,
   city CHAR(30),
   stadium CHAR(30),
   kickoff DATETIME YEAR TO MINUTE
END RECORD
DEFINE sql STRING
DEFINE i INTEGER
DEFINE firstname, surname CHAR(30)
DEFINE game_pick_row game_pick_rowType
DEFINE game_pick_arr DYNAMIC ARRAY OF game_pick_rowType
DEFINE cb ui.ComboBox

   OPEN WINDOW game_pick WITH FORM "game_pick"
   
   LET game.id = id

   LET sql = "SELECT t1.tm_name, gm_score1, t2.tm_name, gm_score2, vn_city, vn_stadium, gm_kickoff ",
             "FROM game ",
             "LEFT OUTER JOIN venue ON venue.vn_id = game.gm_venue ",
             "LEFT OUTER JOIN team AS t1 ON t1.tm_id = game.gm_team1 ",
             "LEFT OUTER JOIN team AS t2 ON t2.tm_id = game.gm_team2 ",
             "WHERE game.gm_id = ? "
             
   DECLARE game_curs CURSOR FROM sql

   OPEN game_curs USING game.id
   FETCH game_curs INTO game.team1, game.score1, game.team2, game.score2, game.city, game.stadium, game.kickoff

   DISPLAY game.team1 CLIPPED TO team1
   DISPLAY game.score1 USING "<&" TO score1
   DISPLAY game.team2 CLIPPED TO team2
   DISPLAY game.score2 USING "<&" TO score2
   DISPLAY SFMT("%1 (%2)", game.stadium CLIPPED, game.city CLIPPED) TO venue
   DISPLAY game.kickoff TO kickoff

   LET sql = "SELECT player.pl_login, '', pick.pk_pick, pick.pk_point, player.pl_firstname, player.pl_surname ",
             "FROM pick, player ",
             "WHERE pick.pk_game = ? ",
             "AND pick.pk_login = player.pl_login ",
             "ORDER BY player.pl_login "
   DECLARE game_pick_curs CURSOR FROM sql

   CALL game_pick_arr.clear()
   LET i = 0
   FOREACH game_pick_curs USING game.id INTO game_pick_row.*, firstname, surname
      LET i = i + 1
      LET game_pick_row.name = SFMT("%1 %2", firstname CLIPPED, surname CLIPPED)
      LET game_pick_arr[i].* = game_pick_row.*
      IF game_pick_arr[i].point > 0 THEN
         LET game_pick_arr[i].point = "accept"
      ELSE
         LET game_pick_arr[i].point = "cancel"
      END IF
   END FOREACH

   LET cb =ui.ComboBox.forName("formonly.pick")
   CALL cb.clear()
   CALL cb.addItem(1,game.team1)
   CALL cb.addItem(0,"Draw")
   CALL cb.addItem(-1, game.team2)
   DIALOG
      DISPLAY ARRAY game_pick_arr TO game_pick_scr.*
         #ON ACTION player_pick
         #   CALL do_player_pick(game_pick_arr[DIALOG.getCurrentRow("game_pick_scr")].login)
      END DISPLAY

      ON ACTION cancel
         EXIT DIALOG
   END DIALOG

   CLOSE WINDOW game_pick
END FUNCTION
