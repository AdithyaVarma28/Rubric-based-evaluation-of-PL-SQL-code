INSERT INTO Student (student_id, first_name, last_name, email) VALUES 
(1, 'John', 'Doe', 'john.doe@example.com'),
(2, 'Jane', 'Smith', 'jane.smith@example.com'),
(3, 'Alice', 'Johnson', 'alice.johnson@example.com');

INSERT INTO Teacher (teacher_id, first_name, last_name, email) VALUES 
(101, 'Emily', 'Davis', 'emily.davis@example.com'),
(102, 'Michael', 'Brown', 'michael.brown@example.com');

INSERT INTO Course (course_id, course_name, description) VALUES 
(201, 'Mathematics', 'Advanced math topics'),
(202, 'Science', 'Basic science concepts'),
(203, 'History', 'World history overview');

INSERT INTO Enrollment (enrollment_id, student_id, course_id) VALUES 
(301, 1, 201),
(302, 2, 202),
(303, 3, 203);

INSERT INTO Attendance (attendance_id, student_id, course_id, date, present) VALUES 
(401, 1, 201, '2023-10-01', TRUE),
(402, 2, 202, '2023-10-01', FALSE),
(403, 3, 203, '2023-10-01', TRUE);

INSERT INTO Marks (marks_id, student_id, course_id, mark) VALUES 
(501, 1, 201, 85.5),
(502, 2, 202, 78.0),
(503, 3, 203, 92.3);