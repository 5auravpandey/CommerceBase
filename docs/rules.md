# Engineering Rules
1. **Code Humanization:** Strip all redundant, robotic comments (e.g., do not comment `// check if null`). Add `/* @author Saurav Pandey | CommerceBase */` to the top of all Java files.
2. **Security - XSS:** Never output raw database strings in JSP using `${...}`. ALL dynamic text must be sanitized using JSTL `<c:out value="${...}" />`.
3. **Security - Error Masking:** Never leak Tomcat 500/404 stack traces. Use `web.xml` error page routing to a custom `error.jsp`.
4. **Vulnerability Tools:** Run a strict logical audit on session management before modifying Controllers.
