-- 1. Finding 5 Oldest Users
SELECT username,
CONCAT('Using IG clone for ',timestampdiff(
YEAR,
created_at, CURDATE()
),
' Years'
)
AS longest_user
FROM users
ORDER BY created_at
LIMIT 5;

SELECT * FROM users
ORDER BY created_at
LIMIT 5;

-- 2. Select the day of the week where we can run our 1 day ad campaign
SELECT
DAYNAME(created_at)
AS Register_day,
COUNT(
DAYNAME(
created_at
)
)
AS Week_aggregate
FROM users
GROUP BY DAYNAME(created_at)
LIMIT 2;

-- 3. Select the users who hasn't posted any photo on our app
SELECT * FROM photos;
SELECT username,
image_url,
CASE WHEN image_url IS NULL THEN 'Hi Please come back'
ELSE 'You are awesome'
END AS GREETING_MSG
FROM users
LEFT JOIN photos ON photos.user_id = users.id
WHERE photos.id
IS NULL;


-- 4. Running a contest to see who get the most likes in a single photos
SELECT
username, 
photo_id,
image_url,
COUNT(photo_id) AS total
FROM likes
JOIN photos ON photos.id = likes.photo_id
JOIN users ON users.id = photos.user_id
GROUP BY photo_id
ORDER BY total DESC
LIMIT 1;

SELECT username, 
photo_id, 
image_url,
COUNT(photo_id) AS Total_likes
FROM likes
JOIN photos ON photos.id = likes.photo_id
JOIN users ON users.id = photos.user_id
GROUP BY photo_id
ORDER BY Total_likes DESC
LIMIT 1;


SELECT * FROM tags;
SELECT * FROM photo_tags;
SELECT * FROM photos;
SHOW TABLES;
SELECT user_id,
COUNT(user_id)
FROM photos
GROUP BY user_id
ORDER BY COUNT(user_id) DESC;

-- 5. Select the average photos posted
SELECT
(SELECT COUNT(*) FROM photos) /
(SELECT COUNT(*) FROM users);

-- 6. Top 5 most commonly use hashtags
SELECT tag_name, 
COUNT(tag_id) AS total_tags
FROM photo_tags
JOIN tags ON id = tag_id
GROUP BY tag_id
ORDER BY total_tags DESC
LIMIT 5;

-- 7.Find users who have liked every photo
SELECT username,  
COUNT(photo_id) AS Total_photos,
CASE
WHEN COUNT(photo_id) = 
(SELECT COUNT(*) FROM photos) THEN 'Bot'
ELSE 'Real'
END User_status
FROM likes
JOIN users ON users.id = likes.user_id
GROUP BY user_id
HAVING COUNT(photo_id) = 
(SELECT 
COUNT(*)
FROM photos
);

-- 7. Alternative result

SELECT * 
FROM (
SELECT user_id,
COUNT(photo_id) AS Total_photos,
CASE
WHEN COUNT(photo_id) = 257 THEN 'Bot'
ELSE 'Real'
END User_status
FROM likes
GROUP BY user_id
)t
WHERE user_status = 'Bot';

--  1. (My Version) Most active 5 users who posted most photos
SELECT username, user_id,
COUNT(image_url) AS total_post
FROM photos
JOIN users ON users.id = photos.user_id
GROUP BY user_id
ORDER BY total_post DESC
LIMIT 5;

-- 1.1 (Correct Version) Most active 5 users who posted most photos
SELECT u.id AS user_id,
u.username,
COUNT(*) AS total_posts
FROM photos p
JOIN users u ON u.id = p.user_id
GROUP BY u.id, u.username
ORDER BY total_posts DESC
LIMIT 5;

-- 2 Most liked photo with photo_id, number of likes
SELECT u.username,
 p.user_id,
 l.photo_id,
COUNT(*) AS total_likes
FROM likes l
JOIN photos p ON p.id = l.photo_id
JOIN users u ON u.id = p.user_id
GROUP BY l.photo_id
ORDER BY total_likes DESC
LIMIT 1;

-- 3 Users who never posted a photo
SELECT u.id,
u.username
FROM users u
LEFT JOIN photos p ON u.id = p.user_id
WHERE p.id IS NULL;

-- 3.1 Another version
SELECT u.id,
u.username
FROM users u
WHERE NOT EXISTS(
SELECT 1
FROM photos p
WHERE p.user_id = u.id
);

