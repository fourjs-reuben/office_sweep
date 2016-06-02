CREATE TABLE player (
   pl_login CHAR(10),
   pl_password CHAR(10),
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
   tm_code CHAR(3),
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
   gm_team1 INTEGER,
   gm_team2 INTEGER,
   gm_venue INTEGER,
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

     TRUNCATE TABLE venue;
   INSERT INTO venue VALUES(1,"Johannesburg", "Soccer City");
   INSERT INTO venue VALUES(2,"Durban", "Moses Mabhida Stadium");
   INSERT INTO venue VALUES(3,"Cape Town", "Cape Town Stadium");
   INSERT INTO venue VALUES(4,"Johannesburg", "Ellis Park Stadium");
   INSERT INTO venue VALUES(5,"Pretoria", "Loftus Verfeld Stadium");
   INSERT INTO venue VALUES(6,"Port Elizabeth", "Nelson Mandela Bay Stadium");
   INSERT INTO venue VALUES(7,"Bloemfontein", "Free State Stadium");
   INSERT INTO venue VALUES(8,"Polokwane", "Peter Mokaba Stadium");
   INSERT INTO venue VALUES(9,"Rustenberg", "Royal Bafokeng Stadium");
   INSERT INTO venue VALUES(10,"Nelsruit", "Mbpmbela Stadium");

     TRUNCATE TABLE team
   INSERT INTO team VALUES(1,"SAF","South Africa","","","");
   INSERT INTO team VALUES(2,"MEX","Mexico","","","");
   INSERT INTO team VALUES(3,"URU","Uruguay","","","");
   INSERT INTO team VALUES(4,"FRA","France","","","");
   INSERT INTO team VALUES(5,"KOR","Korea Republic","","","");
   INSERT INTO team VALUES(6,"GRE","Greece","","","");
   INSERT INTO team VALUES(7,"ARG","Argentina","","","");
   INSERT INTO team VALUES(8,"NIG","Nigeria","","","");
   INSERT INTO team VALUES(9,"ENG","England","","","");
   INSERT INTO team VALUES(10,"USA","United States of America","","","");
   INSERT INTO team VALUES(11,"ALG","Algeria","","","");
   INSERT INTO team VALUES(12,"SLO","Slovenia","","","");
   INSERT INTO team VALUES(13,"SER","Serbia","","","");
   INSERT INTO team VALUES(14,"GHA","Ghana","","","");
   INSERT INTO team VALUES(15,"GER","Germany","","","");
   INSERT INTO team VALUES(16,"AUS","Australia","","","");
   INSERT INTO team VALUES(17,"NED","Netherlands","","","");
   INSERT INTO team VALUES(18,"DEN","Denmark","","","");
   INSERT INTO team VALUES(19,"JPN","Japan","","","");
   INSERT INTO team VALUES(20,"CAM","Cameroon","","","");
   INSERT INTO team VALUES(21,"ITA","Italy","","","");
   INSERT INTO team VALUES(22,"PAR","Paraguay","","","");
   INSERT INTO team VALUES(23,"NZL","New Zealand","","","");
   INSERT INTO team VALUES(24,"SVK","Slovakia","","","");
   INSERT INTO team VALUES(25,"IVC","Ivory Coast","","","");
   INSERT INTO team VALUES(26,"POR","Portugal","","","");
   INSERT INTO team VALUES(27,"BRA","Brazil","","","");
   INSERT INTO team VALUES(28,"DPR","Korea DPR","","","");
   INSERT INTO team VALUES(29,"HON","Honduras","","","");
   INSERT INTO team VALUES(30,"CHI","Chile","","","");
   INSERT INTO team VALUES(31,"ESP","Spain","","","");
   INSERT INTO team VALUES(32,"SUI","Switzerland","","","");

    TRUNCATE TABLE game;
   INSERT INTO game VALUES(1,1,1,2,1,"2010-06-11 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(2,2,3,4,3,"2010-06-11 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(3,2,5,6,6,"2010-06-12 13:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(4,2,7,8,4,"2010-06-12 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(5,2,9,10,9,"2010-06-12 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(6,2,11,12,8,"2010-06-13 13:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(7,2,13,14,5,"2010-06-13 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(8,2,15,16,2,"2010-06-13 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(9,2,17,18,1,"2010-06-14 13:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(10,2,19,20,7,"2010-06-14 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(11,2,21,22,3,"2010-06-14 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(12,2,23,24,9,"2010-06-15 13:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(13,2,25,26,6,"2010-06-15 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(14,2,27,28,4,"2010-06-15 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(15,2,29,30,10,"2010-06-16 13:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(16,2,31,32,2,"2010-06-16 16:00",NULL,NULL,NULL);
   
   INSERT INTO game VALUES(17,2,1,3,5,"2010-06-16 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(18,2,6,8,1,"2010-06-17 13:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(19,2,5,7,7,"2010-06-17 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(20,2,2,4,8,"2010-06-17 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(21,2,13,15,6,"2010-06-18 13:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(22,2,10,12,4,"2010-06-18 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(23,2,9,11,3,"2010-06-18 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(24,2,17,19,2,"2010-06-19 13:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(25,2,14,16,9,"2010-06-19 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(26,2,18,20,5,"2010-06-19 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(27,2,22,24,7,"2010-06-20 13:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(28,2,21,23,10,"2010-06-20 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(29,2,25,27,1,"2010-06-20 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(30,2,26,28,3,"2010-06-21 13:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(31,2,30,32,6,"2010-06-21 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(32,2,29,31,4,"2010-06-21 20:30",NULL,NULL,NULL);
   
   INSERT INTO game VALUES(33,2,2,3,9,"2010-06-22 16:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(34,2,1,4,7,"2010-06-22 16:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(35,2,5,8,2,"2010-06-22 20:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(36,2,6,7,8,"2010-06-22 20:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(37,2,9,12,6,"2010-06-23 16:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(38,2,10,11,1,"2010-06-23 16:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(39,2,14,15,5,"2010-06-23 20:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(40,2,13,16,10,"2010-06-23 20:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(41,2,21,24,4,"2010-06-24 16:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(42,2,22,23,8,"2010-06-24 16:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(43,2,18,19,9,"2010-06-24 20:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(44,2,17,20,3,"2010-06-24 20:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(45,2,26,27,2,"2010-06-25 16:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(46,2,25,28,10,"2010-06-25 16:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(47,2,30,31,5,"2010-06-25 20:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(48,2,39,32,7,"2010-06-25 20:00",NULL,NULL,NULL);

   INSERT INTO game VALUES(49,3,0,0,6,"2010-06-26 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(50,3,0,0,9,"2010-06-26 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(51,3,0,0,7,"2010-06-27 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(52,3,0,0,1,"2010-06-27 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(53,3,0,0,2,"2010-06-28 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(54,3,0,0,4,"2010-06-28 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(55,3,0,0,5,"2010-06-29 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(56,3,0,0,3,"2010-06-29 20:30",NULL,NULL,NULL);

   INSERT INTO game VALUES(57,4,0,0,6,"2010-07-02 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(58,4,0,0,1,"2010-07-02 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(59,4,0,0,3,"2010-07-03 16:00",NULL,NULL,NULL);
   INSERT INTO game VALUES(60,4,0,0,4,"2010-07-03 20:30",NULL,NULL,NULL);

   INSERT INTO game VALUES(61,5,0,0,3,"2010-07-06 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(62,5,0,0,2,"2010-07-07 20:30",NULL,NULL,NULL);

   INSERT INTO game VALUES(63,6,0,0,6,"2010-07-10 20:30",NULL,NULL,NULL);
   INSERT INTO game VALUES(64,7,0,0,1,"2010-07-11 20:30",NULL,NULL,NULL);

    TRUNCATE TABLE player;
   INSERT INTO player VALUES("admin","admin","Admin","User","reuben@4js.com.au",NULL,"NZL");

    TRUNCATE TABLE gametype;
   INSERT INTO gametype VALUES(1,"Round 1 (Opening Game)",2,TRUE);
   INSERT INTO gametype VALUES(2,"Round 1",1, TRUE);
   INSERT INTO gametype VALUES(3,"Round of 16",2,FALSE);
   INSERT INTO gametype VALUES(4,"Quarter Final",3,FALSE);
   INSERT INTO gametype VALUES(5,"Semi Final",4,FALSE);
   INSERT INTO gametype VALUES(6,"3rd/4th playoff",5, FALSE);
   INSERT INTO gametype VALUES(7,"Final",10,FALSE);