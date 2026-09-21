<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="../header.jsp" />

<div class="w-full max-w-3xl mx-auto">
    <div class="bg-gray-50 rounded-md shadow-sm p-6 sm:p-8">
        <h2 class="text-2xl font-semibold text-gray-900 mb-6">Store Settings</h2>
        
        <c:if test="${param.success == '1'}">
            <div class="mb-6 bg-green-50 text-green-700 p-4 rounded-md shadow-sm">
                Settings updated successfully.
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/settings" method="post" class="space-y-6">
            <input type="hidden" name="configId" value="${config.configId}">
            
            <div class="grid grid-cols-1 gap-6 sm:grid-cols-2">
                <div>
                    <label for="storeName" class="block text-sm font-medium text-gray-700">Store Name</label>
                    <input type="text" name="storeName" id="storeName" value="<c:out value="${config.storeName}"/>" required
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                </div>

                <div>
                    <label for="tagline" class="block text-sm font-medium text-gray-700">Tagline</label>
                    <input type="text" name="tagline" id="tagline" value="<c:out value="${config.tagline}"/>" required
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                </div>
                
                <div>
                    <label for="logoUrl" class="block text-sm font-medium text-gray-700">Logo URL</label>
                    <input type="text" name="logoUrl" id="logoUrl" value="<c:out value="${config.logoUrl}"/>"
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                </div>

                <div>
                    <label for="themeColor" class="block text-sm font-medium text-gray-700">Theme Color (Hex)</label>
                    <input type="text" name="themeColor" id="themeColor" value="<c:out value="${config.themeColor}"/>" required
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                </div>
                
                <div>
                    <label for="contactEmail" class="block text-sm font-medium text-gray-700">Contact Email</label>
                    <input type="email" name="contactEmail" id="contactEmail" value="<c:out value="${config.contactEmail}"/>" required
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                </div>
                
                <div>
                    <label for="currencyCode" class="block text-sm font-medium text-gray-700">Currency Code</label>
                    <input type="text" name="currencyCode" id="currencyCode" value="<c:out value="${config.currencyCode}"/>" required
                           class="mt-1 block w-full rounded-md border-gray-300 shadow-sm sm:text-sm">
                </div>
            </div>

            <div class="pt-4 flex justify-end">
                <button type="submit" class="inline-flex justify-center rounded-md border border-transparent py-2 px-4 text-sm font-medium text-white shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2" style="background-color: ${fn:escapeXml(storeConfig.themeColor)};">
                    Save Settings
                </button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="../footer.jsp" />