SELECT 1
FROM photos p
WHERE p.user_id = users.id
;



SELECT 1 FROM photos p
RIGHT JOIN users u ON u.id = p.user_id
WHERE p.user_id IS NULL;

-- 4. photo with highest number of comments

SHOW TABLES;
SELECT * FROM photos;
SELECT * FROM comments;
SELECT p.image_url,
c.photo_id, 
COUNT(*) AS total_comments
FROM comments c
JOIN photos p ON p.id = c.photo_id
GROUP BY c.photo_id
ORDER BY total_comments DESC;

-- 4.1 alternate version
SELECT p.id, 
p.image_url,
COUNT(*) AS total_comments
FROM comments c
JOIN photos p ON p.id = c.photo_id
GROUP BY p.id
HAVING total_comments = (
SELECT MAX(total_comments)
FROM (
SELECT photo_id, COUNT(*) AS total_comments
FROM comments
GROUP BY photo_id
) AS temp_table
);

-- 4.2 Again using the Alternative query
SELECT *
FROM (
SELECT c.photo_id, COUNT(*),
DENSE_RANK() OVER(
ORDER BY COUNT(*) DESC) AS rnk 
FROM comments c 
GROUP BY c.photo_id) AS temp
WHERE rnk <= 3;	

-- 5. average posts per user
SELECT AVG(total_post)
FROM (
SELECT u.id, u.username, COUNT(*) AS total_post
FROM photos p
JOIN users u ON u.id = p.user_id
GROUP BY u.id, u.username
) AS temp;

-- 5.1 average post per user including 0 post
SELECT AVG(total_post)
FROM (
SELECT u.id, COUNT(p.id) AS total_post
FROM users u
LEFT JOIN photos p ON u.id = p.user_id
GROUP BY u.id
) AS temp;

-- 6. Count the 3 most used tags
SELECT t.tag_name, COUNT(*) AS total_tags
FROM tags t
JOIN photo_tags pt ON pt.tag_id = t.id
GROUP BY t.id
ORDER BY total_tags DESC
LIMIT 3;

-- 6.1 tags with  usage
SELECT t.tag_name, COUNT(pt.tag_id) AS total_tags
FROM tags t
LEFT JOIN photo_tags pt ON pt.tag_id = t.id
GROUP BY t.tag_name
ORDER BY total_tags;

-- 7 users who follow each other
SELECT f1.follower_id, f1.followee_id FROM 
follows f1
JOIN follows f2 ON
f1.follower_id = f2.followee_id
AND
f1.followee_id = f2.follower_id
WHERE f1.follower_id < f1.followee_id;

-- 8. Find users who liked every photo
SELECT u.id, u.username, COUNT(*) AS max_likes
FROM likes l
JOIN users u ON u.id = l.user_id
GROUP BY u.id, u.username
HAVING max_likes =
(SELECT MAX(max_likes)
FROM(
SELECT COUNT(*) AS max_likes
FROM likes l
GROUP BY l.user_id
) AS temp
);

-- 8.1 Rough quey for question 8
SELECT COUNT(DISTINCT l.photo_id)
FROM likes l;

SELECT(COUNT(*)) FROM photos;

SELECT user_id, COUNT(DISTINCT photo_id) AS total_likes
FROM likes
GROUP BY user_id;

-- 9. Most active register day
SELECT dayname(created_at) AS reg_day,
COUNT(*) AS total_reg
FROM users
GROUP BY reg_day
HAVING COUNT(*) =
(SELECT MAX(total)
FROM(
SELECT COUNT(*) AS total
FROM users
GROUP BY DAYNAME(created_at)
)AS temp
);

SELECT MAX(total)
FROM(
SELECT COUNT(*) AS total
FROM users
GROUP BY DAYNAME(created_at)
)AS temp;

-- 9.1 ALtenative approach
SELECT reg_day, total_reg
FROM(
SELECT DAYNAME(created_at) AS reg_day,
COUNT(*) AS total_reg,
DENSE_RANK() OVER(ORDER BY COUNT(*)DESC) AS rnk
FROM users
GROUP BY DAYNAME(created_at)
) AS temp
WHERE rnk =1;

