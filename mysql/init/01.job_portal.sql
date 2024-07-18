CREATE DATABASE job-portal-db;

-- Table to store job openings
CREATE TABLE jobs (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    job_title VARCHAR(255) NOT NULL
);

-- Table to store candidate information
CREATE TABLE candidates (
    candidate_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20)
);

-- Table to associate candidates with job openings
CREATE TABLE job_candidates (
    job_candidate_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT,
    candidate_id INT,
    FOREIGN KEY (job_id) REFERENCES jobs(job_id),
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id)
);

-- Table to store the steps for each job
CREATE TABLE steps (
    step_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT,
    step_order INT NOT NULL,
    step_description VARCHAR(255) NOT NULL,
    FOREIGN KEY (job_id) REFERENCES jobs(job_id),
    UNIQUE(job_id, step_order)
);

-- Table to track the progress of each candidate through the steps of the job
CREATE TABLE candidate_steps (
    candidate_step_id INT AUTO_INCREMENT PRIMARY KEY,
    job_candidate_id INT,
    step_id INT,
    status ENUM('Not Started', 'In Progress', 'Completed') DEFAULT 'Not Started',
    FOREIGN KEY (job_candidate_id) REFERENCES job_candidates(job_candidate_id),
    FOREIGN KEY (step_id) REFERENCES steps(step_id)
);

-- Example: Inserting sample data
-- Job openings
INSERT INTO jobs (job_title) VALUES ('Marketing Manager');
INSERT INTO jobs (job_title) VALUES ('Software Engineer');

-- Candidates
INSERT INTO candidates (name, email, phone) VALUES ('John Doe', 'john.doe@example.com', '123-456-7890');
INSERT INTO candidates (name, email, phone) VALUES ('Jane Smith', 'jane.smith@example.com', '987-654-3210');

-- Associating candidates with job openings
INSERT INTO job_candidates (job_id, candidate_id) VALUES (1, 1); -- John Doe for Marketing Manager
INSERT INTO job_candidates (job_id, candidate_id) VALUES (1, 2); -- Jane Smith for Marketing Manager
INSERT INTO job_candidates (job_id, candidate_id) VALUES (2, 1); -- John Doe for Software Engineer

-- Defining steps for each job
INSERT INTO steps (job_id, step_order, step_description) VALUES (1, 1, 'Resume Screening');
INSERT INTO steps (job_id, step_order, step_description) VALUES (1, 2, 'Phone Interview');
INSERT INTO steps (job_id, step_order, step_description) VALUES (1, 3, 'In-Person Interview');
INSERT INTO steps (job_id, step_order, step_description) VALUES (2, 1, 'Technical Test');
INSERT INTO steps (job_id, step_order, step_description) VALUES (2, 2, 'Technical Interview');

-- Tracking candidate progress through steps
INSERT INTO candidate_steps (job_candidate_id, step_id, status) VALUES (1, 1, 'Completed'); -- John Doe completed Resume Screening for Marketing Manager
INSERT INTO candidate_steps (job_candidate_id, step_id, status) VALUES (1, 2, 'In Progress'); -- John Doe in Phone Interview for Marketing Manager
INSERT INTO candidate_steps (job_candidate_id, step_id, status) VALUES (2, 1, 'Completed'); -- Jane Smith completed Resume Screening for Marketing Manager
INSERT INTO candidate_steps (job_candidate_id, step_id, status) VALUES (3, 4, 'Not Started'); -- John Doe not started Technical Test for Software Engineer