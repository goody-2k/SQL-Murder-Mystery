--FULL DOCUMENTATION ON MY SQL ANALYSIS ON MURDER_MYSTRY CASE. 

/*Hint; Crime = Murder, Date = Jan 15 2018 / 20180115, city = SQL city, 
table = crime scene reportcrime_scene_report
Query out the information needed in the crime_scene_report tablecrime_scene_report*/
SELECT *
from crime_scene_report 
WHERE city = "SQL City" and type = "murder" and date = 20180115

/*From the result of this query, description states as follows; 'Security footage shows that there were 2 witnesses.
The first witness lives at the last house on "Northwestern Dr".
The second witness, named Annabel, lives somewhere on "Franklin Ave*/

--To find the first witness who lives at the last house on "Northwestern Dr"
-- Query out the last house on the street by address number
select *
from person
where address_street_name = "Northwestern Dr"
order by address_number DESC
-- The outcome shows the address number the first witness address_number = '4919', Name = Morty Schapiro, id = '14887'.crime_scene_report

-- TO query the second witness using these clue; name: starts with Annabel, address_street_name = Franklin ave
select * 
from person 
where name 
LIKE "Annabel%" AND address_street_name like "%franklin ave%"
-- The result shows that second witness id = 16371 and name = Annabel Miller;

-- The next step is to go through the witness statements using their id
select * 
from interview
where person_id 
in (14887, 16371)

/*First witness Morty Shapiro with id 14887 transcript goes as follow;I heard a gunshot and then saw a man run out. 
He had a "Get Fit Now Gym" bag. 
---The membership number on the bag started with "48Z". Only gold members have those bags. 
The man got into a car with a plate that included "H42W*/

/*Second witness Annabel Miller with id number '16371' transcript goes as follow;
I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th*/

-- According to the first witness statement, i queried out her details using
select *
from get_fit_now_member
where id like "48Z%" AND membership_status = "gold"

/*After checking members with gym fit now bag and membership number starting with "48Z", i found 2 members. i decided 
to join the getget_fit_now_member and geget_fit_now_check_in to see which of our 2 suspects was at the gym on the 9th of January.*/
select *
from get_fit_now_member
join get_fit_now_check_in
on get_fit_now_member.id = get_fit_now_check_in.membership_id
where id like "48Z%" AND membership_status = "gold"
-- After checking, both suspect were present at the gym on the 9th of January, This narrowed my investigation down to these 2 suspects

/*To get more information on our suspects, i joined both suspects getget_fit_now_member details with person table to see their personal 
details using the person_id.*/
select person.*
from get_fit_now_member
join get_fit_now_check_in on get_fit_now_member.id = get_fit_now_check_in.membership_id
join person on get_fit_now_member.person_id = person.id
where person_id in (28819, 67318)

/*After getting their personal details, i joined drivers_license table to my result and ran their id's throught the drivers_license data
to get which of the suspect drives a car with a plate that includes "H42W"*/
select person.name, drivers_license.*
from get_fit_now_member
join get_fit_now_check_in on get_fit_now_member.id = get_fit_now_check_in.membership_id
join person on get_fit_now_member.person_id = person.id
join drivers_license on person.license_id = drivers_license.id
where person_id in (28819, 67318)

/*The result shows the full details of the murder suspect whose name is 'Jeremy Bowers'
With id: 423327	
Age:30	Height: 70	eye_color: brown	
hair_color: brown,	Gender: male	
plate_number: 0H42W2	Car_make: Chevrolet	Car_model: Spark LS.*/

--For further investigation, i checked 'Jeremy Bower's transcript.
select *
from interview
where person_id = 67318

/* The transcript goes as follow;
I was hired by a woman with a lot of money. I don't know her name but I know she's around 5'5" (65") or 5'7" (67").
She has red hair and she drives a Tesla Model S. 
I know that she attended the SQL Symphony Concert 3 times in December 2017*/

-- following the first clue i will query the dridrivers_license table, with the description of the mastermind to narrow down my list of suspects 
select *
from drivers_license
where car_make = "Tesla" and car_model = "Model S" AND height >= 65
and height <=67
and hair_color = "red"
and gender = "female"

--The result of the above query shows 3 suspects, to know the names of our suspects, 
--i joined our result from the dridrivers_license table to the person records*/
select *
from drivers_license
join person on drivers_license.id = person.license_id
where car_make = "Tesla" and car_model = "Model S" AND height >= 65
and height <=67
and hair_color = "red"
and gender = "female"

--The result of the above query shows 3 suspects, with the names and id as follows 
--id 78881 name: Red Korb
--id 90700 name: Regina George 
--id 99716 name: Miranda Priestly 

/*To figure out which of our suspects was the mastermind behind the murder, i queried their id from the facfacebook_event_checkin to see which 
of them attended the SQL Sympjony Concert 3 times*/ 
select *
from person
join facebook_event_checkin
on person.id = facebook_event_checkin.person_id
where id in (78881, 90700, 99716)

-- Only one of the 3 suspects matched what i was looking for,
/* The details of the master mind who hired Jeremy Bowers;
 ID             SSN              NAME                
99716       987756388         Miranda Priestly*/

/*My Report: On January 15, 2018, a murder occurred in SQL City.
The police obtained statements from two eyewitnesses who were present at the crime scene.
These statements proved crucial in identifying the suspect, Jeremy Bowers. 
Subsequent investigations revealed that Jeremy Bowers' information pointed to a mastermind behind the killing, later identified as Miranda Priestl.*/