<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="statusCode" value="${pageContext.errorData.statusCode}"/>
<c:if test="${statusCode == 0 || statusCode == 200}">
    <c:set var="statusCode" value="500"/>
</c:if>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${statusCode == 404}">Page Not Found</c:when>
            <c:otherwise>System Error</c:otherwise>
        </c:choose>
        &mdash; CommerceBase
    </title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 flex items-center justify-center min-h-screen font-sans">
    <div class="text-center p-10 bg-white border border-gray-200 rounded-lg shadow-sm max-w-md mx-4">
        
        <div class="mx-auto mb-6 flex items-center justify-center h-16 w-16 rounded-full bg-gray-100">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>
        </div>

        <c:choose>
            <c:when test="${statusCode == 404}">
                <h1 class="text-3xl font-semibold text-gray-900 mb-2">404</h1>
                <h2 class="text-lg font-medium text-gray-700 mb-3">Page Not Found</h2>
                <p class="text-gray-500 mb-8 text-sm">
                    The page you are looking for doesn't exist or has been moved.
                </p>
            </c:when>
            <c:otherwise>
                <h1 class="text-3xl font-semibold text-gray-900 mb-2">Error</h1>
                <h2 class="text-lg font-medium text-gray-700 mb-3">Something went wrong</h2>
                <p class="text-gray-500 mb-8 text-sm">
                    An unexpected error occurred. The incident has been logged.
                </p>
            </c:otherwise>
        </c:choose>

        <div class="flex flex-col sm:flex-row items-center justify-center gap-3">
            <a href="${pageContext.request.contextPath}/products"
               class="px-5 py-2.5 text-white font-medium text-sm rounded-md shadow-sm transition-opacity hover:opacity-90 w-full sm:w-auto"
               style="background:var(--cb-primary, #4F46E5);">
                Return to Store
            </a>
            <button onclick="history.back()"
                    class="px-5 py-2.5 bg-white text-gray-700 border border-gray-300 font-medium text-sm rounded-md shadow-sm transition-colors hover:bg-gray-50 w-full sm:w-auto">
                Go Back
            </button>
        </div>
    </div>
</body>
</html>
