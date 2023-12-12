<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="fav_language" value="${not empty param.fav_language ? param.fav_language : not empty fav_language ? fav_language : session.request.locale}" scope="session"/>
<fmt:setLocale value="${fav_language}" scope="session"/>
<fmt:setBundle basename="com.example.i18n.messages"/>

<nav class="navbar navbar-expand-lg navbar-light bg-light">
	<div class="container">
		<a class="navbar-brand" href="index.jsp">E-Commerce Cart</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarSupportedContent"
			aria-controls="navbarSupportedContent" aria-expanded="false"
			aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse" id="navbarSupportedContent">
			<ul class="navbar-nav ml-auto">
				<li class="nav-item"><a class="nav-link" href="index.jsp"><fmt:message key="label.home"/></a></li>
				<li class="nav-item"><a class="nav-link" href="cart.jsp"><fmt:message key="label.cart"/>
						<span class="badge badge-danger">${cart_list.size()}</span>
				</a></li>
				<c:choose>
					<c:when test="${auth != null}">
						<li class="nav-item"><a class="nav-link" href="orders.jsp"><fmt:message key="label.order"/></a></li>
						<li class="nav-item"><a class="nav-link" href="log-out"><fmt:message key="label.logout"/></a></li>
					</c:when>
					<c:when test="${auth == null}">
						<li class="nav-item"><a class="nav-link" href="login.jsp"><fmt:message key="label.login"/></a></li>
					</c:when>
				</c:choose>
				<li class="nav-item"><a class="nav-link" href="#"><fmt:message key="label.lang"/></a>
					<form action="navbar.jsp" method="post">
						
						<select id="fav_language" name="fav_language" onchange="submit()">
								<option value="en" ${fav_language=="en"? 'selected' : ''}>English</option>
								<option value="vi" ${fav_language=="vi"? 'selected' : ''}>VietNam</option>
						</select>
					</form>
				</li>
			</ul>
		</div>
	</div>
</nav>