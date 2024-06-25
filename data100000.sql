-- Eliminar tablas
DROP TABLE IF EXISTS usuario CASCADE;
DROP TABLE IF EXISTS Guest CASCADE;
DROP TABLE IF EXISTS Host CASCADE;
DROP TABLE IF EXISTS Message CASCADE;
DROP TABLE IF EXISTS Booking CASCADE;
DROP TABLE IF EXISTS Property CASCADE;
DROP TABLE IF EXISTS Promotion CASCADE;
DROP TABLE IF EXISTS Amenities CASCADE;
DROP TABLE IF EXISTS Review CASCADE;
DROP TABLE IF EXISTS SelectFavorite CASCADE;
-- eliminar triggers
DROP TRIGGER IF EXISTS increment_guest_points ON Booking;
DROP TRIGGER IF EXISTS update_host_rating ON Review;
DROP TRIGGER IF EXISTS after_review_insert_for_host ON Review;
DROP TRIGGER IF EXISTS before_booking_insert ON Booking;
DROP TRIGGER IF EXISTS update_property_rating ON Review;
DROP TRIGGER IF EXISTS after_review_insert ON Review;
DROP TRIGGER IF EXISTS after_booking_insert ON Booking;


-- eliminar funciones
DROP FUNCTION IF EXISTS increment_guest_points;
DROP FUNCTION IF EXISTS update_property_rating;
DROP FUNCTION IF EXISTS update_host_rating;
DROP FUNCTION IF EXISTS adjust_total_price;

-- Tabla Usuario
CREATE TABLE usuario
(
    user_id   VARCHAR(10),
    password  VARCHAR(255) NOT NULL,
    name      VARCHAR(255) NOT NULL,
    phone_num VARCHAR(30)  NOT NULL,
    birth     DATE,
    email     VARCHAR(255) NOT NULL
);

-- Tabla Guest
CREATE TABLE Guest
(
    user_id VARCHAR(10),
    points  INT
);

-- Tabla Host
CREATE TABLE Host
(
    user_id     VARCHAR(10),
    host_rating DECIMAL(3, 2)
);

-- Tabla Message
CREATE TABLE Message
(
    message_id      VARCHAR(10),
    guest_user_id   VARCHAR(10),
    host_user_id    VARCHAR(10),
    message_content varchar(255),
    time_message    TIMESTAMP
);

-- Tabla Booking
CREATE TABLE Booking
(
    booking_id     VARCHAR(10),
    total_price    DECIMAL(10, 2),
    timestamp      TIMESTAMP,
    check_in_date  DATE,
    check_out_date DATE,
    guest_user_id  VARCHAR(10),
    property_id    VARCHAR(10)
);

-- Tabla Property
CREATE TABLE Property
(
    property_id   VARCHAR(10),
    n_bathrooms   INT,
    title         VARCHAR(255),
    n_beds        INT,
    property_type VARCHAR(255),
    n_guests      INT,
    n_rooms       INT,
    rating        DECIMAL(3, 2),
    host_user_id  VARCHAR(10),
    price         DECIMAL(10, 2)
);

-- Tabla Promotion
CREATE TABLE Promotion
(
    promotion_id     VARCHAR(11),
    start_date       DATE,
    end_date         DATE,
    discount_rate    DECIMAL(5, 2),
    prom_description TEXT,
    property_id      VARCHAR(10)
);

-- Tabla Amenities
CREATE TABLE Amenities
(
    amenity_id   VARCHAR(10),
    condition    VARCHAR(255),
    amenity_name VARCHAR(255),
    property_id  VARCHAR(10)
);

-- Tabla Review
CREATE TABLE Review
(
    review_id  VARCHAR(10),
    booking_id VARCHAR(10),
    comment    varchar(255),
    rating     DECIMAL(3, 2)
);

-- Tabla Select Favorite
CREATE TABLE SelectFavorite
(
    property_id   VARCHAR(10),
    guest_user_id VARCHAR(10)
);


-- Llaves primarias
ALTER TABLE usuario
    ADD PRIMARY KEY (user_id);

ALTER TABLE Guest
    ADD PRIMARY KEY (user_id);

ALTER TABLE Host
    ADD PRIMARY KEY (user_id);

ALTER TABLE Message
    ADD PRIMARY KEY (message_id);

ALTER TABLE Booking
    ADD PRIMARY KEY (booking_id);

ALTER TABLE Property
    ADD PRIMARY KEY (property_id);

