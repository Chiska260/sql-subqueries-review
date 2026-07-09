CREATE DATABASE ReviewDB;
USE ReviewDB;

-- Create a database that uses your nickname as its name. 
-- The following tables need to be created with their suitable data types and constraints for this assignment. 
--  Insert at least 5 records in each table. Use your own realistic data. 
-- The task requires you to write SELECT statements through SubQuery without using SQL JOIN and SQL 


CREATE TABLE Instructor(
	Instructor_ID varchar(10) primary key,
    Instructor_Name varchar(100),
    Email varchar(50),
    Specialization varchar(50)
);

CREATE TABLE Course(
	Course_Code varchar(10) primary key,
    Title varchar(100),
    Credits INT,
    Instructor_ID varchar(10),
    FOREIGN KEY(Instructor_ID) REFERENCES Instructor(Instructor_ID)
);

CREATE TABLE Student(
	Student_ID varchar(10) primary key,
    Student_Name varchar(100),
    Email varchar(100),
    Year_Level int
);

CREATE TABLE Enrollment(
	Enrollment_ID varchar(10),
	Student_ID varchar(10),
    Course_Code varchar(10),
    Enrollment_Date date,
    Grade CHAR(2),
    FOREIGN KEY(Student_ID) REFERENCES Student(Student_ID),
    FOREIGN KEY(Course_Code) REFERENCES Course(Course_Code)
);

INSERT INTO Instructor VALUES
('I001', 'Taylor Dela Cruz', 'taytay@gmail.com', 'Computer Science'),
('I002', 'Juan Batumbakal', 'juaniko@gmail.com', 'Mathematics'),
('I003', 'Josefa Dimaano', 'josie@gmail.com', 'Computer Science'),
('I004', 'Althea Ramirez', 'princessthea@gmail.com', 'Data Science'),
('I005', 'Ariana Dizon', 'ari@gmail.com', 'Biology');

INSERT INTO Course VALUES
('CS101','Introduction to Computer Science', 2, 'I001'),
('CS102','Computer Science 2', 2, 'I001'),
('DT231','Data Science', 4, 'I004'),
('DT250','Data Analytics', 4, 'I004'),
('CALC003','Calculus', 2, 'I002'),
('MMWXI','Math in Modern World', 4, 'I002'),
('BIO123','Anatomy and Phsiology', 1, 'I005'),
('CTINFMGL','Information Management', 3, 'I003'),
('CTINFINT','Data Structures', 3, 'I003')
;

INSERT INTO Student VALUES 
('S001', 'Miko Briones', 'micolim@gmail.com', 1),
('S002', 'Violet Atienze', 'violet@gmail.com', 3),
('S003', 'Juanco Carlos', 'juanico@gmail.com', 4),
('S004', 'Bea Dizon', 'binene@gmail.com', 1),
('S005', 'Elijah Mateo Cruz', 'elicruz@gmail.com', 2)
;

INSERT INTO Enrollment VALUES
('2025-011', 'S001', 'CS101', '2025-03-06', 'A'),
('2025-010', 'S001', 'CS102', '2025-03-06', 'B'),
('2022-002', 'S002', 'DT231', '2022-07-10', 'B+'),
('2022-003', 'S002', 'DT231', '2022-07-10', 'D+'),
('2022-004', 'S002', 'CALC003', '2022-07-10', 'B-'),
('2021-032', 'S003', 'CALC003', '2021-02-04', 'C-'),
('2025-012', 'S004', 'BIO123', '2025-03-07', 'A-'),
('2025-013', 'S004', 'CS101', '2025-03-07', 'B'),
('2023-001', 'S005', 'CTINFMGL', '2023-12-25', 'B-'),
('2023-002', 'S005', 'CS101', '2023-12-25', 'B-')
;

-- no 1. Show all courses which have more than two students enrolled. Display the course code together with 
-- the total number of enrolled students. The list should be arranged in descending order based on student 
-- enrollment numbers. 
SELECT course_code, COUNT(student_id) FROM enrollment GROUP BY course_code HAVING COUNT(student_id) > 2
ORDER BY Count(student_id) DESC; 

-- no 2. For each course with total enrolled students greater than 1., display the course code and the total 
-- number of enrolled students. Sort by course code. 
SELECT course_code, COUNT(student_id) FROM enrollment GROUP BY course_code HAVING COUNT(student_id) > 1 
ORDER BY course_code;

-- no 3. The query needs to retrieve all student names who take the same course as 'S001' while showing 
-- results in alphabetical order. 
SELECT Student_Name FROM student WHERE student_ID IN
(SELECT student_id FROM enrollment WHERE Course_code IN 
(SELECT course_code FROM enrollment WHERE student_id = 'S001') AND student_id <> 'S001')
ORDER BY Student_Name; 

