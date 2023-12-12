<%@page import="java.text.DecimalFormat"%>
<%@page import="dao.OrderDao"%>
<%@page import="connection.DbCon"%>
<%@page import="dao.ProductDao"%>
<%@page import="model.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="fav_language" value="${not empty param.fav_language ? param.fav_language : not empty fav_language ? fav_language : session.request.locale}" scope="session"/>
<fmt:setLocale value="${fav_language}" scope="session"/>
<fmt:setBundle basename="com.example.i18n.messages"/>
	<%
	DecimalFormat dcf = new DecimalFormat("#.##");
	request.setAttribute("dcf", dcf);
	User auth = (User) request.getSession().getAttribute("auth");
	List<Order> orders = null;
	if (auth != null) {
	    request.setAttribute("person", auth);
	    OrderDao orderDao  = new OrderDao(DbCon.getConnection());
		orders = orderDao.userOrders(auth.getId());
		request.setAttribute("orders", orders);
	}else{
		response.sendRedirect("login.jsp");
	}
	ArrayList<Cart> cart_list = (ArrayList<Cart>) session.getAttribute("cart-list");
	if (cart_list != null) {
		request.setAttribute("cart_list", cart_list);
	}
	
	%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/includes/head.jsp"%>
<title>E-Commerce Cart</title>
</head>
<body>


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
						<li class="nav-item"><a class="nav-link" href="register.jsp"><fmt:message
										key="label.register" /></a></li>
					</c:when>
				</c:choose>
				<li class="nav-item"><a class="nav-link" href="#"><fmt:message key="label.lang"/></a>
					<form action="orders.jsp" method="post">
						
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
	<div class="container">
		<div class="card-header my-3"><fmt:message key="label.all-orders"/></div>
		<table class="table table-light">
			<thead>
				<tr>
					<th scope="col"><fmt:message key="label.date"/></th>
					<th scope="col"><fmt:message key="label.name"/></th>
					<th scope="col"><fmt:message key="label.category"/></th>
					<th scope="col"><fmt:message key="label.quantity"/></th>
					<th scope="col"><fmt:message key="label.price"/></th>
					<th scope="col"><fmt:message key="label.cancel"/></th>
				</tr>
			</thead>
			<tbody>
			<c:if test="${orders!=null}">
				<c:forEach var="o" items="${orders}">
					<tr>
						<td>${o.date}</td>
						<td>${o.name}</td>
						<td>${o.category}</td>
						<td>${o.quantity}</td>
						<td>$${dcf.format(o.price)}</td>
						<td><a class="btn btn-sm btn-danger" href="cancel-order?id=${o.orderId}"><fmt:message key="label.cancel-order"/></a></td>
					</tr>
				</c:forEach>
			</c:if>
			
			</tbody>
		</table>
	</div>
	<%@include file="/includes/footer.jsp"%>
</body>
</html>