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

-- Tabla User
CREATE TABLE usuario
(
    user_id   VARCHAR(10),
    password  VARCHAR(255)        NOT NULL,
    name      VARCHAR(255)        NOT NULL,
    phone_num VARCHAR(20)         NOT NULL,
    birth     DATE,
    email     VARCHAR(255) UNIQUE NOT NULL
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
    promotion_id     VARCHAR(10),
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
    ADD CONSTRAINT check_phone_num CHECK (phone_num ~ '^[0-9]{9,15}$');
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
    CHECK (amenity_name IN ('WiFi', 'Pool', 'Gym', 'Air Conditioning', 'Heating', 'Kitchen', 'Free Parking', 'Washer', 'Dryer', 'TV',
                            'Hot Tub', 'Fireplace', 'Breakfast Included', '24-Hour Check-in', 'Pet Friendly', 'Elevator', 'Balcony',
                            'BBQ Grill', 'Laptop-friendly Workspace', 'Smoke Detector', 'Parking', 'Breakfast', 'Laundry', 'Concierge',
                            'Mini Bar', 'Safe', 'Room Service', 'Hair Dryer', 'Coffee Maker', 'Shuttle Service', 'BBQ Area', 'Nearby Attractions',
                            'Nearby Dining', 'Beach', 'Mountain View', 'Forest View', 'Lake View', 'City View', 'Country View', 'River View',
                            'Sea View', 'Garden View', 'Pool View', 'Park View'));

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
DECLARE
    total_rating NUMERIC;
    review_count INT;
    propertyid   varchar(10);
BEGIN
    -- Calcular el promedio de las calificaciones de la propiedad
    SELECT property_id
    INTO propertyid
    FROM Booking
    WHERE booking_id = NEW.booking_id;

    SELECT SUM(Review.rating)
    INTO total_rating
    FROM property
             JOIN Booking ON property.property_id = booking.property_id
             JOIN Review ON booking.booking_id = review.booking_id
    WHERE Property.property_id = propertyid;

    SELECT COUNT(DISTINCT Review.review_id)
    INTO review_count
    FROM property
             JOIN Booking ON property.property_id = booking.property_id
             JOIN Review ON booking.booking_id = review.booking_id
    WHERE Property.property_id = propertyid;

    -- Actualizar el rating en la tabla Property
    IF review_count > 0 THEN
        UPDATE Property
        SET rating = total_rating / review_count
        WHERE property_id = propertyid;
    ELSE
        -- Si no hay reviews, se podría establecer a 0, según la lógica deseada
        UPDATE Property
        SET rating = 0
        WHERE property_id = propertyid;
    END IF;
    RETURN NEW;
end;
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
DECLARE
    total_rating   NUMERIC;
    property_count INT;
    hostid         varchar(10);
    guestid        varchar(10);
BEGIN
    SELECT host_user_id, guest_user_id
    INTO hostid, guestid
    FROM Review
             JOIN Booking ON Review.booking_id = Booking.booking_id
             JOIN Property P on Booking.property_id = P.property_id
    WHERE Booking.booking_id = NEW.booking_id;

    -- Calcular el promedio de las calificaciones de todas las propiedades del host
    SELECT SUM(Review.rating)
    INTO total_rating
    FROM host
             JOIN Property ON host.user_id = property.host_user_id
             JOIN Booking ON property.property_id = booking.property_id
             JOIN Review ON booking.booking_id = review.booking_id
    WHERE host_user_id = hostid;

    SELECT COUNT(DISTINCT review.review_id)
    INTO property_count
    FROM host
             JOIN Property ON host.user_id = property.host_user_id
             JOIN Booking ON property.property_id = booking.property_id
             JOIN Review ON booking.booking_id = review.booking_id

    WHERE host_user_id = hostid;

    -- Actualizar el host_rating en la tabla Host
    IF property_count > 0 THEN
        UPDATE Host
        SET host_rating = total_rating / property_count
        WHERE user_id = hostid;
    ELSE
        -- Si no hay propiedades o reviews, se podría establecer a 0, según la lógica deseada
        UPDATE Host
        SET host_rating = 0
        WHERE user_id = hostid;

    END IF;

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


--insertar data
-- Insertar datos en la tabla usuario
INSERT INTO usuario (user_id, password, name, phone_num, birth, email)
VALUES ('U000000001', 'password1', 'John Doe', '1234567890', '1980-01-01', 'john@example.com'),
       ('U000000002', 'password2', 'Jane Smith', '1234567891', '1985-02-02', 'jane@example.com'),
       ('U000000003', 'password3', 'Alice Johnson', '1234567892', '1990-03-03', 'alice@example.com'),
       ('U000000004', 'password4', 'Bob Brown', '1234567893', '1975-04-04', 'bob@example.com'),
       ('U000000005', 'password5', 'Charlie Black', '1234567894', '1982-05-05', 'charlie@example.com'),
       ('U000000006', 'password6', 'Diana White', '1234567895', '1991-06-06', 'diana@example.com'),
       ('U000000007', 'password7', 'Edward Green', '1234567896', '1978-07-07', 'edward@example.com'),
       ('U000000008', 'password8', 'Fiona Blue', '1234567897', '1986-08-08', 'fiona@example.com'),
       ('U000000009', 'password9', 'George Red', '1234567898', '1992-09-09', 'george@example.com'),
       ('U000000010', 'password10', 'Hannah Yellow', '1234567899', '1983-10-10', 'hannah@example.com'),
       ('U000000011', 'password11', 'Ian Pink', '1234567800', '1987-11-11', 'ian@example.com'),
       ('U000000012', 'password12', 'Jack Purple', '1234567801', '1979-12-12', 'jack@example.com'),
       ('U000000013', 'password13', 'Kelly Grey', '1234567802', '1984-01-13', 'kelly@example.com'),
       ('U000000014', 'password14', 'Liam Gold', '1234567803', '1990-02-14', 'liam@example.com'),
       ('U000000015', 'password15', 'Mia Silver', '1234567804', '1988-03-15', 'mia@example.com');
-- Insertar datos en la tabla Guest
INSERT INTO Guest
VALUES ('U000000001'),
       ('U000000002'),
       ('U000000003'),
       ('U000000004'),
       ('U000000005'),
       ('U000000006'),
       ('U000000007'),
       ('U000000008'),
       ('U000000009'),
       ('U000000010');

-- Insertar datos en la tabla Host
INSERT INTO Host
VALUES ('U000000005'),
       ('U000000006'),
       ('U000000007'),
       ('U000000008'),
       ('U000000009'),
       ('U000000010'),
       ('U000000011'),
       ('U000000012'),
       ('U000000013'),
       ('U000000014'),
       ('U000000015');

-- Insertar datos en la tabla Message
INSERT INTO Message (message_id, guest_user_id, host_user_id, message_content, time_message)
VALUES ('M000000001', 'U000000001', 'U000000005', 'Hello, I have a question.', CURRENT_TIMESTAMP),
       ('M000000002', 'U000000001', 'U000000006', 'Can I book for next week?', CURRENT_TIMESTAMP),
       ('M000000003', 'U000000001', 'U000000007', 'Is breakfast included?', CURRENT_TIMESTAMP),
       ('M000000004', 'U000000001', 'U000000008', 'What is the check-out time?', CURRENT_TIMESTAMP),
       ('M000000005', 'U000000001', 'U000000009', 'Is there a parking space?', CURRENT_TIMESTAMP),
       ('M000000006', 'U000000001', 'U000000010', 'Can I bring my pet?', CURRENT_TIMESTAMP),
       ('M000000007', 'U000000001', 'U000000011', 'Are there any nearby attractions?', CURRENT_TIMESTAMP),
       ('M000000008', 'U000000001', 'U000000012', 'Is there WiFi?', CURRENT_TIMESTAMP),
       ('M000000009', 'U000000001', 'U000000013', 'What is the cancellation policy?', CURRENT_TIMESTAMP),
       ('M000000010', 'U000000001', 'U000000014', 'Can I get an early check-in?', CURRENT_TIMESTAMP),
       ('M000000011', 'U000000002', 'U000000005', 'Is there a kitchen?', CURRENT_TIMESTAMP),
       ('M000000012', 'U000000002', 'U000000006', 'What is the exact address?', CURRENT_TIMESTAMP),
       ('M000000013', 'U000000002', 'U000000007', 'Can I extend my stay?', CURRENT_TIMESTAMP),
       ('M000000014', 'U000000002', 'U000000008', 'Is there a gym?', CURRENT_TIMESTAMP),
       ('M000000015', 'U000000002', 'U000000009', 'Is there a pool?', CURRENT_TIMESTAMP),
       ('M000000016', 'U000000002', 'U000000010', 'Is there a balcony?', CURRENT_TIMESTAMP),
       ('M000000017', 'U000000002', 'U000000011', 'Is there a washing machine?', CURRENT_TIMESTAMP),
       ('M000000018', 'U000000002', 'U000000012', 'Is there a dryer?', CURRENT_TIMESTAMP),
       ('M000000019', 'U000000002', 'U000000013', 'Is there a dishwasher?', CURRENT_TIMESTAMP),
       ('M000000020', 'U000000002', 'U000000014', 'Is there a microwave?', CURRENT_TIMESTAMP),
       ('M000000021', 'U000000003', 'U000000005', 'Is there a refrigerator?', CURRENT_TIMESTAMP),
       ('M000000022', 'U000000003', 'U000000006', 'Is there a stove?', CURRENT_TIMESTAMP),
       ('M000000023', 'U000000003', 'U000000007', 'Is there a coffee maker?', CURRENT_TIMESTAMP),
       ('M000000024', 'U000000003', 'U000000008', 'Is there a toaster?', CURRENT_TIMESTAMP),
       ('M000000025', 'U000000003', 'U000000009', 'Is there a kettle?', CURRENT_TIMESTAMP),
       ('M000000026', 'U000000003', 'U000000010', 'Is there a blender?', CURRENT_TIMESTAMP),
       ('M000000027', 'U000000003', 'U000000011', 'Is there a rice cooker?', CURRENT_TIMESTAMP),
       ('M000000028', 'U000000003', 'U000000012', 'Is there a grill?', CURRENT_TIMESTAMP),
       ('M000000029', 'U000000003', 'U000000013', 'Is there a juicer?', CURRENT_TIMESTAMP),
       ('M000000030', 'U000000003', 'U000000014', 'Is there a mixer?', CURRENT_TIMESTAMP);

-- Insertar datos en la tabla Property
INSERT INTO Property (property_id, n_bathrooms, title, n_beds, property_type, n_guests, n_rooms, host_user_id,
                      price)
VALUES ('P000000001', 2, 'Cozy Apartment', 3, 'Entire place', 4, 2, 'U000000005', 100.00),
       ('P000000002', 1, 'Modern Studio', 1, 'Private room', 2, 1, 'U000000005', 200.00),
       ('P000000003', 3, 'Spacious House', 5, 'Entire place', 6, 4, 'U000000006', 300.00),
       ('P000000004', 2, 'Downtown Condo', 2, 'Entire place', 3, 2, 'U000000007', 250.00),
       ('P000000005', 1, 'Beachside Bungalow', 2, 'Entire place', 4, 3, 'U000000008', 350.00),
       ('P000000006', 4, 'Luxury Villa', 6, 'Entire place', 8, 5, 'U000000009', 500.00),
       ('P000000007', 2, 'Mountain Cabin', 3, 'Entire place', 5, 3, 'U000000010', 450.00),
       ('P000000008', 1, 'Quiet Cottage', 2, 'Entire place', 3, 2, 'U000000011', 150.00),
       ('P000000009', 2, 'City Loft', 1, 'Private room', 2, 1, 'U000000012', 180.00),
       ('P000000010', 3, 'Suburban Home', 4, 'Entire place', 6, 4, 'U000000013', 350.00),
       ('P000000011', 2, 'Penthouse Suite', 3, 'Entire place', 5, 3, 'U000000014', 400.00),
       ('P000000012', 1, 'Country House', 2, 'Entire place', 4, 3, 'U000000015', 250.00),
       ('P000000013', 3, 'Lakeside Cabin', 4, 'Entire place', 5, 4, 'U000000011', 300.00),
       ('P000000014', 2, 'Historic Home', 3, 'Entire place', 6, 5, 'U000000012', 450.00),
       ('P000000015', 1, 'Modern Apartment', 1, 'Private room', 2, 1, 'U000000013', 150.00),
       ('P000000016', 4, 'Seaside Villa', 5, 'Entire place', 7, 4, 'U000000009', 500.00),
       ('P000000017', 2, 'Riverside Cottage', 3, 'Entire place', 4, 3, 'U000000015', 250.00),
       ('P000000018', 1, 'Studio Loft', 1, 'Private room', 2, 1, 'U000000015', 200.00),
       ('P000000019', 3, 'Mountain Retreat', 4, 'Entire place', 5, 4, 'U000000006', 350.00),
       ('P000000020', 2, 'Downtown Apartment', 2, 'Private room', 3, 2, 'U000000007', 180.00),
       ('P000000021', 1, 'Beachfront Condo', 1, 'Private room', 2, 1, 'U000000007', 250.00),
       ('P000000022', 3, 'Countryside Villa', 4, 'Entire place', 6, 4, 'U000000008', 300.00),
       ('P000000023', 2, 'Urban Loft', 2, 'Private room', 3, 2, 'U000000006', 150.00),
       ('P000000024', 4, 'Forest Cabin', 5, 'Entire place', 7, 5, 'U000000007', 400.00),
       ('P000000025', 2, 'Sunny Studio', 1, 'Private room', 2, 1, 'U000000008', 180.00),
       ('P000000026', 1, 'Rustic House', 2, 'Entire place', 4, 3, 'U000000009', 250.00),
       ('P000000027', 3, 'Luxury Apartment', 3, 'Private room', 4, 2, 'U000000013', 300.00),
       ('P000000028', 2, 'Cozy Cabin', 2, 'Entire place', 3, 2, 'U000000011', 350.00),
       ('P000000029', 4, 'Modern House', 5, 'Entire place', 6, 4, 'U000000012', 500.00),
       ('P000000030', 1, 'Seaside Cottage', 1, 'Private room', 2, 1, 'U000000013', 150.00);


-- Insertar datos en la tabla Booking
INSERT INTO Booking (booking_id, timestamp, check_in_date, check_out_date, guest_user_id, property_id)
VALUES ('B000000001', '2024-06-01 12:00:00', '2024-06-05', '2024-06-10', 'U000000001', 'P000000001'),
       ('B000000002', '2024-06-02 12:00:00', '2024-06-06', '2024-06-11', 'U000000002', 'P000000002'),
       ('B000000003', '2024-06-03 12:00:00', '2024-06-07', '2024-06-12', 'U000000003', 'P000000003'),
       ('B000000004', '2024-06-04 12:00:00', '2024-06-08', '2024-06-13', 'U000000004', 'P000000004'),
       ('B000000005', '2024-06-05 12:00:00', '2024-06-09', '2024-06-14', 'U000000005', 'P000000005'),
       ('B000000006', '2024-06-06 12:00:00', '2024-06-10', '2024-06-15', 'U000000006', 'P000000006'),
       ('B000000007', '2024-06-07 12:00:00', '2024-06-11', '2024-06-16', 'U000000007', 'P000000007'),
       ('B000000008', '2024-06-08 12:00:00', '2024-06-12', '2024-06-17', 'U000000008', 'P000000008'),
       ('B000000009', '2024-06-09 12:00:00', '2024-06-13', '2024-06-18', 'U000000009', 'P000000009'),
       ('B000000010', '2024-06-10 12:00:00', '2024-06-14', '2024-06-19', 'U000000010', 'P000000010'),
       ('B000000011', '2024-06-11 12:00:00', '2024-06-15', '2024-06-20', 'U000000001', 'P000000011'),
       ('B000000012', '2024-06-12 12:00:00', '2024-06-16', '2024-06-21', 'U000000002', 'P000000012'),
       ('B000000013', '2024-06-13 12:00:00', '2024-06-17', '2024-06-22', 'U000000003', 'P000000013'),
       ('B000000014', '2024-06-14 12:00:00', '2024-06-18', '2024-06-23', 'U000000004', 'P000000014'),
       ('B000000015', '2024-06-15 12:00:00', '2024-06-19', '2024-06-24', 'U000000005', 'P000000015'),
       ('B000000016', '2024-06-16 12:00:00', '2024-06-20', '2024-06-25', 'U000000006', 'P000000016'),
       ('B000000017', '2024-06-17 12:00:00', '2024-06-21', '2024-06-26', 'U000000007', 'P000000017'),
       ('B000000018', '2024-06-18 12:00:00', '2024-06-22', '2024-06-27', 'U000000008', 'P000000018'),
       ('B000000019', '2024-06-19 12:00:00', '2024-06-23', '2024-06-28', 'U000000009', 'P000000019'),
       ('B000000020', '2024-06-20 12:00:00', '2024-06-24', '2024-06-29', 'U000000010', 'P000000020'),
       ('B000000021', '2024-06-21 12:00:00', '2024-06-25', '2024-06-30', 'U000000001', 'P000000021'),
       ('B000000022', '2024-06-22 12:00:00', '2024-06-26', '2024-07-01', 'U000000002', 'P000000022'),
       ('B000000023', '2024-06-23 12:00:00', '2024-06-27', '2024-07-02', 'U000000003', 'P000000023'),
       ('B000000024', '2024-06-24 12:00:00', '2024-06-28', '2024-07-03', 'U000000004', 'P000000024'),
       ('B000000025', '2024-06-25 12:00:00', '2024-06-29', '2024-07-04', 'U000000005', 'P000000025'),
       ('B000000026', '2024-06-26 12:00:00', '2024-06-30', '2024-07-05', 'U000000006', 'P000000026'),
       ('B000000027', '2024-06-27 12:00:00', '2024-07-01', '2024-07-06', 'U000000007', 'P000000027'),
       ('B000000028', '2024-06-28 12:00:00', '2024-07-02', '2024-07-07', 'U000000008', 'P000000028'),
       ('B000000029', '2024-06-29 12:00:00', '2024-07-03', '2024-07-08', 'U000000009', 'P000000029'),
       ('B000000030', '2024-06-30 12:00:00', '2024-07-04', '2024-07-09', 'U000000010', 'P000000030'),
       ('B000000031', '2024-07-01 12:00:00', '2024-07-05', '2024-07-10', 'U000000001', 'P000000001'),
       ('B000000032', '2024-07-02 12:00:00', '2024-07-06', '2024-07-11', 'U000000002', 'P000000002'),
       ('B000000033', '2024-07-03 12:00:00', '2024-07-07', '2024-07-12', 'U000000003', 'P000000003'),
       ('B000000034', '2024-07-04 12:00:00', '2024-07-08', '2024-07-13', 'U000000004', 'P000000004'),
       ('B000000035', '2024-07-05 12:00:00', '2024-07-09', '2024-07-14', 'U000000005', 'P000000005'),
       ('B000000036', '2024-07-06 12:00:00', '2024-07-10', '2024-07-15', 'U000000006', 'P000000006'),
       ('B000000037', '2024-07-07 12:00:00', '2024-07-11', '2024-07-16', 'U000000007', 'P000000007'),
       ('B000000038', '2024-07-08 12:00:00', '2024-07-12', '2024-07-17', 'U000000008', 'P000000008'),
       ('B000000039', '2024-07-09 12:00:00', '2024-07-13', '2024-07-18', 'U000000009', 'P000000009'),
       ('B000000040', '2024-07-10 12:00:00', '2024-07-14', '2024-07-19', 'U000000010', 'P000000010'),
       ('B000000041', '2024-07-11 12:00:00', '2024-07-15', '2024-07-20', 'U000000001', 'P000000011'),
       ('B000000042', '2024-07-12 12:00:00', '2024-07-16', '2024-07-21', 'U000000002', 'P000000012'),
       ('B000000043', '2024-07-13 12:00:00', '2024-07-17', '2024-07-22', 'U000000003', 'P000000013'),
       ('B000000044', '2024-07-14 12:00:00', '2024-07-18', '2024-07-23', 'U000000004', 'P000000014'),
       ('B000000045', '2024-07-15 12:00:00', '2024-07-19', '2024-07-24', 'U000000005', 'P000000015'),
       ('B000000046', '2024-07-16 12:00:00', '2024-07-20', '2024-07-25', 'U000000006', 'P000000018'),
       ('B000000047', '2024-07-17 12:00:00', '2024-07-21', '2024-07-26', 'U000000007', 'P000000018'),
       ('B000000048', '2024-07-18 12:00:00', '2024-07-22', '2024-07-27', 'U000000008', 'P000000018'),
       ('B000000049', '2024-07-19 12:00:00', '2024-07-23', '2024-07-28', 'U000000009', 'P000000017'),
       ('B000000050', '2024-07-20 12:00:00', '2024-07-24', '2024-07-29', 'U000000010', 'P000000017'),
       ('B000000051', '2024-07-21 12:00:00', '2024-07-25', '2024-07-30', 'U000000001', 'P000000020'),
       ('B000000052', '2024-07-22 12:00:00', '2024-07-26', '2024-07-31', 'U000000002', 'P000000022'),
       ('B000000053', '2024-07-23 12:00:00', '2024-07-27', '2024-08-01', 'U000000003', 'P000000022'),
       ('B000000054', '2024-07-24 12:00:00', '2024-07-28', '2024-08-02', 'U000000004', 'P000000022'),
       ('B000000055', '2024-07-25 12:00:00', '2024-07-29', '2024-08-03', 'U000000005', 'P000000025'),
       ('B000000056', '2024-07-26 12:00:00', '2024-07-30', '2024-08-04', 'U000000006', 'P000000025'),
       ('B000000057', '2024-07-27 12:00:00', '2024-07-31', '2024-08-05', 'U000000007', 'P000000025'),
       ('B000000058', '2024-07-28 12:00:00', '2023-08-01', '2024-08-06', 'U000000008', 'P000000002'),
       ('B000000059', '2024-07-29 12:00:00', '2024-08-02', '2024-08-07', 'U000000009', 'P000000001'),
       ('B000000060', '2024-07-30 12:00:00', '2024-08-03', '2024-08-08', 'U000000010', 'P000000001');


-- Insertar datos en la tabla Promotion
INSERT INTO Promotion (promotion_id, start_date, end_date, discount_rate, prom_description, property_id)
VALUES ('PR00000001', '2024-01-01', '2024-12-31', 10.00, 'Winter Promotion', 'P000000001'),
       ('PR00000002', '2024-02-01', '2024-11-30', 15.00, 'Fall Promotion', 'P000000002'),
       ('PR00000003', '2024-03-01', '2024-10-31', 20.00, 'Spring Promotion', 'P000000003'),
       ('PR00000004', '2024-04-01', '2024-09-30', 25.00, 'Summer Promotion', 'P000000004'),
       ('PR00000005', '2024-03-01', '2024-08-31', 30.00, 'Holiday Promotion', 'P000000005'),
       ('PR00000006', '2024-03-01', '2024-07-31', 40.00, 'Early Bird Promotion', 'P000000006'),
       ('PR00000007', '2024-02-01', '2024-06-30', 10.00, 'Last Minute Promotion', 'P000000007');


-- Insertar datos en la tabla Amenities
INSERT INTO Amenities (amenity_id, condition, amenity_name, property_id)
VALUES ('A000000001', 'Yes', 'Parking', 'P000000001'),
       ('A000000002', 'Yes', 'WiFi', 'P000000002'),
       ('A000000003', 'Yes', 'Breakfast', 'P000000003'),
       ('A000000004', 'Yes', 'Air Conditioning', 'P000000004'),
       ('A000000005', 'Yes', 'Gym', 'P000000005'),
       ('A000000006', 'Yes', 'Pool', 'P000000006'),
       ('A000000007', 'Yes', 'Kitchen', 'P000000007'),
       ('A000000008', 'Yes', 'Laundry', 'P000000008'),
       ('A000000009', 'Yes', 'Balcony', 'P000000009'),
       ('A000000010', 'Yes', 'Concierge', 'P000000010'),
       ('A000000011', 'Yes', 'Mini Bar', 'P000000011'),
       ('A000000012', 'Yes', 'Safe', 'P000000012'),
       ('A000000013', 'Yes', 'Room Service', 'P000000013'),
       ('A000000014', 'Yes', 'Hair Dryer', 'P000000014'),
       ('A000000015', 'Yes', 'Coffee Maker', 'P000000015'),
       ('A000000016', 'Yes', 'Shuttle Service', 'P000000016'),
       ('A000000017', 'Yes', 'BBQ Area', 'P000000017'),
       ('A000000018', 'Yes', 'Nearby Attractions', 'P000000018'),
       ('A000000019', 'Yes', 'Nearby Dining', 'P000000019'),
       ('A000000020', 'Yes', 'Beach', 'P000000020'),
       ('A000000021', 'Yes', 'Mountain View', 'P000000021'),
       ('A000000022', 'Yes', 'Forest View', 'P000000022'),
       ('A000000023', 'Yes', 'Lake View', 'P000000023'),
       ('A000000024', 'Yes', 'City View', 'P000000024'),
       ('A000000025', 'Yes', 'Country View', 'P000000025'),
       ('A000000026', 'Yes', 'River View', 'P000000026'),
       ('A000000027', 'Yes', 'Sea View', 'P000000027'),
       ('A000000028', 'Yes', 'Garden View', 'P000000028'),
       ('A000000029', 'Yes', 'Pool View', 'P000000029'),
       ('A000000030', 'Yes', 'Park View', 'P000000030');


INSERT INTO Review (review_id, booking_id, comment, rating)
VALUES ('R000000001', 'B000000001', 'Great place to stay!', 4.5),
       ('R000000002', 'B000000002', 'Nice and cozy.', 4.0),
       ('R000000003', 'B000000003', 'Spacious and comfortable.', 4.8),
       ('R000000004', 'B000000004', 'Convenient location.', 4.2),
       ('R000000005', 'B000000005', 'Beautiful view.', 4.7),
       ('R000000006', 'B000000006', 'Luxurious amenities.', 4.9),
       ('R000000007', 'B000000007', 'Peaceful retreat.', 4.6),
       ('R000000008', 'B000000008', 'Quiet and relaxing.', 4.1),
       ('R000000009', 'B000000009', 'Clean and tidy.', 4.3),
       ('R000000010', 'B000000010', 'Modern and stylish.', 4.4),
       ('R000000011', 'B000000011', 'Charming and quaint.', 4.1),
       ('R000000012', 'B000000012', 'Rustic and cozy.', 4.2),
       ('R000000013', 'B000000013', 'Scenic and serene.', 4.7),
       ('R000000014', 'B000000014', 'Historic charm.', 4.9),
       ('R000000015', 'B000000015', 'Contemporary design.', 4.8),
       ('R000000016', 'B000000016', 'Sunny and bright.', 4.3),
       ('R000000017', 'B000000017', 'Tranquil and peaceful.', 4.6),
       ('R000000018', 'B000000018', 'Cozy and comfortable.', 4.1),
       ('R000000019', 'B000000019', 'Relaxing and rejuvenating.', 4.4),
       ('R000000020', 'B000000020', 'Stylish and modern.', 4.5);


-- CONSULTAS

-- 1) que property_type son mas populares en las
-- propiedades que su numero de reservaciones
-- excede el promedio que realizaron cada mes del año 2024
-- codigo de las propiedades que tienen mas reservaciones que el promedio

