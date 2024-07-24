 --1- Get Property Status Based on Availability:--

CREATE OR ALTER FUNCTION get_property_status (@listing_id INT)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @status VARCHAR(50);

    SELECT @status = CASE WHEN c.available = 'True' THEN 'Available' ELSE 'Unavailable' END
    FROM listing l
    JOIN calendar c ON l.listing_id = c.listing_id
    WHERE l.listing_id = @listing_id;

    RETURN @status;
END;

SELECT dbo.get_property_status(3335) AS PropertyStatus;


--2- Calculate Total Cost (including service fee) 'scalar function':

CREATE OR ALTER FUNCTION calculate_total_cost (@listing_id INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @total_cost FLOAT;

    SELECT @total_cost = price + cleaning_fee
    FROM listing
    WHERE listing_id = @listing_id;

    RETURN @total_cost;
END;

select dbo.calculate_total_cost(3335) AS TotalCost;

-- ROOM COUNT USING STORED PROCEDURE:

CREATE or alter PROC GetRoomCounts
as
BEGIN
    SELECT room_type , p.bedrooms , p.bathrooms, neighbourhood ,  sum(p.bedrooms) AS romms
    FROM property p
    JOIN listing l ON l.listing_id = P.listing_id
    JOIN listing_location ll ON P.listing_id = ll.listing_id
    GROUP BY room_type, neighbourhood , p.bedrooms , p.bathrooms
    ORDER BY room_type ASC, neighbourhood DESC;
END;

GetRoomCounts


--3- THE HOST WHO HAS THE MOST LISTINGS: 

CREATE OR ALTER PROCEDURE GetHostWithMostListings
AS
BEGIN
    SELECT h.host_id, h.host_name, COUNT(l.listing_id) AS num_listings
    FROM listing l ,listing l2 , host h 
	where l.listing_id = l2.listing_id and h.host_id=l.host_id
    GROUP BY h.host_name, l.host_id ,h.host_id
    ORDER BY count(l.listing_id) DESC;
END

GetHostWithMostListings

--4- GET CITY OFFERS ACCORDING TO PRICE:

CREATE PROC GetCityPriceInfo
as
BEGIN
    SELECT neighbourhood, CAST(AVG(price) AS INTEGER) AS avg_price
    FROM listing_location ll
    JOIN listing l ON l.listing_id = ll.listing_id
    GROUP BY neighbourhood
    ORDER BY avg_price DESC;
END;

GetCityPriceInfo 

--5- MOST WANTED(ASKED FOR) NEIGHBOURHOOD:

CREATE or alter PROC GetMostPopularNeighbourhood
as
BEGIN
    SELECT city , neighbourhood, COUNT(*) AS num_properties
    FROM listing_location ll
    JOIN listing l ON l.listing_id = ll.listing_id
    GROUP BY city, neighbourhood
    ORDER BY num_properties DESC;
END;

GetMostPopularNeighbourhood


--6- CURSOR (detailed information about each neighbourhood and its group based on the number of properties.)

DECLARE neighbourhood_cursor CURSOR 
FOR
SELECT city , neighbourhood, COUNT(*) AS num_properties
FROM listing_location ll
    JOIN listing l ON l.listing_id = ll.listing_id
    GROUP BY city, neighbourhood
    ORDER BY num_properties DESC;
DECLARE @city NVARCHAR(50)
DECLARE @neighbourhood NVARCHAR(50)
DECLARE @num_properties INT

OPEN neighbourhood_cursor;
FETCH NEXT FROM neighbourhood_cursor INTO @city, @neighbourhood, @num_properties;
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT  @city , @neighbourhood , @num_properties
FETCH neighbourhood_cursor INTO @city, @neighbourhood, @num_properties;
END
CLOSE neighbourhood_cursor;
DEALLOCATE neighbourhood_cursor;

--7- offering listing suggestions based on specific price 'scalar Function':

CREATE or alter FUNCTION get_listing_name (@price INT)
RETURNS VARCHAR(max)
AS
BEGIN
    DECLARE @listing_name VARCHAR(20);

    SELECT @listing_name = name
    FROM listing
    WHERE price = @price;

    RETURN @listing_name;
END;

SELECT dbo.get_listing_name(200) AS listingName;


--8-- offering property suggestions based on range of prices:

DECLARE @TestPrices TABLE (Price INT);

INSERT INTO @TestPrices (Price) VALUES (85), (150), (200);

SELECT Price, dbo.get_listing_name(Price) AS listingName
FROM @TestPrices;

--9- PROPERTY DISTRIBUTION VIEW----

CREATE or alter VIEW PropertyGeogrDistribution AS
SELECT 
    ll.country_code,
	ll.city,
    ll.neighbourhood,
    COUNT(l.listing_id) AS NumberOfProperties,
    AVG(l.Price) AS AveragePrice
FROM 
    listing_location ll , listing l 
	where ll.listing_id = l.listing_id
GROUP BY 
    ll.country_code,ll.city, ll.neighbourhood;

SELECT * FROM PropertyGeogrDistribution

--10--PropertyReviews VIEWS----

CREATE or alter VIEW listing_Reviews AS
SELECT l.listing_id , l.name , h.host_name, AVG(l.review_scores_rating) AS AverageRating, l.number_of_reviews
FROM listing l , host h
where l.host_id=h.host_id
GROUP BY l.listing_id , l.name , h.host_name ,l.number_of_reviews

SELECT * FROM listing_Reviews 

--11- HOST DETAILS who have verification VIEW--

CREATE or alter VIEW HostDetails AS
SELECT 
    h.HOST_ID,
    h.host_name,v.host_identity_verified,
    COUNT(l.listing_id) AS ListingsCount 
FROM 
    HOST h
JOIN 
    listing l ON h.HOST_ID = l.HOST_ID
join host_verification v on h.host_id = v.host_id 
and v.host_identity_verified ='True' --true = 1 , False = 0 ---
GROUP BY 
    h.HOST_ID, h.Host_Name, v.host_identity_verified;

	SELECT * FROM HostDetails