-- 10. Photos with no likes
SELECT * FROM photos;
WITH likes_cnt AS (
SELECT p.id, COUNT(l.photo_id) AS ttl_likes
FROM photos p
LEFT JOIN likes l ON p.id = l.photo_id
GROUP BY p.id)
SELECT id, ttl_likes
FROM likes_cnt
WHERE ttl_likes <= 2;

-- 11. For each user, find the most liked photo
WITH likes_cnt AS(
SELECT l.photo_id, COUNT(*) AS ttl_likes
FROM likes l
GROUP BY l.photo_id
)
SELECT user_id, photo_id, ttl_likes
FROM(
SELECT p.user_id, lc.photo_id, lc.ttl_likes,
DENSE_RANK() OVER(PARTITION BY user_id ORDER BY ttl_likes DESC) AS rnk
FROM likes_cnt lc
JOIN photos p ON p.id = lc.photo_id
) AS temp
WHERE rnk = 1;

-- 11.1 Improved Version
WITH likes_cnt AS (
SELECT p.id AS photo_id, p.user_id, COUNT(l.photo_id) AS ttl_likes
FROM photos p
LEFT JOIN likes l ON p.id = l.photo_id
GROUP BY p.id, p.user_id
)

SELECT user_id, photo_id, rnk, ttl_likes
FROM(
SELECT user_id, photo_id, ttl_likes,
DENSE_RANK() OVER(PARTITION BY user_id ORDER BY ttl_likes DESC) AS rnk
FROM likes_cnt
) AS temp
WHERE rnk BETWEEN 1 AND 2;

-- 12. Users who commented on their own photo
SELECT DISTINCT(p.id) AS Photo,
p.user_id AS Ower,
c.user_id AS commenter
FROM comments c
JOIN photos p ON p.id = c.photo_id
WHERE p.user_id = c.user_id;

-- 13. Users who never commented
SELECT u.username, u.id
FROM users u
LEFT JOIN comments c ON u.id = c.user_id
WHERE c.user_id IS NULL;

-- 14. Users who liked their own photos
SELECT p.id,
p.user_id AS Owner,
l.user_id  AS who_likes
FROM photos p
JOIN likes l ON p.id = l.photo_id
WHERE p.user_id = l.user_id;

-- 14.1 Users who liked every photo which they posted
WITH cnt_photos AS (
SELECT p.user_id ,
COUNT(*) AS ttl_photos
FROM photos p
GROUP BY p.user_id
),
cnt_own_like AS (
SELECT  
p.user_id AS Owner,
COUNT(*) AS ttl_own_like
FROM photos p
JOIN likes l ON p.id = l.photo_id
WHERE p.user_id = l.user_id
GROUP BY p.user_id
)
SELECT u.username, cp.user_id
FROM cnt_photos cp
JOIN cnt_own_like col ON cp.user_id = col.owner
JOIN users u ON u.id = cp.user_id
WHERE cp.ttl_photos = col.ttl_own_like;

-- 15. Find users who have the highest number of followers
SELECT followee_id AS user_id,
COUNT(*) AS ttl_followers
FROM follows
GROUP BY followee_id
HAVING COUNT(*) = (
SELECT MAX(cnt)
FROM(
SELECT COUNT(*) AS cnt
FROM follows
GROUP BY followee_id)
AS temp
);

WITH total_follow AS (
SELECT followee_id AS user_id, 
COUNT(*) AS ttl_followers
FROM follows
GROUP BY followee_id
)

SELECT username, ttl_followers
FROM (
SELECT tf.user_id, u.username, tf.ttl_followers, 
DENSE_RANK() OVER(ORDER BY tf.ttl_followers DESC) AS rnk
FROM total_follow tf
JOIN users u ON u.id = tf.user_id
) AS temp
WHERE rnk = 1;

-- 16 Photos with more likes than comments
WITH cnt_likes AS (
SELECT p.id AS photo_id, COUNT(l.photo_id) AS ttl_likes
FROM photos p
LEFT JOIN likes l ON p.id = l.photo_id
GROUP BY p.id
),
cnt_cmnts AS (
SELECT p.id AS photo_id, COUNT(c.photo_id) AS ttl_cmnts
FROM photos p
LEFT JOIN comments c ON p.id = c.photo_id
GROUP BY p.id
)
SELECT cl.photo_id, ttl_likes, ttl_cmnts
FROM cnt_likes cl
JOIN cnt_cmnts cm ON cl.photo_id = cm.photo_id
WHERE ttl_likes > ttl_cmnts;