ALTER TABLE Promotion
    ADD PRIMARY KEY (promotion_id);

ALTER TABLE Amenities
    ADD PRIMARY KEY (amenity_id);

ALTER TABLE Review
    ADD PRIMARY KEY (review_id);

ALTER TABLE SelectFavorite
    ADD PRIMARY KEY (property_id, guest_user_id);


-- Llaves foráneas
ALTER TABLE Guest
    ADD FOREIGN KEY (user_id) REFERENCES usuario (user_id);

ALTER TABLE Host
    ADD FOREIGN KEY (user_id) REFERENCES usuario (user_id);

ALTER TABLE Message
    ADD FOREIGN KEY (guest_user_id) REFERENCES Guest (user_id),
    ADD FOREIGN KEY (host_user_id) REFERENCES Host (user_id);

ALTER TABLE Booking
    ADD FOREIGN KEY (guest_user_id) REFERENCES Guest (user_id),
    ADD FOREIGN KEY (property_id) REFERENCES Property (property_id);

ALTER TABLE Property
    ADD FOREIGN KEY (host_user_id) REFERENCES Host (user_id);

ALTER TABLE Promotion
    ADD FOREIGN KEY (property_id) REFERENCES Property (property_id);

ALTER TABLE Amenities
    ADD FOREIGN KEY (property_id) REFERENCES Property (property_id);

ALTER TABLE Review
    ADD FOREIGN KEY (booking_id) REFERENCES Booking (booking_id);

ALTER TABLE SelectFavorite
    ADD FOREIGN KEY (property_id) REFERENCES Property (property_id),
    ADD FOREIGN KEY (guest_user_id) REFERENCES Guest (user_id);

-- por default
ALTER TABLE Guest
    ALTER COLUMN points SET DEFAULT 0;
ALTER TABLE Host
    ALTER COLUMN host_rating SET DEFAULT 0;
ALTER TABLE Property
    ALTER COLUMN rating SET DEFAULT 0;


-- Restricciones

