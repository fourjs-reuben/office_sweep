MAIN
    
    CONNECT TO "sweep"
    
    CALL create_tables()

    -- Unique to competition
    CALL populate_venue()
    CALL populate_team()
    CALL populate_gametype()
    CALL populate_game()

    -- Populate with admin player only
    CALL populate_player()
END MAIN



FUNCTION create_tables()
    -- Don't care if table not present
    WHENEVER ANY ERROR CONTINUE
    DROP TABLE player
    DROP TABLE team 
    DROP TABLE venue
    DROP TABLE game
    DROP TABLE gametype
    DROP TABLE pick
    DROP TABLE pick_audit
    DROP TABLE league
    DROP TABLE league_member

    WHENEVER ANY ERROR STOP

    CREATE TABLE player (
        pl_login CHAR(10),
        pl_password VARCHAR(128),
        pl_firstname VARCHAR(40),
        pl_surname VARCHAR(40),
        pl_email CHAR(40),
        pl_invitor CHAR(10),
        pl_country CHAR(3),
        pl_score INTEGER,
        pl_tiebreak CHAR(64),
        pl_rank INTEGER);


    CREATE TABLE team (
        tm_id INTEGER,
        tm_name VARCHAR(40),
        tm_colour1 CHAR(7),
        tm_colour2 CHAR(7),
        tm_colour3 CHAR(7));

    CREATE TABLE venue (
        vn_id INTEGER,
        vn_city VARCHAR(40),
        vn_stadium VARCHAR(40));

    CREATE TABLE game (
        gm_id INTEGER,
        gm_gametype INTEGER,
        gm_venue INTEGER,
        gm_team1 INTEGER,
        gm_team2 INTEGER,
        gm_kickoff DATETIME YEAR TO MINUTE,
        gm_score1 INTEGER,
        gm_score2 INTEGER,
        gm_result INTEGER);

    CREATE TABLE gametype(
        gt_id INTEGER,
        gt_name CHAR(30),
        gt_value INTEGER,
        gt_drawallowed SMALLINT);

    CREATE TABLE pick (
        pk_login CHAR(10),
        pk_game INTEGER,
        pk_pick INTEGER,
        pk_point INTEGER);

    CREATE TABLE pick_audit(
        pa_login CHAR(10),
        pa_game INTEGER,
        pa_pick INTEGER,
        pa_when DATETIME YEAR TO SECOND);

    CREATE TABLE league(
        lg_id INTEGER,
        lg_name VARCHAR(40),
        lg_admin_login CHAR(10));

    CREATE TABLE league_member(
        lm_league INTEGER,
        lm_login CHAR(10),
        lm_score INTEGER,
        lm_rank INTEGER);

END FUNCTION

FUNCTION populate_venue()
    DELETE FROM venue WHERE 1=1
    LOAD FROM "venue.unl" DELIMITER "," INSERT INTO venue
END FUNCTION

FUNCTION populate_team()
    DELETE FROM team WHERE 1=1
    LOAD FROM "team.unl" DELIMITER "," INSERT INTO team
END FUNCTION

FUNCTION populate_game()
    DELETE FROM game WHERE 1=1
    LOAD FROM "game.unl" DELIMITER "," INSERT INTO game
END FUNCTION

FUNCTION populate_player()
    DELETE FROM player WHERE 1=1
    -- Replace with your details
    --INSERT INTO player VALUES("admin","admin","Admin","User","fourjs.reuben@gmail.com",NULL,NULL,NULL,NULL,NULL);
    --INSERT INTO player VALUES("admin","admin","Admin","User","fourjs.reuben@gmail.com",NULL,NULL,NULL,NULL,NULL);
    --INSERT INTO player VALUES("admin","admin","Admin","User","fourjs.reuben@gmail.com",NULL,NULL,NULL,NULL,NULL);
END FUNCTION

FUNCTION populate_gametype()
    DELETE FROM gametype WHERE 1=1
    LOAD FROM "gametype.unl" DELIMITER "," INSERT INTO gametype
END FUNCTION
   
   

   
   
