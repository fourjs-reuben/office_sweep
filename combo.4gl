FUNCTION combo_team(cb)
DEFINE cb ui.ComboBox
DEFINE sql STRING
TYPE teamType RECORD
   id INTEGER,
   name CHAR(20)
END RECORD
DEFINE team_rec teamType

   LET sql = "SELECT tm_id, tm_name ",
             "FROM team ",
             "ORDER BY tm_name"

   DECLARE team_curs CURSOR FROM sql

   CALL cb.clear()
   FOREACH team_curs INTO team_rec.*
      CALL cb.addItem(team_rec.id, team_rec.name);
   END FOREACH
END FUNCTION

FUNCTION combo_venue(cb)
DEFINE cb ui.ComboBox
DEFINE sql STRING
TYPE venueType RECORD
   id INTEGER,
   city CHAR(40),
   stadium CHAR(40)
END RECORD
DEFINE venue_rec venueType

   LET sql = "SELECT vn_id, vn_city, vn_stadium ",
            "FROM venue ",
            "ORDER BY vn_id"

   DECLARE venue_curs CURSOR FROM sql

   CALL cb.clear()
   FOREACH venue_curs INTO venue_rec.*
      CALL cb.addItem(venue_rec.id, SFMT("%1 (%2)",venue_rec.stadium CLIPPED, venue_rec.city CLIPPED))
   END FOREACH
END FUNCTION

FUNCTION combo_gametype(cb)
DEFINE cb ui.ComboBox
DEFINE sql STRING
TYPE gametypeType RECORD
   id INTEGER,
   name CHAR(30)
END RECORD
DEFINE gametype_rec gametypeType

   LET sql = "SELECT gt_id, gt_name ",
             "FROM gametype ",
             "ORDER BY gt_id "

   DECLARE gametype_curs CURSOR FROM sql
   CALL cb.clear()
   FOREACH gametype_curs INTO gametype_rec.*
      CALL cb.addItem(gametype_rec.id, gametype_rec.name)
   END FOREACH
END FUNCTION

FUNCTION combo_pick(cb)
DEFINE cb ui.ComboBox

   CALL cb.clear()
   CALL cb.addItem(-1, "will lose to")
   CALL cb.addItem(0,  "will draw with")
   CALL cb.addItem(1,  "will beat")
END FUNCTION

FUNCTION combo_gameselect(cb)
DEFINE cb ui.ComboBox
DEFINE sql STRING
DEFINE l_gm_id INTEGER
DEFINE l_team1, l_team2 CHAR(20)

   LET sql = "SELECT gm_id, t1.tm_name, t2.tm_name ",
             "FROM game ",
             "LEFT OUTER JOIN team t1 ON gm_team1 = t1.tm_id ",
             "LEFT OUTER JOIN team t2 ON gm_team2 = t2.tm_id ", 
             "ORDER BY gm_id "

   DECLARE gameselect_curs CURSOR FROM sql
   CALL cb.clear()
   FOREACH gameselect_curs INTO l_gm_id, l_team1, l_team2
      CALL cb.addItem(l_gm_id, SFMT("%1 vs %2", l_team1 CLIPPED, l_team2 CLIPPED))
   END FOREACH
END FUNCTION