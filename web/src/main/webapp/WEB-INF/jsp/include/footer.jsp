<%@ page contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<fmt:setBundle basename="org.akaza.openclinica.i18n.words" var="resword"/>
<fmt:setBundle basename="org.akaza.openclinica.i18n.licensing" var="licensing"/>

<!-- END MAIN CONTENT AREA -->
</td>
            </tr>
        </table></td></tr></table>

<script type="text/javascript" src="${pageContext.request.contextPath}/includes/wz_tooltip/wz_tooltip.js"></script>
<table border="0" cellpadding="0" width="100%"  >
            <tr>
                <td class="footer_bottom" style="width:200px">
                    <a href="https://thrombus.eu" target="new">ThrombUS+ Website</a>
                    |
                    <a href="javascript:openDocWindow('https://thrombus.eu/index.php/contact/')">Contact</a>
                </td>
                <td class="footer_bottom" >
                    <fmt:message key="footer.license.1" bundle="${licensing}"/>
                    <fmt:message key="footer.license.2" bundle="${licensing}"/>
                    <fmt:message key="footer.license.3" bundle="${licensing}"/>
                </td>

                <td  class="footer_bottom" style="width:200px;">
                    <c:set var="tooltip"><fmt:message key="footer.tooltip" bundle="${licensing}"/></c:set>

                    <div id="footer_tooltip">
                        <c:choose>
                            <c:when test="${empty tooltip}">
                                <span style="color: #789EC5;"  >
                                    <fmt:message key="footer.edition.2" bundle="${licensing}" />
                                </span> <fmt:message key="Version_release" bundle="${licensing}"/>
                            </c:when>
                            <c:otherwise>
                                <span onmouseover="Tip('<fmt:message key="footer.tooltip" bundle="${licensing}"/>')" onmouseout="UnTip()" style="color: #789EC5;"  >
                                    <fmt:message key="footer.edition.2" bundle="${licensing}" />
                                </span> <fmt:message key="Version_release" bundle="${licensing}"/>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </td>
            </tr>
        </table>

<!-- End Footer -->
<link rel="shortcut icon" type="image/x-icon" href="${pageContext.request.contextPath}/images/favicon.ico">



</body>

</html>
