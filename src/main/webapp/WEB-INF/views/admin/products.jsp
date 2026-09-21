<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../header.jsp" />

<div class="w-full">
    <div class="sm:flex sm:items-center mb-6">
        <div class="sm:flex-auto">
            <h2 class="text-2xl font-semibold text-gray-900">Manage Products</h2>
        </div>
        <div class="mt-4 sm:mt-0 sm:ml-16 sm:flex-none">
            <a href="${pageContext.request.contextPath}/admin/products/manage?action=add" 
               class="inline-flex items-center justify-center rounded-md border border-transparent py-2 px-4 text-sm font-medium text-white shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2" style="background-color: ${fn:escapeXml(storeConfig.themeColor)};">
                Add Product
            </a>
        </div>
    </div>

    <div class="bg-gray-50 rounded-md shadow-sm overflow-hidden">
        <table class="min-w-full divide-y divide-gray-300">
            <thead class="bg-gray-100">
                <tr>
                    <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6">Name</th>
                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Category</th>
                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Price</th>
                    <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">Stock</th>
                    <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6">
                        <span class="sr-only">Edit</span>
                    </th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-200 bg-white">
                <c:forEach var="p" items="${products}">
                    <tr>
                        <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:pl-6">
                            <c:out value="${p.productName}" />
                        </td>
                        <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                            <c:out value="${p.categoryName}" />
                        </td>
                        <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                            <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="${storeConfig.currencyCode} " />
                        </td>
                        <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                            <c:out value="${p.stockQuantity}" />
                        </td>
                        <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6 space-x-2">
                            <a href="${pageContext.request.contextPath}/admin/products/manage?action=edit&id=${p.productId}" class="text-blue-600 hover:text-blue-900">Edit</a>
                            <form action="${pageContext.request.contextPath}/admin/products/manage" method="post" class="inline">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${p.productId}">
                                <button type="submit" class="text-red-600 hover:text-red-900" onclick="return confirm('Are you sure?');">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../footer.jsp" />
