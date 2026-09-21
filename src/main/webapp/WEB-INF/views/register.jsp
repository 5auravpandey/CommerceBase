<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Register" scope="request"/>
<jsp:include page="header.jsp"/>

<div class="max-w-md mx-auto mt-10 mb-10 bg-white p-8 rounded-lg shadow-sm border border-gray-200">
    <div class="text-center mb-8">
        <h2 class="text-2xl font-semibold text-gray-900 tracking-tight">Create an account</h2>
        <p class="text-sm text-gray-500 mt-1">Join us to start shopping</p>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-md mb-6 text-sm font-medium shadow-sm flex items-center gap-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-500" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" /></svg>
            <c:out value="${errorMessage}"/>
        </div>
    </c:if>

    <form method="POST" action="${pageContext.request.contextPath}/register" class="space-y-4">
        <div>
            <label for="fullName" class="block mb-1.5 text-sm font-medium text-gray-700">Full Name *</label>
            <input type="text" id="fullName" name="fullName"
                   value="<c:out value='${fullName}'/>" required autofocus
                   class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm transition-colors focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 shadow-sm text-gray-900">
        </div>

        <div>
            <label for="email" class="block mb-1.5 text-sm font-medium text-gray-700">Email Address *</label>
            <input type="email" id="email" name="email"
                   value="<c:out value='${email}'/>" required
                   class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm transition-colors focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 shadow-sm text-gray-900">
        </div>

        <div>
            <label for="phone" class="block mb-1.5 text-sm font-medium text-gray-700">Phone Number</label>
            <input type="tel" id="phone" name="phone"
                   value="<c:out value='${phone}'/>"
                   class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm transition-colors focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 shadow-sm text-gray-900">
        </div>

        <div>
            <label for="address" class="block mb-1.5 text-sm font-medium text-gray-700">Address</label>
            <textarea id="address" name="address"
                      class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm transition-colors min-h-[80px] focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 shadow-sm text-gray-900"><c:out value='${address}'/></textarea>
        </div>

        <div>
            <label for="password" class="block mb-1.5 text-sm font-medium text-gray-700">Password * (Min 6 chars)</label>
            <input type="password" id="password" name="password"
                   required minlength="6"
                   class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm transition-colors focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 shadow-sm text-gray-900">
        </div>

        <div>
            <label for="confirmPassword" class="block mb-1.5 text-sm font-medium text-gray-700">Confirm Password *</label>
            <input type="password" id="confirmPassword" name="confirmPassword"
                   required
                   class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm transition-colors focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 shadow-sm text-gray-900">
        </div>

        <button type="submit"
                class="w-full py-2.5 px-4 text-white font-medium text-sm rounded-md hover:opacity-90 transition-opacity shadow-sm mt-4"
                style="background:var(--cb-primary);">
            Create Account
        </button>
    </form>

    <div class="mt-8 text-center text-sm text-gray-600">
        Already have an account? 
        <a href="${pageContext.request.contextPath}/login" class="font-medium hover:underline" style="color:var(--cb-primary);">Sign in</a>
    </div>
</div>

<jsp:include page="footer.jsp"/>
