# System Architecture
**Strict Constraint:** This is a legacy-style Java Enterprise application. Do NOT introduce Node.js, React, Angular, or Next.js.
- **Backend:** Core Java (JDK 11+), Servlets, JSP (JavaServer Pages).
- **Architecture Pattern:** Strict MVC (Model-View-Controller).
- **Database:** MySQL via raw JDBC (No Hibernate/ORMs).
- **Server:** Apache Tomcat 7 (via Maven plugin).
- **Frontend:** HTML5, standard JSP rendering, and Tailwind CSS (via CDN only).
