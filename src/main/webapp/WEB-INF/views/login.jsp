<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Login" scope="request"/>
<jsp:include page="header.jsp"/>

<div class="max-w-md mx-auto mt-12 bg-white p-8 rounded-lg shadow-sm border border-gray-200">
    <div class="text-center mb-8">
        <h2 class="text-2xl font-semibold text-gray-900 tracking-tight">Welcome back</h2>
        <p class="text-sm text-gray-500 mt-1">Please sign in to your account</p>
    </div>

    <%-- Error from LoginServlet (forward) --%>
    <c:if test="${not empty errorMessage}">
        <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-md mb-6 text-sm font-medium shadow-sm flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-500" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" /></svg>
            <c:out value="${errorMessage}"/>
        </div>
    </c:if>

    <%-- Success/info from query param (redirect) --%>
    <c:if test="${not empty param.message}">
        <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-md mb-6 text-sm font-medium shadow-sm flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-green-500" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" /></svg>
            <c:out value="${param.message}"/>
        </div>
    </c:if>

    <form method="POST" action="${pageContext.request.contextPath}/login" class="space-y-5">
        <div>
            <label for="email" class="block mb-1.5 text-sm font-medium text-gray-700">Email Address</label>
            <input type="email" id="email" name="email"
                   value="<c:out value='${email}'/>" required autofocus
                   class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm transition-colors focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 shadow-sm text-gray-900">
        </div>

        <div>
            <label for="password" class="block mb-1.5 text-sm font-medium text-gray-700">Password</label>
            <input type="password" id="password" name="password"
                   required
                   class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm transition-colors focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 shadow-sm text-gray-900">
        </div>

        <button type="submit"
                class="w-full py-2.5 px-4 text-white font-medium text-sm rounded-md hover:opacity-90 transition-opacity shadow-sm mt-2"
                style="background:var(--cb-primary);">
            Sign in
        </button>
    </form>

    <div class="mt-8 text-center text-sm text-gray-600">
        Don't have an account? 
        <a href="${pageContext.request.contextPath}/register" class="font-medium hover:underline" style="color:var(--cb-primary);">Create one</a>
    </div>
</div>

<jsp:include page="footer.jsp"/>
