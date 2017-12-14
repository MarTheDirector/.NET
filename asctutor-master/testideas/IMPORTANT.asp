two variables method
@tutorUserName
@Course
select UserName from Tutor as Tutor1 join TutorCourses
as Tutor2 on (Tutor1.UserName=Tutor2.UserName)
 where Tutor2.Course= 10126 and (M_Hours <= U_Hours)
 order by Tutor2.UserName
 
 select Distinct UserName from Available_Times where Status= 'Open2' and Course=10126
 
 
 
 two lists is still better i think
 first list i can select all times
 but second list can only select specific times....but
 select all times where Course = Course# and ... yeah stick with two i think
 
select Tutor1.UserName from Tutor as Tutor1 join TutorCourses
as Tutor2 on (Tutor1.UserName=Tutor2.UserName)
 where Tutor2.Course= 8888 and (M_Hours <= U_Hours)

 union all

@Course
 select UserName from Available_Times where Status='Open2' and Course =8888