<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Checkout" scope="request"/>
<jsp:include page="header.jsp"/>

<div class="pb-4 pt-2 border-b border-gray-200 mb-6">
    <h1 class="text-2xl font-semibold text-gray-900 tracking-tight">Checkout</h1>
</div>

<c:if test="${not empty errorMessage}">
    <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-md mb-6 text-sm font-medium shadow-sm flex items-center gap-2">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-red-500" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd" /></svg>
        <c:out value="${errorMessage}"/>
    </div>
</c:if>

<form method="POST" action="${pageContext.request.contextPath}/checkout">
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start mb-12">

        <%-- Left Column: Shipping & Payment --%>
        <div class="lg:col-span-2 space-y-6">
            <div class="bg-white border border-gray-200 rounded-lg shadow-sm">
                <h3 class="text-base font-semibold text-gray-900 p-5 bg-gray-50 border-b border-gray-200 rounded-t-lg">Shipping Information</h3>
                <div class="p-6">
                    <label for="shippingAddress" class="block mb-2 text-sm font-medium text-gray-700">Delivery Address *</label>
                    <textarea id="shippingAddress" name="shippingAddress" required placeholder="Enter your full delivery address..."
                              class="w-full p-3 border border-gray-300 rounded-md bg-white text-gray-900 text-sm min-h-[120px] focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 shadow-sm"><c:out value='${not empty userAddress ? userAddress : ""}'/></textarea>
                </div>
            </div>

            <div class="bg-white border border-gray-200 rounded-lg shadow-sm">
                <h3 class="text-base font-semibold text-gray-900 p-5 bg-gray-50 border-b border-gray-200 rounded-t-lg">Payment Method</h3>
                <div class="p-6">
                    <select name="paymentMethod" class="w-full p-3 border border-gray-300 rounded-md text-gray-900 text-sm font-medium focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 bg-white cursor-pointer shadow-sm">
                        <option value="COD">Cash on Delivery (COD)</option>
                        <option value="UPI">UPI Transfer</option>
                        <option value="Card">Credit / Debit Card</option>
                    </select>
                </div>
            </div>
        </div>

        <%-- Right Column: Order Summary --%>
        <div class="lg:col-span-1">
            <div class="bg-white border border-gray-200 rounded-lg shadow-sm sticky top-24">
                <h3 class="text-base font-semibold text-gray-900 p-5 border-b border-gray-200 bg-gray-50 rounded-t-lg">Order Summary</h3>

                <div class="p-5">
                    <div class="space-y-4 mb-4 max-h-[300px] overflow-y-auto pr-2">
                        <c:forEach var="item" items="${cart}">
                            <div class="flex justify-between items-start text-sm">
                                <div class="pr-4">
                                    <div class="font-medium text-gray-900 mb-0.5"><c:out value="${item.productName}"/></div>
                                    <div class="text-gray-500">Qty: <c:out value="${item.quantity}"/></div>
                                </div>
                                <div class="font-medium text-gray-900 whitespace-nowrap">
                                    &#8377;<fmt:formatNumber value="${item.calculateSubtotal()}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="border-t border-gray-200 pt-4 mt-4">
                        <div class="flex justify-between items-center text-lg font-semibold text-gray-900 mb-6">
                            <span>Total</span>
                            <span>&#8377;<fmt:formatNumber value="${cartTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/></span>
                        </div>
                    </div>

                    <button type="submit" class="w-full text-center text-white font-medium text-sm py-3 px-4 rounded-md hover:opacity-90 transition-opacity shadow-sm" style="background:var(--cb-primary);">
                        Place Order
                    </button>

                    <a href="${pageContext.request.contextPath}/cart" class="block text-center mt-3 text-sm font-medium text-gray-500 hover:text-gray-700 transition-colors py-2">
                        Return to Cart
                    </a>
                </div>
            </div>
        </div>

    </div>
</form>

<jsp:include page="footer.jsp"/>
