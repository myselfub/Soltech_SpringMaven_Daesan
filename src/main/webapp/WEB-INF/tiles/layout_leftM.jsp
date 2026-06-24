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
		<script charset="UTF-8" src="<%=request.getContextPath()%>/resources/js/biznexus/bizManagerCommon.js"></script>
		<script src="<%=request.getContextPath()%>/resources/js/jsgrid/jsgrid.js"></script>
		<script src="<%=request.getContextPath()%>/resources/js/sexyalertbox/sexyalertbox.v1.2.jquery.js"></script>

		<script src="<%=request.getContextPath()%>/resources/js/common.js"></script>

		<script src="<%=request.getContextPath()%>/resources/js/moment.js"></script>

		<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/resources/js/jsgrid/jsgrid.min.css" />
		<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/resources/js/jsgrid/jsgrid-theme.min.css" />
		<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/resources/js/jquery-ui/jquery-ui.min.css"> 
		<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/resources/js/jquery-ui/jquery-ui.theme.min.css">
		<link type="text/css" rel="stylesheet" href="<%=request.getContextPath()%>/resources/js/sexyalertbox/sexyalertbox.css" >
		
		<link rel="stylesheet" href="<%=request.getContextPath()%><tiles:getAsString name = "css"/>"/>
		<link rel="stylesheet" href="<%=request.getContextPath()%><tiles:getAsString name = "page_css"/>"/>
	</head> 
	<body>
		<div class="background-blind"></div>
		<div class="layoutBox_m">
			<div class="leftBox_m">
				<tiles:insertAttribute name="left" />
			</div>
			<div class="contentBox_m">
				<tiles:insertAttribute name="body" />
			</div>
		</div>
		
		<div id="loading-mask"></div>
	</body> 
</html>