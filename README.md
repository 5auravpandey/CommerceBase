# CommerceBase

**A White-Label E-Commerce Platform built with Java EE, Servlets, and MySQL.**

![CommerceBase Banner](https://via.placeholder.com/1000x400.png?text=CommerceBase+E-Commerce)

CommerceBase is a robust, dynamic e-commerce web application developed as a BCA Major Project. Designed without heavy frontend frameworks or ORMs, it demonstrates a deep understanding of core Java principles, MVC architecture, raw JDBC, and session management.

## 🚀 Features

### Customer Features
- **Authentication:** Secure registration and login with SHA-256 password hashing.
- **Product Catalog:** Browse products, filter by categories, and search via keywords.
- **Shopping Cart:** Session-based shopping cart allowing users to add, update, and remove items dynamically.
- **Checkout:** Secure checkout process that generates persistent database orders.
- **Order History:** Customers can view a comprehensive history of their past orders and track their shipping status (Pending, Shipped, Delivered).

### Administrator Features
- **Dashboard Overview:** Real-time statistics on total orders, pending orders, and total products.
- **Order Management:** Admins can view all customer orders and seamlessly update fulfillment statuses.
- **Product Management:** Full CRUD (Create, Read, Update, Delete) capabilities to manage the store's inventory, pricing, and active visibility.
- **White-Label Branding Engine:** Admins can dynamically update the Store Name, Tagline, Logo, Theme Color (Hex), and Currency directly from the dashboard. Changes instantly reflect across the entire application's UI via dynamic CSS custom properties.

## 🛠️ Tech Stack
- **Backend:** Java 11, Servlets, JSP (JavaServer Pages), JSTL
- **Database:** MySQL 8.0, raw JDBC with `PreparedStatement` (SQL Injection protection)
- **Frontend:** HTML5, Tailwind CSS (via CDN)
- **Server:** Apache Tomcat 7
- **Build Tool:** Maven

## 🔒 Security Highlights
- **XSS Protection:** All user-generated content is sanitized using JSTL `<c:out>`.
- **SQL Injection Prevention:** Strict adherence to parameterized JDBC queries.
- **Authentication Filters:** `AuthFilter` protects all `/admin/*` routes and checkout flows, actively intercepting unauthorized access.
- **Password Security:** Plaintext passwords are never stored; all authentication is verified against SHA-256 hashes.
- **Graceful Error Handling:** Custom `error.jsp` masks Tomcat stack traces from end users.

## ⚙️ Setup Instructions

### 1. Database Setup
1. Create a MySQL database named `commercebase`.
2. Execute the `database/schema.sql` script to generate the required tables and seed the initial white-label configuration.

### 2. Configuration
Ensure your MySQL credentials are correct in `src/main/java/com/commercebase/util/DBConnection.java`:
```java
private static final String URL = "jdbc:mysql://localhost:3306/commercebase?useSSL=false";
private static final String USER = "root";
private static final String PASS = "12345"; // Update to match your local DB
```

### 3. Build & Run
Compile the project into a WAR file using Maven:
```bash
mvn clean package
```
Deploy the generated `commercebase-1.0-SNAPSHOT.war` from the `target/` directory to your Tomcat `webapps` folder, and start the Tomcat server.

## 👨‍💻 Author
**Saurav Pandey**  
BCA Major Project — 2025
