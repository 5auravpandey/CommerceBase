<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="My Orders" scope="request"/>
<jsp:include page="header.jsp" />

    <div class="w-full">
        <h1 class="text-3xl font-bold text-gray-800 mb-6">Order History</h1>

        <c:choose>
            <c:when test="${empty orders}">
                <div class="bg-white rounded-md shadow-sm p-8 text-center border border-gray-100">
                    <p class="text-gray-500 mb-4">You have not placed any orders yet.</p>
                    <a href="${pageContext.request.contextPath}/products" class="inline-block bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded-md transition-colors">Start Shopping</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="bg-white rounded-md shadow-sm overflow-hidden border border-gray-100">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-gray-50 border-b border-gray-200">
                                    <th class="py-4 px-6 font-semibold text-gray-600">Order ID</th>
                                    <th class="py-4 px-6 font-semibold text-gray-600">Date</th>
                                    <th class="py-4 px-6 font-semibold text-gray-600">Total</th>
                                    <th class="py-4 px-6 font-semibold text-gray-600">Status</th>
                                    <th class="py-4 px-6 font-semibold text-gray-600">Shipping</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-100">
                                <c:forEach var="order" items="${orders}">
                                    <tr class="hover:bg-gray-50 transition-colors">
                                        <td class="py-4 px-6 font-medium text-gray-900">
                                            #<c:out value="${order.orderId}" />
                                        </td>
                                        <td class="py-4 px-6 text-gray-600">
                                            <fmt:formatDate value="${order.orderedAt}" pattern="MMM dd, yyyy" />
                                        </td>
                                        <td class="py-4 px-6 font-medium text-gray-900">
                                            $<c:out value="${order.totalAmount}" />
                                        </td>
                                        <td class="py-4 px-6">
                                            <c:choose>
                                                <c:when test="${order.status eq 'Pending'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                                                        <c:out value="${order.status}" />
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.status eq 'Shipped'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                                                        <c:out value="${order.status}" />
                                                    </span>
                                                </c:when>
                                                <c:when test="${order.status eq 'Delivered'}">
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                                        <c:out value="${order.status}" />
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                                                        <c:out value="${order.status}" />
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="py-4 px-6 text-gray-600 text-sm max-w-xs truncate" title="<c:out value='${order.shippingAddress}'/>">
                                            <c:out value="${order.shippingAddress}" />
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <jsp:include page="footer.jsp" />
