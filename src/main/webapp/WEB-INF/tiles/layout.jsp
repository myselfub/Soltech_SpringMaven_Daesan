<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
	<head>
		<title>대산해수담수화</title>
		<link rel="icon" type="image/x-icon" href="<%=request.getContextPath()%>/resources/images/com/favicon.png">
		<script src="<%=request.getContextPath()%>/resources/js/jquery/jquery-3.5.1.min.js"></script>
		<script src="<%=request.getContextPath()%>/resources/js/jquery/jquery.validate.min.js"></script>
		<script src="<%=request.getContextPath()%>/resources/js/jquery-ui/jquery-ui.min.js"></script>
		<link rel="stylesheet" href="<%=request.getContextPath()%><tiles:getAsString name = "css"/>"/>
		<link rel="stylesheet" href="<%=request.getContextPath()%><tiles:getAsString name = "page_css"/>"/>
	</head> 
	<body>
		<div>
			<tiles:insertAttribute name="body" />
		</div>
	</body>
</html>