-- 17. Most  above average active user (Post + likes + Comments)
WITH cnt_post AS (
SELECT p.user_id, COUNT(*) AS ttl_post
FROM photos p
GROUP BY p.user_id
),
cnt_cmnts AS (
SELECT c.user_id, COUNT(*) AS ttl_cmnts
FROM comments c
GROUP BY c.user_id
),
cnt_likes AS (
SELECT l.user_id, COUNT(*) AS ttl_likes
FROM likes l
GROUP BY l.user_id
),
user_activity AS (
SELECT u.id, u.username,
COALESCE(ttl_post, 0) AS ttl_post,
COALESCE(ttl_cmnts, 0) AS ttl_cmnts,
COALESCE(ttl_likes, 0) AS ttl_likes,
(COALESCE(ttl_post,0) + COALESCE(ttl_cmnts, 0) + COALESCE(ttl_likes, 0)) AS ttl_activity
FROM users u
LEFT JOIN cnt_post cp ON cp.user_id = u.id
LEFT JOIN cnt_cmnts cm ON cm.user_id = u.id
LEFT JOIN cnt_likes cl ON cl.user_id = u.id
)
SELECT * FROM 
user_activity
WHERE ttl_activity > (
SELECT AVG(ttl_activity)
FROM user_activity ua
);

-- 18. Users who never received a like
WITH cnt_likes AS (
SELECT u.id AS users, p.id AS photos, COUNT(l.photo_id) AS ttl_likes
FROM photos p
LEFT JOIN likes l ON p.id = l.photo_id
LEFT JOIN users u ON u.id = p.user_id
GROUP BY p.id
)
SELECT u.id AS users , SUM(cl.ttl_likes) AS ttl_likes
FROM users u
LEFT JOIN cnt_likes cl ON u.id = cl.users
GROUP BY u.id
HAVING SUM(cl.ttl_likes) IS NULL
OR SUM(cl.ttl_likes) = 0;

SELECT u.id FROM users u
WHERE NOT EXISTS(
SELECT 1
FROM photos p
JOIN likes l ON p.id = l.photo_id
WHERE p.user_id = u.id
)
AND EXISTS (
SELECT 1
FROM photos p
WHERE p.user_id = u.id
);

-- 19. Users who liked every single photo in the photo table
SELECT u.id AS users, COUNT(DISTINCT(l.photo_id)) AS ttl_likes
FROM users u
LEFT JOIN likes l ON u.id = l.user_id
GROUP BY u.id
HAVING COUNT(DISTINCT(l.photo_id)) = (
SELECT COUNT(*) AS ttl_photos
FROM photos
);

-- 19. Alternative solution
SELECT *
FROM users u
WHERE NOT EXISTS (
SELECT * FROM photos p
WHERE NOT EXISTS (
SELECT * FROM likes l
WHERE l.photo_id = p.id
AND l.user_id = u.id
)
);

-- 20. Find photos who received more than average likes per photo
SELECT p.id , COUNT(l.photo_id) AS ttl_likes
FROM photos p
LEFT JOIN likes l ON p.id = l.photo_id
GROUP BY p.id
HAVING ttl_likes > (
SELECT ROUND(AVG(like_count),0) FROM (
SELECT COUNT(*) AS like_count
FROM likes l
GROUP BY l.photo_id
) AS avg_table
)
ORDER BY ttl_likes DESC;

-- 21. Find users who have posted more photos than average number of photos per user
SELECT u.id, u.username, COUNT(p.user_id) photos_cnt
FROM users u
LEFT JOIN photos p ON p.user_id = u.id
GROUP BY u.id
HAVING photos_cnt > (
SELECT ROUND(AVG(p_count),0) FROM (
SELECT u.id, COUNT(*) AS p_count
FROM photos p
LEFT JOIN users u ON u.id = p.user_id
GROUP BY u.id
) AS avg_table
)
ORDER BY photos_cnt DESC;

-- 22. Most 3 liked photos with counts
SELECT p.id, COUNT(l.photo_id) AS ttl_counts
FROM photos p
LEFT JOIN likes l ON l.photo_id = p.id
GROUP BY p.id
ORDER BY COUNT(l.photo_id) DESC
LIMIT 3;