CREATE SCHEMA `hptest` DEFAULT CHARACTER SET utf8mb4 ;

USE hptest;

CREATE TABLE users(
user_id INT AUTO_INCREMENT PRIMARY KEY,
user_uuid CHAR(36) NOT NULL UNIQUE,
user_name VARCHAR(100) NOT NULL,
user_password VARCHAR(255) NOT NULL,
phone_number VARCHAR(15) NOT NULL,
email VARCHAR(100) NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
last_login DATETIME DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP
);

CREATE TABLE user_body_profile (
    user_id INT PRIMARY KEY,
    user_age INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    height FLOAT NOT NULL,
    weight FLOAT NOT NULL,
    neck_circumference FLOAT NOT NULL,
    body_fat_percentage FLOAT NOT NULL,
    body_muscle_mass FLOAT NOT NULL,
    body_bone_density FLOAT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE refresh_tokens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(255) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,
    last_used_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE assistant_threads (
    thread_id CHAR(36) PRIMARY KEY,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    run_state VARCHAR(50),
    run_id VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE assistant_messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    thread_id CHAR(36),
    sender_type ENUM('user', 'assistant') NOT NULL,
    content VARCHAR(500) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (thread_id) REFERENCES assistant_threads(thread_id) ON DELETE CASCADE
);

CREATE TABLE body_measurements_record (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    recoded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    left_arm_length FLOAT NOT NULL,
    right_arm_length FLOAT NOT NULL,
    inside_leg_height FLOAT NOT NULL,
    shoulder_to_crotch_height FLOAT NOT NULL,
    shoulder_breadth FLOAT NOT NULL,
    head_circumference FLOAT NOT NULL,
    chest_circumference FLOAT NOT NULL,
    waist_circumference FLOAT NOT NULL,
    hip_circumference FLOAT NOT NULL,
    wrist_right_circumference FLOAT NOT NULL,
    bicep_right_circumference FLOAT NOT NULL,
    forearm_right_circumference FLOAT NOT NULL,
    thigh_left_circumference FLOAT NOT NULL,
    calf_left_circumference FLOAT NOT NULL,
    ankle_left_circumference FLOAT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
    );

CREATE TABLE training_programs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    training_cycle_length INT NOT NULL,
    goals JSON NOT NULL,
    constraints JSON NOT NULL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE training_cycles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    program_id INT NOT NULL,
    day_index INT NOT NULL,
    exercise_type INT NOT NULL,
    FOREIGN KEY (program_id) REFERENCES training_programs(id) ON DELETE CASCADE
);

CREATE TABLE exercise_sets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    program_id INT NOT NULL,
    set_key INT NOT NULL,
    focus_area VARCHAR(255) NOT NULL,
    FOREIGN KEY (program_id) REFERENCES training_programs(id) ON DELETE CASCADE
);

CREATE TABLE exercise_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    set_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    sets INT NOT NULL,
    reps INT NOT NULL,
    unit VARCHAR(50) NOT NULL,
    weight_type VARCHAR(50),
    weight_value FLOAT,
    rest INT NOT NULL,
    FOREIGN KEY (set_id) REFERENCES exercise_sets(id) ON DELETE CASCADE
);
