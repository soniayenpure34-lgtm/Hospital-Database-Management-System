use hospital_db;

-- 1. Write a query in SQL to obtain the name of the physicians with department who are yet to be affiliated
SELECT 
    p.name AS physician_name,
    d.name AS department_name
FROM affiliated_withSELECT aw
JOIN physician p 
    ON aw.physician = p.employeeid
JOIN department d 
    ON aw.department = d.department_id
WHERE aw.primaryaffiliation = 'f';


-- 2. Write a query in SQL to obtain the name of the patients with their physicians by whom they got their preliminary treatment
SELECT 
    pt.name AS patient_name,
    ph.name AS physician_name
FROM patient pt
JOIN physician ph
    ON pt.pcp = ph.employeeid;
    
-- 3. Write a query in SQL to find the name of the patients and the number of physicians they have taken appointment.
SELECT 
    pt.name AS patient_name,
    COUNT(DISTINCT a.physician) AS number_of_physicians
FROM appointment a
JOIN patient pt
    ON a.patient = pt.ssn
GROUP BY pt.name;

-- 4. Write a query in SQL to count number of unique patients who got an appointment for examination room C
SELECT 
    COUNT(DISTINCT patient) AS unique_patients
FROM appointment
WHERE examinationroom = 'C';

-- 5. Write a query in SQL to find the name of the patients and the number of the room where they have to go for their treatment.
SELECT 
    pt.name AS patient_name,
    COUNT(DISTINCT s.roomnumber) AS number_of_rooms
FROM stay s
JOIN patient pt
    ON s.patient = pt.ssn
GROUP BY pt.name;

-- 6. Write a query in SQL to find the name of the nurses and the room scheduled, where they will assist the physicians.
SELECT 
    n.name AS nurse_name,
    a.examinationroom
FROM appointment a
JOIN nurse n
    ON a.prepnurse = n.employeeid;

/*  7. Write a query in SQL to find the name of the patients who taken the appointment on the 25th of April at 10 am,
 and also display their physician, assisting nurses and room no. */
 SELECT 
    pt.name AS patient_name,
    ph.name AS physician_name,
    n.name AS nurse_name,
    a.examinationroom
FROM appointment a
JOIN patient pt
    ON a.patient = pt.ssn
JOIN physician ph
    ON a.physician = ph.employeeid
LEFT JOIN nurse n
    ON a.prepnurse = n.employeeid
WHERE a.start_dt = '25/4/2008';

-- 8. Write a query in SQL to find the name of patients and their physicians who does not require any assistance of a nurse.
SELECT 
    pt.name AS patient_name,
    ph.name AS physician_name
FROM appointment a
JOIN patient pt
    ON a.patient = pt.ssn
JOIN physician ph
    ON a.physician = ph.employeeid
WHERE a.prepnurse IS NULL;

-- 9. Write a query in SQL to find the name of the patients, their treating physicians and medication
SELECT 
    p.name AS patient_name,
    ph.name AS physician_name,
    m.name AS medication_name
FROM prescribes pr
JOIN patient p ON pr.patient = p.ssn
JOIN physician ph ON pr.physician = ph.employeeid
JOIN medication m ON pr.medication = m.code;

-- 10. Write a query in SQL to find the name of the patients who taken an advanced appointment, and also display their physicians and medication.
SELECT 
    pt.name AS patient_name,
    ph.name AS physician_name,
    m.name AS medication_name,
    a.start_dt AS appointment_date
FROM appointment a
JOIN patient pt ON a.patient = pt.ssn
JOIN physician ph ON a.physician = ph.employeeid
LEFT JOIN prescribes pr ON pr.appointment = a.appointmentid
LEFT JOIN medication m ON pr.medication = m.code
ORDER BY a.start_dt;

-- 11. Write a query in SQL to count the number of available rooms for each block in each floor
SELECT 
    blockfloor,
    blockcode,
    COUNT(*) AS available_rooms
FROM room
WHERE unavailable = 'f'
GROUP BY blockfloor, blockcode
ORDER BY blockfloor, blockcode;


-- 12. Write a query in SQL to find out the floor where the minimum no of rooms are available
WITH available_rooms_per_floor AS (
    SELECT 
        blockfloor,
        COUNT(*) AS available_rooms
    FROM room
    WHERE unavailable = 'f'
    GROUP BY blockfloor
)
SELECT blockfloor, available_rooms
FROM available_rooms_per_floor
WHERE available_rooms = (
    SELECT MIN(available_rooms) 
    FROM available_rooms_per_floor
);

-- 13. Write a query in SQL to obtain the name of the patients, their block, floor, and room number where they are admitted
SELECT 
    p.name AS patient_name,
    r.blockcode AS block,
    r.blockfloor AS floor,
    s.roomnumber
FROM stay s
JOIN patient p ON s.patient = p.ssn
JOIN room r ON s.roomnumber = r.roomnumber;

/* 14. Write a query in SQL to obtain the name and position of all physicians who completed a
medical procedure with certification after the date of expiration of their certificate. */
SELECT DISTINCT
    ph.name,
    ph.position
FROM undergoes u
JOIN trained_in t ON u.physicianassist = t.physician
                  AND u.procedure_id = t.treatment
JOIN physician ph ON t.physician = ph.employeeid
WHERE STR_TO_DATE(u.date, '%d/%m/%Y') > STR_TO_DATE(t.certificationexpires, '%d/%m/%Y');

/* 15. Write a query in SQL to obtain the name of all those physicians who completed a
medical procedure with certification after the date of expiration of their certificate, their
position, procedure they have done, date of procedure, name of the patient on which the
procedure had been applied and the date when the certification expired. */
SELECT 
    ph.name AS physician_name,
    ph.position,
    pr.name AS procedure_name,
    u.date AS procedure_date,
    pt.name AS patient_name,
    t.certificationexpires AS certification_expiry
FROM undergoes u
JOIN trained_in t 
    ON u.physicianassist = t.physician
   AND u.procedure_id = t.treatment
JOIN physician ph 
    ON t.physician = ph.employeeid
JOIN procedures pr 


    ON u.procedure_id = pr.code
JOIN patient pt 
    ON u.patient = pt.ssn
WHERE STR_TO_DATE(u.date, '%d/%m/%Y') > STR_TO_DATE(t.certificationexpires, '%d/%m/%Y');
