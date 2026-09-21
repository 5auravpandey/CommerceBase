<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Shopping Cart" scope="request"/>
<jsp:include page="header.jsp"/>

<div class="flex items-center justify-between pb-4 pt-2 border-b border-gray-200 mb-6">
    <h1 class="text-2xl font-semibold text-gray-900 tracking-tight">Shopping Cart</h1>
    <c:if test="${not empty cart && cart.size() > 0}">
        <span class="text-gray-500 font-medium text-sm bg-white border border-gray-200 px-3 py-1 rounded-full shadow-sm"><c:out value="${cartItemCount}"/> items</span>
    </c:if>
</div>

<c:choose>
    <c:when test="${not empty cart && cart.size() > 0}">
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 mb-6 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-200 text-gray-600 text-xs font-semibold uppercase tracking-wider">
                            <th class="px-6 py-4">Product</th>
                            <th class="px-6 py-4">Price</th>
                            <th class="px-6 py-4">Quantity</th>
                            <th class="px-6 py-4 text-right">Subtotal</th>
                            <th class="px-6 py-4 text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100 text-sm">
                        <c:forEach var="item" items="${cart}">
                            <tr class="hover:bg-gray-50 transition-colors">
                                <td class="px-6 py-5">
                                    <div class="font-semibold text-gray-900 mb-1"><c:out value="${item.productName}"/></div>
                                    <div class="text-xs text-gray-500">ID: <c:out value="${item.productId}"/></div>
                                </td>
                                <td class="px-6 py-5 text-gray-600">
                                    &#8377;<fmt:formatNumber value="${item.unitPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td class="px-6 py-5">
                                    <form method="POST" action="${pageContext.request.contextPath}/cart" class="flex items-center gap-2 m-0">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="productId" value="${item.productId}">
                                        <input type="number" name="quantity" value="${item.quantity}" min="1" max="999"
                                               class="w-16 px-2 py-1.5 border border-gray-300 rounded-md bg-white text-center text-sm focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 shadow-sm">
                                        <button type="submit" class="bg-white border border-gray-300 text-gray-700 px-3 py-1.5 rounded-md text-xs font-medium hover:bg-gray-50 transition-colors shadow-sm">Update</button>
                                    </form>
                                </td>
                                <td class="px-6 py-5 font-semibold text-gray-900 text-right">
                                    &#8377;<fmt:formatNumber value="${item.calculateSubtotal()}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td class="px-6 py-5 text-center">
                                    <form method="POST" action="${pageContext.request.contextPath}/cart" class="m-0 inline-block">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="productId" value="${item.productId}">
                                        <button type="submit" class="text-red-500 hover:text-red-700 hover:bg-red-50 p-2 rounded-md transition-colors" title="Remove Item">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr class="bg-gray-50 border-t border-gray-200">
                            <td colspan="3" class="px-6 py-5 text-right font-semibold text-gray-700">Estimated Total</td>
                            <td class="px-6 py-5 font-bold text-lg text-right text-gray-900">
                                &#8377;<fmt:formatNumber value="${cartTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                            </td>
                            <td></td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>

        <%-- Cart actions --%>
        <div class="flex flex-col sm:flex-row items-center justify-between gap-4">
            <div class="flex gap-3 w-full sm:w-auto">
                <a href="${pageContext.request.contextPath}/products" class="flex-1 sm:flex-none text-center bg-white border border-gray-300 text-gray-700 px-4 py-2.5 rounded-md text-sm font-medium hover:bg-gray-50 transition-colors shadow-sm">
                    Continue Shopping
                </a>
                <form method="POST" action="${pageContext.request.contextPath}/cart" class="m-0 flex-1 sm:flex-none">
                    <input type="hidden" name="action" value="clear">
                    <button type="submit" class="w-full bg-white border border-gray-300 text-red-600 px-4 py-2.5 rounded-md text-sm font-medium hover:bg-red-50 transition-colors shadow-sm" onclick="return confirm('Are you sure you want to clear your cart?');">
                        Clear Cart
                    </button>
                </form>
            </div>
            <a href="${pageContext.request.contextPath}/checkout" class="w-full sm:w-auto text-center text-white px-6 py-2.5 rounded-md font-medium text-sm hover:opacity-90 transition-opacity shadow-sm" style="background:var(--cb-primary);">
                Proceed to Checkout
            </a>
        </div>
    </c:when>
    <c:otherwise>
        <div class="bg-white border border-gray-200 rounded-lg shadow-sm p-16 text-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-16 w-16 mx-auto text-gray-300 mb-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" /></svg>
            <h2 class="text-2xl font-semibold text-gray-900 mb-2">Your cart is empty</h2>
            <p class="text-gray-500 mb-6">Looks like you haven't added anything to your cart yet.</p>
            <a href="${pageContext.request.contextPath}/products" class="inline-block px-5 py-2.5 text-white font-medium text-sm rounded-md hover:opacity-90 shadow-sm transition-opacity" style="background:var(--cb-primary);">
                Start Shopping
            </a>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="footer.jsp"/>