SELECT w.month, property_type, w.num
FROM (SELECT EXTRACT(MONTH FROM check_in_date) AS month, P.property_type, COUNT(DISTINCT booking_id) AS num
      FROM Property P
               JOIN Booking ON P.property_id = Booking.property_id
      WHERE P.property_id IN (SELECT x.property_id
                              FROM (SELECT P.property_id, COUNT(DISTINCT B.booking_id) AS total_bookings
                                    FROM Property P
                                             JOIN Booking B on P.property_id = B.property_id
                                    WHERE EXTRACT(YEAR FROM B.check_in_date) = 2024
                                    GROUP BY P.property_id) as x
                              WHERE x.total_bookings > (SELECT AVG(y.total_bookings)
                                                        FROM (SELECT COUNT(DISTINCT B.booking_id) AS total_bookings
                                                              FROM Property P
                                                                       JOIN Booking B on P.property_id = B.property_id
                                                              WHERE EXTRACT(YEAR FROM B.check_in_date) = 2024
                                                              GROUP BY P.property_id) as y))
      GROUP BY month, P.property_type) as w
WHERE (w.month, w.num) IN (SELECT w.month, max(w.num)
                           FROM (SELECT EXTRACT(MONTH FROM check_in_date) AS month, COUNT(DISTINCT booking_id) AS num
                                 FROM Property P
                                          JOIN Booking ON P.property_id = Booking.property_id
                                 WHERE P.property_id IN (SELECT x.property_id
                                                         FROM (SELECT P.property_id, COUNT(DISTINCT B.booking_id) AS total_bookings
                                                               FROM Property P
                                                                        JOIN Booking B on P.property_id = B.property_id
                                                               WHERE EXTRACT(YEAR FROM B.check_in_date) = 2024
                                                               GROUP BY P.property_id) as x
                                                         WHERE x.total_bookings > (SELECT AVG(y.total_bookings)
                                                                                   FROM (SELECT COUNT(DISTINCT B.booking_id) AS total_bookings
                                                                                         FROM Property P
                                                                                                  JOIN Booking B on P.property_id = B.property_id
                                                                                         WHERE EXTRACT(YEAR FROM B.check_in_date) = 2024
                                                                                         GROUP BY P.property_id) as y))
                                 GROUP BY month, P.property_type) as w
                           GROUP BY w.month
                           ORDER BY w.month ASC);


