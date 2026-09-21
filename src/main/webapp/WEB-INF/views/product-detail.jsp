<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="${product.productName}" scope="request"/>
<jsp:include page="header.jsp"/>

<div class="py-4">
    <a href="${pageContext.request.contextPath}/products" class="inline-flex items-center gap-1 text-sm font-medium text-gray-500 hover:text-gray-900 transition-colors">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" /></svg>
        Back to Products
    </a>
</div>

<c:if test="${not empty product}">
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start mb-12">
        <%-- Left: Product Info --%>
        <div class="lg:col-span-2 bg-white border border-gray-200 rounded-lg shadow-sm overflow-hidden">
            <div class="h-80 bg-gray-50 border-b border-gray-100 flex items-center justify-center text-gray-300">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-24 w-24 opacity-50" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
            </div>
            <div class="p-8 sm:p-10">
                <c:if test="${not empty product.categoryName}">
                    <span class="inline-block bg-gray-100 text-gray-600 font-medium px-3 py-1 rounded-md text-xs mb-4"><c:out value="${product.categoryName}"/></span>
                </c:if>
                <h1 class="text-3xl font-semibold text-gray-900 mb-4 tracking-tight"><c:out value="${product.productName}"/></h1>
                <div class="text-gray-600 mb-8 text-base leading-relaxed">
                    <c:out value="${product.description}"/>
                </div>

                <div class="text-3xl font-bold mb-8 text-gray-900">
                    &#8377;<fmt:formatNumber value="${product.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                </div>

                <c:choose>
                    <c:when test="${product.stockQuantity > 0}">
                        <div class="flex items-center gap-2 text-green-600 font-medium text-sm mb-6">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" /></svg>
                            In Stock (<c:out value="${product.stockQuantity}"/> available)
                        </div>

                        <form method="POST" action="${pageContext.request.contextPath}/cart"
                              class="flex flex-col sm:flex-row items-stretch sm:items-center gap-4">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.productId}">
                            
                            <div class="flex items-center gap-3">
                                <label for="qty" class="text-sm font-medium text-gray-700">Quantity</label>
                                <input type="number" id="qty" name="quantity" value="1"
                                       min="1" max="${product.stockQuantity}"
                                       class="w-20 px-3 py-2 bg-white border border-gray-300 rounded-md text-center text-sm font-medium focus:outline-none focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 shadow-sm">
                            </div>
                            
                            <button type="submit" class="flex-grow sm:flex-grow-0 text-center text-white font-medium text-sm py-2.5 px-8 rounded-md hover:opacity-90 shadow-sm transition-opacity"
                                    style="background:var(--cb-primary);">
                                Add to Cart
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="flex items-center gap-2 text-red-500 font-medium text-sm mb-6">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" /></svg>
                            Out of Stock
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%-- Right: Quick Info --%>
        <div class="lg:col-span-1 bg-white border border-gray-200 rounded-lg shadow-sm">
            <h3 class="text-base font-semibold text-gray-900 p-5 border-b border-gray-100 bg-gray-50">Product Details</h3>
            <table class="w-full text-sm">
                <tbody class="divide-y divide-gray-100">
                    <tr>
                        <td class="p-5 text-gray-500">Product ID</td>
                        <td class="p-5 text-right font-medium text-gray-900">#<c:out value="${product.productId}"/></td>
                    </tr>
                    <tr>
                        <td class="p-5 text-gray-500">Category</td>
                        <td class="p-5 text-right font-medium text-gray-900">
                            <c:choose>
                                <c:when test="${not empty product.categoryName}"><c:out value="${product.categoryName}"/></c:when>
                                <c:otherwise>Uncategorized</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <td class="p-5 text-gray-500">Inventory Status</td>
                        <td class="p-5 text-right font-medium text-gray-900"><c:out value="${product.stockQuantity}"/> units</td>
                    </tr>
                    <tr>
                        <td class="p-5 text-gray-500">Store Status</td>
                        <td class="p-5 text-right">
                            <c:choose>
                                <c:when test="${product.active}"><span class="bg-green-100 text-green-800 px-2 py-0.5 rounded text-xs font-medium">Active</span></c:when>
                                <c:otherwise><span class="bg-gray-100 text-gray-800 px-2 py-0.5 rounded text-xs font-medium">Inactive</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</c:if>

<jsp:include page="footer.jsp"/>
