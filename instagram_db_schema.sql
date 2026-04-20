 -- Creating a clone_instagram database

CREATE TABLE users (
id INT NOT NULL AUTO_INCREMENT,
username VARCHAR(150) NOT NULL UNIQUE,
created_at TIMESTAMP,
PRIMARY KEY (id)
);

DESC users;

ALTER TABLE users
MODIFY created_at TIMESTAMP DEFAULT NOW();

DESC users;

CREATE TABLE photos (
id INT AUTO_INCREMENT PRIMARY KEY,
image_url VARCHAR(500) UNIQUE NOT NULL,
created_at TIMESTAMP DEFAULT NOW(),
user_id INT,
FOREIGN KEY (user_id) REFERENCES users(id)
);

DESC photos;

ALTER TABLE photos
MODIFY image_url VARCHAR(500) NOT NULL,
MODIFY user_id INT NOT NULL;

DESC photos;

CREATE TABLE comments (
id INT AUTO_INCREMENT PRIMARY KEY,
comment_text VARCHAR(700) NOT NULL,
created_at TIMESTAMP DEFAULT NOW(),
photo_id INT,
FOREIGN KEY (photo_id) REFERENCES photos (id),
user_id INT,
FOREIGN KEY (user_id) REFERENCES users (id)
);

ALTER TABLE comments
MODIFY photo_id INT NOT NULL,
MODIFY user_id INT NOT NULL;

DESC comments;

CREATE TABLE likes (
user_id INT NOT NULL,
FOREIGN KEY (user_id) REFERENCES users (id),
photo_id INT NOT NULL,
FOREIGN KEY (photo_id) REFERENCES photos (id),
created_at TIMESTAMP DEFAULT NOW()
);

DROP TABLE likes;

CREATE TABLE likes (
user_id INT NOT NULL,
FOREIGN KEY (user_id) REFERENCES users (id),
photo_id INT NOT NULL,
FOREIGN KEY (photo_id) REFERENCES photos (id),
created_at TIMESTAMP DEFAULT NOW(),
PRIMARY KEY (user_id, photo_id)
);

DESC likes;

CREATE TABLE follows (
follower_id INT NOT NULL,
followee_id INT NOT NULL,
created_at TIMESTAMP DEFAULT NOW(),
FOREIGN KEY (follower_id) REFERENCES users(id),
FOREIGN KEY (followee_id) REFERENCES users(id),
PRIMARY KEY (follower_id, followee_id)
);

ALTER TABLE follows
ADD CHECK (follower_id <> followee_id);

DESC follows;

CREATE TABLE tags (
id INT AUTO_INCREMENT PRIMARY KEY,
tag_name VARCHAR(100) UNIQUE,
created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE photo_tags (
photo_id INT NOT NULL, 
tag_id INT NOT NULL,
FOREIGN KEY (photo_id) REFERENCES photos(id),
FOREIGN KEY (tag_id) REFERENCES tags(id),
PRIMARY KEY (photo_id, tag_id)
);
