-- Users table to store general information about all users (both Borrowers and Administrators)
CREATE TABLE Users (
    User_ID NUMBER PRIMARY KEY,  -- Manually managed primary key for each user
    First_Name VARCHAR2(50) NOT NULL,  -- First name of the user
    Last_Name VARCHAR2(50) NOT NULL,  -- Last name of the user
    Phone_Number VARCHAR2(20),  -- User's contact phone number
    Email VARCHAR2(100) UNIQUE,  -- Unique email address for the user
    Username VARCHAR2(50) UNIQUE NOT NULL,  -- Unique username for logging in
    Password VARCHAR2(255) NOT NULL,  -- Password for logging in
    Street VARCHAR2(100),  -- Street address of the user
    City VARCHAR2(50),  -- City where the user resides
    State VARCHAR2(50),  -- State of the user's residence
    ZIP_Code VARCHAR2(10)  -- ZIP code of the user's residence
);

-- Borrowers table for users who borrow books
CREATE TABLE Borrowers (
    Borrower_ID NUMBER PRIMARY KEY,  -- Primary key for borrowers
    User_ID NUMBER UNIQUE,  -- Foreign key linking to the Users table
    Borrowing_Limit NUMBER DEFAULT 5 CHECK (Borrowing_Limit > 0),  -- Limit on the number of books
    Amount_Payable NUMBER DEFAULT 0 CHECK (Amount_Payable >= 0),  -- Outstanding fees
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

-- Administrators table for users who manage the library system
CREATE TABLE Administrators (
    Admin_ID NUMBER PRIMARY KEY,  -- Primary key for administrators
    User_ID NUMBER UNIQUE,  -- Foreign key linking to the Users table
    Role VARCHAR2(100) NOT NULL,  -- Role of the administrator
    Permissions VARCHAR2(255),  -- Permissions granted to the administrator
    Last_Login DATE,  -- Date of last login
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

-- Authors table to store information about book authors
CREATE TABLE Authors (
    Author_ID NUMBER PRIMARY KEY,  -- Primary key for authors
    Name VARCHAR2(100) NOT NULL,  -- Full name of the author
    Biography CLOB,  -- A longer field to store the author's biography
    Date_of_Birth DATE,  -- Birth date of the author
    Date_of_Death DATE,  -- Death date of the author (if applicable)
    Nationality VARCHAR2(50),  -- Nationality of the author
    Languages VARCHAR2(100)  -- Languages spoken or written by the author
);

-- Genres table to store different book genres
CREATE TABLE Genres (
    Genre_ID NUMBER PRIMARY KEY,  -- Primary key for genres
    Title VARCHAR2(50) NOT NULL UNIQUE,  -- Title of the genre (e.g., Fiction, Science Fiction)
    Description VARCHAR2(255)  -- Description of the genre
);

-- Books table to store information about library books
CREATE TABLE Books (
    ISBN VARCHAR2(20) PRIMARY KEY,  -- Unique identifier for each book
    Title VARCHAR2(200) NOT NULL,  -- Title of the book
    Publication_Date DATE,  -- Date when the book was published
    Pages NUMBER CHECK (Pages > 0),  -- Number of pages in the book
    Copies_Available NUMBER DEFAULT 1 CHECK (Copies_Available >= 0),  -- Number of available copies
    Publisher VARCHAR2(100),  -- Name of the book's publisher
    Admin_ID NUMBER,  -- Foreign key linking to Administrators table
    FOREIGN KEY (Admin_ID) REFERENCES Administrators(Admin_ID)
);

-- Loans table to store records of books that have been borrowed
CREATE TABLE Loans (
    Loan_Number NUMBER PRIMARY KEY,  -- Manually assigned primary key for each loan
    Borrower_ID NUMBER,  -- Foreign key linking to Borrowers table
    ISBN VARCHAR2(20),  -- Foreign key linking to Books table
    Loan_Date DATE DEFAULT SYSDATE,  -- Date when the loan was created
    Due_Date DATE,  -- Due date for returning the book
    Return_Date DATE,  -- Date when the book was returned
    Fine_Amount NUMBER DEFAULT 0 CHECK (Fine_Amount >= 0),  -- Fine for late returns
    Return_Status CHAR(1) CHECK (Return_Status IN ('Y', 'N')),  -- 'Y' if returned, 'N' if not
    Admin_ID NUMBER,  -- Foreign key linking to Administrators table
    FOREIGN KEY (Borrower_ID) REFERENCES Borrowers(Borrower_ID),
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN),
    FOREIGN KEY (Admin_ID) REFERENCES Administrators(Admin_ID)
);

-- BookAuthor table for many-to-many relationship between books and authors
CREATE TABLE BookAuthor (
    ISBN VARCHAR2(20),  -- Foreign key linking to Books table
    Author_ID NUMBER,  -- Foreign key linking to Authors table
    PRIMARY KEY (ISBN, Author_ID),  -- Composite primary key to ensure each book-author pair is unique
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN),
    FOREIGN KEY (Author_ID) REFERENCES Authors(Author_ID)
);

-- BookGenre table for many-to-many relationship between books and genres
CREATE TABLE BookGenre (
    ISBN VARCHAR2(20),  -- Foreign key linking to Books table
    Genre_ID NUMBER,  -- Foreign key linking to Genres table
    PRIMARY KEY (ISBN, Genre_ID),  -- Composite primary key to ensure each book-genre pair is unique
    FOREIGN KEY (ISBN) REFERENCES Books(ISBN),
    FOREIGN KEY (Genre_ID) REFERENCES Genres(Genre_ID)
);
