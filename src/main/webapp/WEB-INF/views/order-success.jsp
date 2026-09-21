<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Order Confirmed" scope="request"/>
<jsp:include page="header.jsp"/>

<div class="max-w-xl mx-auto my-16 bg-white border border-gray-200 p-10 text-center rounded-lg shadow-sm">
    <div class="mx-auto mb-6 flex items-center justify-center h-16 w-16 rounded-full bg-green-100">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" /></svg>
    </div>
    
    <h1 class="text-2xl font-semibold text-gray-900 mb-4 tracking-tight">Order Confirmed</h1>

    <c:if test="${not empty orderId}">
        <p class="text-base mb-6 text-gray-600">
            Order Reference: <strong class="px-2 py-1 bg-gray-100 rounded text-gray-900 font-mono font-medium ml-1">#<c:out value="${orderId}"/></strong>
        </p>
    </c:if>

    <c:if test="${not empty successMessage}">
        <p class="text-green-700 font-medium mb-6 bg-green-50 px-4 py-3 rounded-md border border-green-200"><c:out value="${successMessage}"/></p>
    </c:if>

    <div class="text-gray-600 mb-10 text-sm leading-relaxed max-w-sm mx-auto">
        Thank you for shopping with 
        <c:choose>
            <c:when test="${not empty applicationScope.storeConfig}">
                <strong class="text-gray-900 font-medium"><c:out value="${applicationScope.storeConfig.storeName}"/></strong>.
            </c:when>
            <c:otherwise><strong class="text-gray-900 font-medium">CommerceBase</strong>.</c:otherwise>
        </c:choose>
        <br>Your order has been received and is currently being processed.
    </div>

    <div class="flex justify-center">
        <a href="${pageContext.request.contextPath}/products"
           class="inline-block px-6 py-2.5 text-white font-medium text-sm rounded-md hover:opacity-90 transition-opacity shadow-sm"
           style="background:var(--cb-primary);">
            Continue Shopping
        </a>
    </div>
</div>

<jsp:include page="footer.jsp"/>