-- no 4. List all courses that have a credit value greater than the average credits of all courses. Display the 
-- course code, title, and credits. Sort by course code. 
SELECT course_code, title, credits FROM course WHERE credits > 
(SELECT AVG(credits) FROM course) ORDER BY course_code;

-- no 5. Identify all students who take classes from teachers who specialize in 'Computer Science'. The list of 
-- student names should appear in alphabetical order. 
SELECT student_name FROM student WHERE student_ID IN
(SELECT student_ID FROM enrollment WHERE course_code IN
(SELECT course_code FROM course WHERE instructor_id IN 
(SELECT instructor_id FROM instructor WHERE specialization = 'Computer Science')
)) ORDER BY student_name;

-- no 6. List all instructors who teach courses that have at least one enrolled student. Display instructor ID and 
-- name. Sort by instructor name. 
SELECT instructor_ID, Instructor_name FROM instructor WHERE instructor_id IN
(SELECT instructor_ID FROM course WHERE course_code IN
(SELECT course_code FROM enrollment)) ORDER BY instructor_name; 

-- no 7. Find all students whose year level is greater than the average year level of all students. Display student 
-- ID, name, and year level. Sort by student name. 
SELECT student_id, student_name, year_level FROM student 
WHERE year_level > (SELECT AVG(year_level) FROM student)
ORDER BY student_name;

-- no 8. Find all course titles that belong to instructors who share the same specialization as the instructor with 
-- ID 'I001'. The results should display course titles in alphabetical order. 
SELECT title FROM course WHERE instructor_ID IN 
(SELECT instructor_ID FROM instructor WHERE specialization =
(SELECT specialization FROM instructor WHERE Instructor_ID = 'I001'))
ORDER BY title;

-- no 9. List all students whose year level is greater than ANY student enrolled in the course with Course_Code 
-- 'CS101'. Display student name and year level, sorted by year level. 
SELECT student_name, year_level FROM student
WHERE year_level > ANY 
(SELECT year_level FROM student WHERE student_ID IN
(SELECT student_ID FROM course WHERE course_code = 'CS101'))
ORDER BY year_level;

-- no 10. The list contains email addresses of instructors who teach courses with students who received 'A' 
-- grades. The list contains unique instructor email addresses which are arranged in alphabetical order. 
SELECT DISTINCT email FROM instructor
WHERE instructor_ID IN 
(SELECT instructor_ID FROM course WHERE course_code IN
(SELECT course_code FROM enrollment WHERE grade = 'A'))
ORDER BY email;

-- no 11. Find all courses whose credits are less than ANY course taught by instructors with specialization 'Data 
-- Science'. Display course code, title, and credits, sorted by credits. 
SELECT course_code, title, credits FROM course
WHERE credits < ANY 
(SELECT credits FROM course WHERE instructor_ID IN
(SELECT instructor_ID FROM instructor WHERE specialization = 'Data Science'))
ORDER BY credits;

-- no 12. List all students who take classes from the instructor who teaches the most courses. The list of student 
-- names should be arranged in alphabetical order. 
SELECT student_name FROM student WHERE student_ID IN
(SELECT student_ID FROM enrollment WHERE course_code IN
(SELECT course_code FROM course WHERE instructor_id IN
(SELECT instructor_id FROM course GROUP BY instructor_id
	HAVING count(course_code) >= ALL
    (SELECT COUNT(course_code) FROM course GROUP BY instructor_id)
    )))
ORDER BY student_name;


-- no 13. The following list contains all students who do not attend classes taught by mathematics specialists. The 
-- list includes student ID numbers and names which are arranged alphabetically by name. 
SELECT student_ID, student_name FROM student
WHERE student_ID NOT IN 
(SELECT student_ID FROM Enrollment WHERE course_code IN
(SELECT course_code FROM course WHERE Instructor_ID IN
(SELECT Instructor_ID FROM Instructor WHERE specialization = 'Mathematics')))
ORDER BY student_name;


-- no 14.  List all students who are NOT enrolled in any course taught by instructors with specialization 
-- 'Mathematics'. Display student ID and name, sorted by name. 
SELECT student_ID, student_name FROM student 
WHERE student_ID NOT IN
(SELECT student_ID FROM enrollment WHERE course_code IN
(SELECT course_code FROM course WHERE instructor_id IN
(SELECT instructor_id FROM instructor WHERE specialization = 'Mathematics')))
ORDER BY student_name;

-- no 15. List the names of students who are enrolled in courses with credits equal to the maximum credits among 
-- all courses. The student names should appear in an ascending sequence. 
SELECT student_name FROM student WHERE student_id IN
(SELECT student_id FROM enrollment WHERE course_code IN
(SELECT course_code FROM course WHERE credits = (SELECT max(credits) FROM course
)))
ORDER BY student_name;