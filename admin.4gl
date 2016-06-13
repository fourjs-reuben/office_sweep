
FUNCTION do_admin()
DEFINE l_gm_id INTEGER
DEFINE l_score1 INTEGER
DEFINE l_score2 INTEGER

    OPEN WINDOW admin WITH FORM "admin"
   
    DIALOG ATTRIBUTES(UNBUFFERED)
        INPUT l_gm_id, l_score1, l_score2 FROM gm_id, score1, score2 ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
            ON CHANGE gm_id
                SELECT gm_score1, gm_score2
                INTO l_score1, l_score2
                FROM game
                WHERE gm_id = l_gm_id

        END INPUT

        ON ACTION update_game_score
            CALL update_game_score(l_gm_id, l_score1, l_score2)
         
        ON ACTION delete_game_score
            CALL update_game_score(l_gm_id, NULL, NULL)
         
        ON ACTION update_leaderboard
            CALL update_leaderboard()

        ON ACTION mail ATTRIBUTES(TEXT="Mail Participants", IMAGE="fa-envelope-o")
            CALL do_mail()
            
        ON ACTION cancel
            EXIT DIALOG
    END DIALOG
    CLOSE WINDOW admin

END FUNCTION



PRIVATE FUNCTION update_game_score(l_gm_id, l_score1, l_score2)
DEFINE l_gm_id INTEGER
DEFINE l_score1 INTEGER
DEFINE l_score2 INTEGER

    BEGIN WORK
    UPDATE game
    SET gm_score1 = l_score1,
        gm_score2 = l_score2
    WHERE gm_id = l_gm_id

    UPDATE game
    SET gm_result = 1 
    WHERE gm_id = l_gm_id AND gm_score1 > gm_score2

    UPDATE game
    SET gm_result = 0
    WHERE gm_id = l_gm_id AND gm_score1 = gm_score2

    UPDATE game
    SET gm_result = -1 
    WHERE gm_id = l_gm_id AND gm_score1 < gm_score2

    UPDATE game
    SET gm_result = NULL
    WHERE gm_id = l_gm_id AND (gm_score1 IS NULL OR gm_score2 IS NULL)

    CALL update_point(l_gm_id)
   
    COMMIT WORK

END FUNCTION



PRIVATE FUNCTION update_point(l_gm_id)
DEFINE sql STRING
DEFINE l_gm_id INTEGER
DEFINE l_idx INTEGER

    LET l_idx = 65 - l_idx

    -- set all points to 0
    UPDATE pick
    SET pk_point = 0
    WHERE pk_game = l_gm_id

    -- Update score if correct
    UPDATE pick
    SET pk_point = (SELECT gt_value FROM gametype, game WHERE gm_id = l_gm_id AND gt_id = gm_gametype)
    WHERE pk_game = l_gm_id
    AND pk_pick = (SELECT gm_result FROM game WHERE gm_id = l_gm_id AND gm_result IS NOT NULL)
    AND pk_pick IS NOT NULL

END FUNCTION



FUNCTION update_leaderboard()
DEFINE l_pl_login CHAR(10)
DEFINE l_pl_score INTEGER
DEFINE l_pl_rank INTEGER


    BEGIN WORK
   
    UPDATE player
    SET pl_score = (SELECT SUM(pk_point) 
                    FROM pick
                   WHERE pk_login = pl_login)
    WHERE 1=1;

    UPDATE player
    SET pl_score = 0
    WHERE pl_score IS NULL;

    DECLARE get_player_curs CURSOR FOR 
    SELECT pl_login, pl_score FROM player WHERE pl_login ! = "admin" 
    FOREACH get_player_curs INTO l_pl_login, l_pl_score
        SELECT COUNT(*) 
        INTO l_pl_rank
        FROM player
        WHERE pl_login != "admin"
        AND pl_score > l_pl_score 

        UPDATE player
        SET pl_rank = (1 + l_pl_rank)
        WHERE pl_login = l_pl_login
    END FOREACH
    COMMIT WORK
END FUNCTION



FUNCTION do_mail()
DEFINE sb base.StringBuffer
DEFINE l_pl_email STRING
DEFINE l_url STRING
CONSTANT SUBJECT="A message from Euro 2016 sweepstake:"
CONSTANT BODY="This e-mail is sent to all UEFA Euro 2016 participants..."

    LET sb = base.StringBuffer.create()
    DECLARE email_list_curs CURSOR FOR SELECT pl_email FROM player
    FOREACH email_list_curs INTO l_pl_email
        IF sb.getLength()> 0 THEN
            CALL sb.append(",")
        END IF
        CALL sb.append(l_pl_email CLIPPED)
    END FOREACH
    
    LET l_url = SFMT("mailto:?bcc=%1&subject=%2&body=%3", sb.toString(), SUBJECT,BODY)
    DISPLAY l_url
    CALL ui.Interface.frontCall("standard","launchurl",l_url,[])
END FUNCTION



-- alternative tie break calculation
{
PRIVATE FUNCTION update_tiebreak(l_login, l_gm_id)
DEFINE sql STRING

   SELECT pl_tiebreak
   INTO l_tiebreak
   FROM player
   WHERE pl_login = l_login

   IF l_tiebreak IS NULL THEN
      LET l_tiebreak = "0000000000000000000000000000000000000000000000000000000000000000"
   END IF
   
   SELECT pk_point 
   FROM pick
   WHERE pk_login = l_login
   AND pk_game = l_gm_id

   IF l_pk_point > 0 THEN
      LET l_tiebreak[65-l_gm_id] = "1"
   ELSE
      LET l_tiebreak[65-l_gm_id] = "0"
   END IF
   
   UPDATE player
   SET pl_tiebreak = l_tiebreak
   WHERE pl_login = l_login

END FUNCTION
}