-- 2) como se que tan efectivas son las promociones?
-- codigo de las propiedades que tienen mas reservaciones con promocion o sin ella

SELECT x.property_id,
       x.promotion_effect,
       x.num_bookings
FROM (SELECT P.property_id,
             'SIN'               AS promotion_effect,
             COUNT(B.booking_id) AS num_bookings
      FROM Property P
               JOIN Booking B on P.property_id = B.property_id
      WHERE B.total_price = P.price
      GROUP BY P.property_id
      UNION
      SELECT P.property_id,
             'CON'               AS promotion_effect,
             COUNT(B.booking_id) AS num_bookings
      FROM Property P
               JOIN Booking B on P.property_id = B.property_id
      WHERE B.total_price < P.price
      GROUP BY P.property_id) as x
WHERE (x.property_id, x.num_bookings) IN (SELECT y.property_id, MAX(y.num_bookings)
                                          FROM (SELECT P.property_id,
                                                       'SIN'               AS promotion_effect,
                                                       COUNT(B.booking_id) AS num_bookings
                                                FROM Property P
                                                         JOIN Booking B on P.property_id = B.property_id
                                                WHERE B.total_price = P.price
                                                GROUP BY P.property_id
                                                UNION
                                                SELECT P.property_id,
                                                       'CON'               AS promotion_effect,
                                                       COUNT(B.booking_id) AS num_bookings
                                                FROM Property P
                                                         JOIN Booking B on P.property_id = B.property_id
                                                WHERE B.total_price < P.price
                                                GROUP BY P.property_id) as y
                                          GROUP BY y.property_id);

--3) la cantidad de ammenities que tiene cada propiedad afecta en su rating o cantidad de reservas ?

SELECT P.property_id,
       COUNT(DISTINCT A.amenity_id) AS num_amenities,
       COUNT(DISTINCT B.booking_id) AS num_bookings,
       AVG(R.rating) AS avg_rating
FROM Property P
JOIN Amenities A ON P.property_id = A.property_id
JOIN Booking B ON P.property_id = B.property_id
JOIN Review R ON B.booking_id = R.booking_id
GROUP BY P.property_id, P.property_type
ORDER BY num_amenities DESC, num_bookings DESC, avg_rating DESC;