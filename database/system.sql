
CREATE TABLE Users (
    userID INT PRIMARY KEY AUTO_INCREMENT,
    fullName VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    passwordHash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Categories (
    categoryID INT PRIMARY KEY AUTO_INCREMENT,
    categoryName VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    isActive BOOLEAN DEFAULT TRUE
);



CREATE TABLE Items (
    itemID INT PRIMARY KEY AUTO_INCREMENT,
    ownerID INT NOT NULL,
    categoryID INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    pricePerDay DECIMAL(10, 2) NOT NULL,
    deposit DECIMAL(10, 2) DEFAULT 0.00,
    itemCondition ENUM('New', 'Like New', 'Good', 'Fair') DEFAULT 'Good',
    location VARCHAR(255),
    minimumRentalDays INT DEFAULT 1,
    maximumRentalDays INT DEFAULT 30,
    status ENUM('Available', 'Unavailable', 'Maintenance') DEFAULT 'Available',
    isActive BOOLEAN DEFAULT TRUE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ownerID) REFERENCES Users(userID) ON DELETE CASCADE,
    FOREIGN KEY (categoryID) REFERENCES Categories(categoryID) ON DELETE RESTRICT
);


CREATE TABLE Rentals (
    rentalID INT PRIMARY KEY AUTO_INCREMENT,
    itemID INT NOT NULL,
    customerID INT NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    totalAmount DECIMAL(10, 2),
    securityDeposit DECIMAL(10, 2),
    pickupMethod ENUM('Delivery', 'Pickup', 'Meet') DEFAULT 'Pickup',
    returnMethod ENUM('Delivery', 'Pickup', 'Meet') DEFAULT 'Pickup',
    notes TEXT,
    status ENUM('Pending', 'Confirmed', 'Active', 'Completed', 'Cancelled') DEFAULT 'Pending',
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (itemID) REFERENCES Items(itemID) ON DELETE CASCADE,
    FOREIGN KEY (customerID) REFERENCES Users(userID) ON DELETE CASCADE
);

CREATE TABLE Transactions (
    transactionID INT PRIMARY KEY AUTO_INCREMENT,
    rentalID INT NOT NULL,
    userID INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    systemFee DECIMAL(10, 2) DEFAULT 0.00,
    paymentMethod ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Digital Wallet') NOT NULL,
    transactionType ENUM('Payment', 'Refund', 'Deposit', 'Release') DEFAULT 'Payment',
    status ENUM('Pending', 'Completed', 'Failed', 'Cancelled') DEFAULT 'Pending',
    transactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rentalID) REFERENCES Rentals(rentalID) ON DELETE CASCADE,
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE CASCADE
);


CREATE TABLE PaymentHistory (
    paymentHistoryID INT PRIMARY KEY AUTO_INCREMENT,
    transactionID INT NOT NULL,
    userID INT NOT NULL,
    viewedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transactionID) REFERENCES Transactions(transactionID) ON DELETE CASCADE,
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE CASCADE
);


CREATE TABLE RatingReview (
    ratingID INT PRIMARY KEY AUTO_INCREMENT,
    itemID INT NOT NULL,
    userID INT NOT NULL,
    rentalID INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    isVerifiedPurchase BOOLEAN DEFAULT FALSE,
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (itemID) REFERENCES Items(itemID) ON DELETE CASCADE,
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE CASCADE,
    FOREIGN KEY (rentalID) REFERENCES Rentals(rentalID) ON DELETE SET NULL
);


CREATE TABLE Notifications (
    notificationID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT NOT NULL,
    rentalID INT,
    message TEXT NOT NULL,
    type ENUM('Booking', 'Payment', 'Reminder', 'Alert', 'Message', 'Review') NOT NULL,
    isRead BOOLEAN DEFAULT FALSE,
    sentAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userID) REFERENCES Users(userID) ON DELETE CASCADE,
    FOREIGN KEY (rentalID) REFERENCES Rentals(rentalID) ON DELETE CASCADE
);