ALTER TABLE usuario
    ADD CONSTRAINT check_email CHECK (email ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

ALTER TABLE Guest
    ADD CONSTRAINT check_points CHECK (points >= 0);

ALTER TABLE Host
    ADD CONSTRAINT check_host_rating CHECK (host_rating >= 0 AND host_rating <= 5);

ALTER TABLE Booking
    ADD CONSTRAINT check_total_price CHECK (total_price >= 0);

ALTER TABLE Review
    ADD CONSTRAINT check_rating CHECK (rating >= 0 AND rating <= 5);

ALTER TABLE Property
    ADD CONSTRAINT check_property_type CHECK (property_type IN
                                              ('Entire place', 'Private room', 'Shared room', 'Entire place'));
ALTER TABLE Amenities
    ADD CONSTRAINT check_amenity_name
        CHECK (amenity_name IN
               ('WiFi', 'Pool', 'Gym', 'Air Conditioning', 'Heating', 'Kitchen', 'Free Parking', 'Washer', 'Dryer',
                'TV',
                'Hot Tub', 'Fireplace', 'Breakfast Included', '24-Hour Check-in', 'Pet Friendly', 'Elevator', 'Balcony',
                'BBQ Grill', 'Laptop-friendly Workspace', 'Smoke Detector', 'Parking', 'Breakfast', 'Laundry',
                'Concierge',
                'Mini Bar', 'Safe', 'Room Service', 'Hair Dryer', 'Coffee Maker', 'Shuttle Service', 'BBQ Area',
                'Nearby Attractions',
                'Nearby Dining', 'Beach', 'Mountain View', 'Forest View', 'Lake View', 'City View', 'Country View',
                'River View',
                'Sea View', 'Garden View', 'Pool View', 'Park View'));

ALTER TABLE Amenities
    ADD CONSTRAINT check_condition
        CHECK (condition IN ('Available', 'Not Available'));

ALTER TABLE Property
    ADD CONSTRAINT check_n_bathrooms CHECK (n_bathrooms >= 0);
ALTER TABLE Property
    ADD CONSTRAINT check_n_beds CHECK (n_beds >= 0);
ALTER TABLE Property
    ADD CONSTRAINT check_n_guests CHECK (n_guests >= 0);
ALTER TABLE Property
    ADD CONSTRAINT check_n_rooms CHECK (n_rooms >= 0);
ALTER TABLE Property
    ADD CONSTRAINT check_rating CHECK (rating >= 0 AND rating <= 5);
ALTER TABLE Property
    ADD CONSTRAINT check_price CHECK (price >= 0);

ALTER TABLE Promotion
    ADD CONSTRAINT check_discount_rate CHECK (discount_rate >= 0 AND discount_rate <= 100);

--TRIGGERS
-- Incrementar puntos del invitado por cada reserva
CREATE OR REPLACE FUNCTION increment_guest_points()
    RETURNS TRIGGER AS
$$
BEGIN
    UPDATE Guest
    SET points = points + 5
    WHERE user_id = NEW.guest_user_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_booking_insert
    AFTER INSERT
    ON Booking
    FOR EACH ROW
EXECUTE FUNCTION increment_guest_points();

-- Calcular el promedio de rating de la propiedad
CREATE OR REPLACE FUNCTION update_property_rating()
    RETURNS TRIGGER AS
$$
BEGIN
    -- Actualizar el promedio de calificación en la tabla Property
    UPDATE Property
    SET rating = (SELECT AVG(R.rating)
                  FROM Booking B
                           JOIN Review R ON B.booking_id = R.booking_id
                  WHERE B.property_id = Property.property_id)
    WHERE property_id = (SELECT property_id
                         FROM Booking
                         WHERE booking_id = NEW.booking_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_review_insert
    AFTER INSERT
    ON Review
    FOR EACH ROW
EXECUTE FUNCTION update_property_rating();



-- Calcular el promedio de rating del host
CREATE OR REPLACE FUNCTION update_host_rating()
    RETURNS TRIGGER AS
$$
BEGIN
    -- Actualizar el promedio de calificación en la tabla Host
    UPDATE Host
    SET host_rating = (SELECT AVG(R.rating)
                       FROM Property P
                                JOIN Booking B ON P.property_id = B.property_id
                                JOIN Review R ON B.booking_id = R.booking_id
                       WHERE P.host_user_id = Host.user_id)
    WHERE user_id = (SELECT P.host_user_id
                     FROM Booking B
                              JOIN Property P ON B.property_id = P.property_id
                     WHERE B.booking_id = NEW.booking_id);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_insert_review
    AFTER INSERT
    ON Review
    FOR EACH ROW
EXECUTE FUNCTION update_host_rating();



-- Ajustar el precio total de la reserva basado en puntos y descuentos
CREATE OR REPLACE FUNCTION adjust_total_price()
    RETURNS TRIGGER AS
$$
DECLARE
    descuento          DECIMAL(5, 2);
    points_of_guest    INT;
    precio_of_property DECIMAL(10, 2);
    p_start            DATE;
    p_end              DATE;
    bool               BOOLEAN;
BEGIN
    SELECT INTO bool CASE
                         WHEN COUNT(*) > 0 THEN TRUE
                         ELSE FALSE
                         END
    FROM Promotion
    WHERE property_id = NEW.property_id;

    SELECT points
    INTO points_of_guest
    FROM Guest
    WHERE user_id = NEW.guest_user_id;

    SELECT price
    INTO precio_of_property
    FROM Property
    WHERE property_id = NEW.property_id;

    SELECT start_date, end_date, discount_rate
    INTO p_start, p_end, descuento
    FROM Promotion
    WHERE property_id = NEW.property_id;

    IF (points_of_guest) > 29 AND (NEW.timestamp BETWEEN p_start AND p_end) AND bool THEN
        NEW.total_price = ROUND((precio_of_property) *
                                (1 - (descuento) / 100), 2);
    ELSE
        NEW.total_price = precio_of_property;
    END IF;
    IF (points_of_guest) > 29 AND (NEW.timestamp BETWEEN p_start AND p_end) AND bool THEN
        UPDATE Guest
        SET points = points - 30
        WHERE user_id = NEW.guest_user_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_booking_insert
    BEFORE INSERT
    ON Booking
    FOR EACH ROW
EXECUTE FUNCTION adjust_total_price();

-- Deshabilitar triggers temporalmente
ALTER TABLE Review
    DISABLE TRIGGER after_insert_review;
ALTER TABLE Review
    DISABLE TRIGGER after_review_insert;
ALTER TABLE Booking
    DISABLE TRIGGER after_booking_insert;
ALTER TABLE Booking
    DISABLE TRIGGER before_booking_insert;


--insertar data provicional de 1000 a partir de un csv
COPY usuario FROM '/Users/stewart/BD/data100000/usuarios100000.csv' DELIMITER ',' CSV HEADER;
COPY Guest (user_id) FROM '/Users/stewart/BD/data100000/guests100000.csv' DELIMITER ',' CSV HEADER;
COPY Host (user_id) FROM '/Users/stewart/BD/data100000/hosts100000.csv' DELIMITER ',' CSV HEADER;
COPY Message FROM '/Users/stewart/BD/data100000/messages100000.csv' DELIMITER ',' CSV HEADER;
COPY Property (property_id, n_bathrooms, title, n_beds, property_type, n_guests, n_rooms, host_user_id,
               price) FROM '/Users/stewart/BD/data100000/properties100000.csv' DELIMITER ',' CSV HEADER;
COPY Promotion (promotion_id, start_date, end_date, discount_rate, prom_description,
                property_id) FROM '/Users/stewart/BD/data100000/promotions100000.csv' DELIMITER ',' CSV HEADER;
COPY Booking (booking_id, timestamp, check_in_date, check_out_date, guest_user_id,
              property_id) FROM '/Users/stewart/BD/data100000/bookings100000.csv' DELIMITER ',' CSV HEADER;
COPY Amenities FROM '/Users/stewart/BD/data100000/amenities100000.csv' DELIMITER ',' CSV HEADER;
COPY Review FROM '/Users/stewart/BD/data100000/reviews100000.csv' DELIMITER ',' CSV HEADER;
COPY SelectFavorite FROM '/Users/stewart/BD/data100000/select_favorites100000.csv' DELIMITER ',' CSV HEADER;


-- Volver a habilitar triggers
ALTER TABLE Review
    ENABLE TRIGGER after_insert_review;
ALTER TABLE Review
    ENABLE TRIGGER after_review_insert;
ALTER TABLE Booking
    ENABLE TRIGGER after_booking_insert;
ALTER TABLE Booking
    ENABLE TRIGGER before_booking_insert;

-- Recalcular promedios de calificación después de la inserción
-- Calcular promedio de calificación de propiedades
WITH PropertyRatings AS (SELECT P.property_id,
                                COALESCE(AVG(R.rating), 0) AS avg_rating
                         FROM Property P
                                  JOIN Booking B ON P.property_id = B.property_id
                                  JOIN Review R ON B.booking_id = R.booking_id
                         GROUP BY P.property_id)
UPDATE Property
SET rating = PR.avg_rating
FROM PropertyRatings PR
WHERE Property.property_id = PR.property_id;

-- Calcular promedio de calificación de hosts
WITH HostRatings AS (SELECT H.user_id,
                            COALESCE(AVG(R.rating), 0) AS avg_rating
                     FROM Host H
                              JOIN Property P ON H.user_id = P.host_user_id
                              JOIN Booking B ON P.property_id = B.property_id
                              JOIN Review R ON B.booking_id = R.booking_id
                     GROUP BY H.user_id)
UPDATE Host
SET host_rating = HR.avg_rating
FROM HostRatings HR
WHERE Host.user_id = HR.user_id;

--------
--Recalcular puntos de los invitados:

UPDATE Guest
SET points = Guest.points + subquery.total_points
FROM (SELECT guest_user_id,
             COUNT(*) * 5 AS total_points
      FROM Booking
      GROUP BY guest_user_id) AS subquery
WHERE Guest.user_id = subquery.guest_user_id;

-- Ajustar el precio total de la reserva basado en puntos y descuentos
UPDATE Booking
SET total_price = subquery.adjusted_price
FROM (SELECT B.booking_id,
             CASE
                 WHEN G.points > 29 AND B.timestamp BETWEEN P.start_date AND P.end_date THEN
                     ROUND(Pr.price * (1 - P.discount_rate / 100), 2)
                 ELSE
                     Pr.price
                 END AS adjusted_price
      FROM Booking B
               JOIN Property Pr ON B.property_id = Pr.property_id
               JOIN Promotion P ON Pr.property_id = P.property_id
               JOIN Guest G ON B.guest_user_id = G.user_id) AS subquery
WHERE Booking.booking_id = subquery.booking_id;

-- Actualizar puntos de los invitados después del ajuste de precios
UPDATE Guest
SET points = points - 30
WHERE user_id IN (SELECT guest_user_id
                  FROM Booking B
                           JOIN Promotion P ON B.property_id = P.property_id
                  WHERE Guest.points > 29
                    AND B.timestamp BETWEEN P.start_date AND P.end_date
                    AND B.total_price != (SELECT price FROM Property WHERE property_id = B.property_id));

