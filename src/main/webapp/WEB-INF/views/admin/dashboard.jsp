<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Admin Dashboard" scope="request"/>
<jsp:include page="../header.jsp"/>

<div class="flex flex-col sm:flex-row sm:items-center justify-between pb-4 pt-2 border-b border-gray-200 mb-6 gap-4">
    <h1 class="text-2xl font-semibold text-gray-900 tracking-tight">Dashboard Overview</h1>
    <span class="bg-white border border-gray-200 text-gray-600 text-sm font-medium px-3 py-1.5 rounded-full shadow-sm flex items-center gap-2">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
        <c:out value="${sessionScope.loggedInUser.fullName}"/>
    </span>
</div>

<c:if test="${not empty errorMessage}">
    <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-md mb-6 text-sm font-medium shadow-sm flex items-center gap-2">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-500" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" /></svg>
        <c:out value="${errorMessage}"/>
    </div>
</c:if>

<%-- Statistics Cards --%>
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
    <div class="bg-white p-5 border border-gray-200 rounded-lg shadow-sm flex flex-col justify-center">
        <div class="text-sm font-medium text-gray-500 mb-1">Total Orders</div>
        <div class="text-3xl font-bold text-gray-900"><c:out value="${totalOrders}"/></div>
    </div>
    <div class="bg-white p-5 border border-gray-200 rounded-lg shadow-sm flex flex-col justify-center">
        <div class="text-sm font-medium text-gray-500 mb-1">Pending Orders</div>
        <div class="text-3xl font-bold text-gray-900"><c:out value="${pendingOrders}"/></div>
    </div>
    <div class="bg-white p-5 border border-gray-200 rounded-lg shadow-sm flex flex-col justify-center">
        <div class="text-sm font-medium text-gray-500 mb-1">Completed Orders</div>
        <div class="text-3xl font-bold text-gray-900"><c:out value="${completedOrders}"/></div>
    </div>
    <div class="bg-white p-5 border border-gray-200 rounded-lg shadow-sm flex flex-col justify-center">
        <div class="text-sm font-medium text-gray-500 mb-1">Total Products</div>
        <div class="text-3xl font-bold text-gray-900"><c:out value="${totalProducts}"/></div>
    </div>
</div>

<%-- Orders Management Table --%>
<div class="bg-white border border-gray-200 rounded-lg shadow-sm overflow-hidden mb-8">
    <div class="px-6 py-4 border-b border-gray-200 bg-gray-50 flex items-center justify-between">
        <h2 class="text-base font-semibold text-gray-900 m-0">Recent Orders</h2>
    </div>

    <c:choose>
        <c:when test="${not empty orders}">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse whitespace-nowrap">
                    <thead>
                        <tr class="text-xs font-medium text-gray-500 uppercase tracking-wider border-b border-gray-200">
                            <th class="px-6 py-3">Order ID</th>
                            <th class="px-6 py-3">Customer</th>
                            <th class="px-6 py-3">Amount</th>
                            <th class="px-6 py-3">Payment</th>
                            <th class="px-6 py-3">Status</th>
                            <th class="px-6 py-3">Date</th>
                            <th class="px-6 py-3 text-right">Action</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100 text-sm">
                        <c:forEach var="order" items="${orders}">
                            <tr class="hover:bg-gray-50 transition-colors">
                                <td class="px-6 py-4 font-medium text-gray-900">#<c:out value="${order.orderId}"/></td>
                                <td class="px-6 py-4 text-gray-700"><c:out value="${order.customerName}"/></td>
                                <td class="px-6 py-4 font-medium text-gray-900">
                                    &#8377;<fmt:formatNumber value="${order.totalAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td class="px-6 py-4 text-gray-500 text-xs"><c:out value="${order.paymentMethod}"/></td>
                                <td class="px-6 py-4">
                                    <c:choose>
                                        <c:when test="${order.status == 'Pending'}"><span class="bg-yellow-100 text-yellow-800 px-2 py-0.5 rounded text-xs font-medium border border-yellow-200">Pending</span></c:when>
                                        <c:when test="${order.status == 'Processing'}"><span class="bg-blue-100 text-blue-800 px-2 py-0.5 rounded text-xs font-medium border border-blue-200">Processing</span></c:when>
                                        <c:when test="${order.status == 'Shipped'}"><span class="bg-indigo-100 text-indigo-800 px-2 py-0.5 rounded text-xs font-medium border border-indigo-200">Shipped</span></c:when>
                                        <c:when test="${order.status == 'Delivered'}"><span class="bg-green-100 text-green-800 px-2 py-0.5 rounded text-xs font-medium border border-green-200">Delivered</span></c:when>
                                        <c:when test="${order.status == 'Cancelled'}"><span class="bg-red-100 text-red-800 px-2 py-0.5 rounded text-xs font-medium border border-red-200">Cancelled</span></c:when>
                                        <c:otherwise><span class="bg-gray-100 text-gray-800 px-2 py-0.5 rounded text-xs font-medium border border-gray-200"><c:out value="${order.status}"/></span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4 text-xs text-gray-500">
                                    <fmt:formatDate value="${order.orderedAt}" pattern="MMM dd, yyyy HH:mm"/>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <form method="POST" action="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center justify-end gap-2 m-0">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <select name="status" class="px-2 py-1.5 border border-gray-300 rounded-md text-xs font-medium bg-white text-gray-700 focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 shadow-sm">
                                            <option value="Pending"    <c:if test="${order.status == 'Pending'}">selected</c:if>>Pending</option>
                                            <option value="Processing" <c:if test="${order.status == 'Processing'}">selected</c:if>>Processing</option>
                                            <option value="Shipped"    <c:if test="${order.status == 'Shipped'}">selected</c:if>>Shipped</option>
                                            <option value="Delivered"  <c:if test="${order.status == 'Delivered'}">selected</c:if>>Delivered</option>
                                            <option value="Cancelled"  <c:if test="${order.status == 'Cancelled'}">selected</c:if>>Cancelled</option>
                                        </select>
                                        <button type="submit" class="bg-white border border-gray-300 hover:bg-gray-50 text-gray-700 px-3 py-1.5 rounded-md text-xs font-medium transition-colors shadow-sm">
                                            Save
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="text-center py-12 px-4 text-gray-500">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 mx-auto text-gray-300 mb-3" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" /></svg>
                <p class="font-medium text-gray-600">No orders found.</p>
                <p class="text-sm">Orders will appear here once customers start purchasing.</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="../footer.jsp"/>
